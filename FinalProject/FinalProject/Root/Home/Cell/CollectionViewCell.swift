//
//  CollectionViewCell.swift
//  FinalProject
//
//  Created by Apple on 15.01.25.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    private var isFavorite: Bool
    
    var onLikeButtonTapped: ((Bool) -> Void)?
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.5).cgColor
        ]
        gradient.locations = [0.4, 1.0]
        return gradient
    }()
    
    private let blackOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private let topRowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var locationLabel = createLabel(fontSize: 16, fontName: "SourGummy-Light")
    
    private lazy var timeLabel = createLabel(fontSize: 15, fontName: "SourGummy-Light", tintColor: .red)
    
    private lazy var prite = createLabel(fontSize: 14, fontName: "SourGummy-Bold")
    
    override init(frame: CGRect) {
        isFavorite = true
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.shadowPath = UIBezierPath(
            roundedRect: containerView.bounds,
            cornerRadius: 12
        ).cgPath
        gradientLayer.frame = imageView.bounds
    }
    
    private func setupViews() {
        
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        
        imageView.layer.insertSublayer(gradientLayer, at: 0)
        
        containerView.addSubview(blackOverlayView)
        
        blackOverlayView.addSubview(containerStack)
        
        topRowStack.addArrangedSubview(locationLabel)
        topRowStack.addArrangedSubview(timeLabel)
        topRowStack.addArrangedSubview(prite)
        
        containerStack.addArrangedSubview(topRowStack)
        [
            containerView,
            imageView,
            blackOverlayView,
            containerStack,
            topRowStack,
            locationLabel,
            prite,
            timeLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            blackOverlayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            blackOverlayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            blackOverlayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            containerStack.topAnchor.constraint(equalTo: blackOverlayView.topAnchor, constant: 8),
            containerStack.leadingAnchor.constraint(equalTo: blackOverlayView.leadingAnchor, constant: 8),
            containerStack.trailingAnchor.constraint(equalTo: blackOverlayView.trailingAnchor, constant: -8),
            containerStack.bottomAnchor.constraint(equalTo: blackOverlayView.bottomAnchor, constant: -8),
        ])
    }
    
    private func createLabel(fontSize: CGFloat, fontName: String, tintColor: UIColor = .white) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: fontName, size: fontSize)
        label.textColor = .white
        label.tintColor = tintColor
        
        return label
    }
    
    func configure(event: Event) {
        locationLabel.text = event.location.city
        timeLabel.text = "\(event.date.startDate)"
        prite.text = "\(Int(event.price.startPrice)) $"
        if let imageName = event.photos.first {
            imageView.image = UIImage(named: imageName)
        } else {
            imageView.image = nil
        }
    }
}

#Preview {
    HomePageViewController()
}

