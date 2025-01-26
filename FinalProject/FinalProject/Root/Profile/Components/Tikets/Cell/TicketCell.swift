//
//  TicketCell.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//


import UIKit

class TicketCell: UITableViewCell {
    
    private let eventNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [eventNameLabel, dateLabel, qrImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            eventNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventNameLabel.trailingAnchor.constraint(equalTo: qrImageView.leadingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: eventNameLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: eventNameLabel.trailingAnchor),
            
            qrImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            qrImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            qrImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            qrImageView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func configure(with event: Event, qrImage: UIImage?) {
        eventNameLabel.text = event.name
        dateLabel.text = event.date.startDate
        qrImageView.image = qrImage
    }
}
