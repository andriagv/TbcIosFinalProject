//
//  TicketCell.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//


import UIKit

class TicketCell: UITableViewCell {
   
   // MARK: - UI Components
   private let containerView: UIView = {
       let view = UIView()
       view.backgroundColor = .systemBackground
       view.layer.cornerRadius = 12
       view.layer.shadowColor = UIColor.black.cgColor
       view.layer.shadowOpacity = 0.1
       view.layer.shadowOffset = CGSize(width: 0, height: 2)
       view.layer.shadowRadius = 4
       return view
   }()
   
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
       imageView.backgroundColor = .systemGray6
       return imageView
   }()
   
   // MARK: - Initialization
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
       setupUI()
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   // MARK: - UI Setup
   private func setupUI() {
       selectionStyle = .none
       backgroundColor = .clear
       contentView.backgroundColor = .clear
       
       [containerView, eventNameLabel, dateLabel, qrImageView].forEach {
           $0.translatesAutoresizingMaskIntoConstraints = false
       }
       
       contentView.addSubview(containerView)
       containerView.addSubview(qrImageView)
       containerView.addSubview(eventNameLabel)
       containerView.addSubview(dateLabel)
       
       NSLayoutConstraint.activate([
           containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
           containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
           containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
           containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
           
           qrImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
           qrImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
           qrImageView.heightAnchor.constraint(equalToConstant: 80),
           qrImageView.widthAnchor.constraint(equalToConstant: 80),
           
           eventNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
           eventNameLabel.leadingAnchor.constraint(equalTo: qrImageView.trailingAnchor, constant: 16),
           eventNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
           
           dateLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 8),
           dateLabel.leadingAnchor.constraint(equalTo: qrImageView.trailingAnchor, constant: 16),
           dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
           dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
       ])
   }
   
   func configure(with event: Event, qrImage: UIImage?) {
       eventNameLabel.text = event.name
       dateLabel.text = event.date.startDate
       qrImageView.image = qrImage
   }
}
