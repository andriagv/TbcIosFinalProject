//
//  TableViewCell.swift
//  FinalProject
//
//  Created by Apple on 16.01.25.
//

import UIKit

final class TableViewCell: UITableViewCell {
    
    private var loadingTask: Task<Void, Never>?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tableCellBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var nameLabel = makeLabel(text: "ragaca", fontSize: 15, weight: .medium)
    private lazy var nameIcon = maakeIcon(iconName: "mappin.and.ellipse.circle")
        
    private lazy var dateLabel = makeLabel(text: "kaierti", fontSize: 15, weight: .medium)
    private lazy var dateIcon = maakeIcon(iconName: "calendar.badge.clock")
    
    private lazy var priceLabel = makeLabel(text: "kaierti", fontSize: 15, weight: .medium)
    private lazy var priceIcon = maakeIcon(iconName: "dollarsign.circle")
    
    private let ImageView: UIImageView = {
        let ImageView = UIImageView()
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        ImageView.contentMode = .scaleAspectFill
        ImageView.clipsToBounds = true
        ImageView.image = UIImage(systemName: "photo.fill")
        ImageView.tintColor = .systemGray4
        ImageView.layer.cornerRadius = 12
        return ImageView
    }()
    
    private lazy var mainStackView = makeStackView(axis: .horizontal, alignment: .center, spacing: 12)
    
    private lazy var detailStackView = makeStackView(axis: .vertical, alignment: .leading, spacing: 8)
    
    private lazy var nameTitleStackView = makeStackView(axis: .horizontal, alignment: .leading, spacing: 8)
    
    private lazy var priceAndDataStackView = makeStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing, spacing: 50)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadingTask?.cancel()
        ImageView.image = nil
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            ImageView.widthAnchor.constraint(equalToConstant: 80),
            ImageView.heightAnchor.constraint(equalToConstant: 80),
            
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        setupMainstackView()
    }
    
    private func setupMainstackView() {
        mainStackView.addArrangedSubview(ImageView)
        mainStackView.addArrangedSubview(detailStackView)
        
        setupDetailStackView()
    }
    
    private func setupDetailStackView() {
        let nameStackView = makeStackView(axis: .horizontal, alignment: .center, spacing: 8)
        nameStackView.addArrangedSubview(nameIcon)
        nameStackView.addArrangedSubview(nameLabel)
        
        let dateStackView = makeStackView(axis: .horizontal, alignment: .center, spacing: 8)
        dateStackView.addArrangedSubview(dateIcon)
        dateStackView.addArrangedSubview(dateLabel)
        
        let priceStackView = makeStackView(axis: .horizontal, alignment: .center, spacing: 8)
        priceStackView.addArrangedSubview(priceIcon)
        priceStackView.addArrangedSubview(priceLabel)

        detailStackView.addArrangedSubview(nameTitleStackView)
        detailStackView.addArrangedSubview(priceAndDataStackView)
        
        nameTitleStackView.addArrangedSubview(nameStackView)
        priceAndDataStackView.addArrangedSubview(dateStackView)
        priceAndDataStackView.addArrangedSubview(priceStackView)
        
        NSLayoutConstraint.activate([
            nameIcon.widthAnchor.constraint(equalToConstant: 20),
            nameIcon.heightAnchor.constraint(equalToConstant: 20),
            
            dateIcon.widthAnchor.constraint(equalToConstant: 20),
            dateIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func makeLabel(text: String?, fontSize: CGFloat, weight: UIFont.Weight, textColor: UIColor = .dateLabelTint, lines: Int = 1, fontName: String = "SourGummy-Bold") -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: fontName, size: fontSize)
        label.textColor = textColor
        label.numberOfLines = lines
        return label
    }
    
    private func maakeIcon(iconName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: iconName)
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func makeStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 10) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.alignment = alignment
        stack.distribution = distribution
        stack.spacing = spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    func configure(event: Event) {
        nameLabel.text = event.name
        dateLabel.text = event.date.startDate
        priceLabel.text = "\(Int(event.price.startPrice))"
        
        loadingTask?.cancel()
        
        loadingTask = Task { @MainActor in
            if let photoName = event.photos.first {
                do {
                    if let image = try await ImageCacheManager.shared.fetchPhoto(
                        photoName: photoName,
                        cacheType: .homePage
                    ) {
                        if !Task.isCancelled {
                            ImageView.image = image
                        }
                    }
                } catch {
                    print("Error loading image: \(error)")
                    if !Task.isCancelled {
                        ImageView.image = UIImage(named: "placeholder")
                    }
                }
            } else {
                ImageView.image = UIImage(named: "placeholder")
            }
        }
    }
}


