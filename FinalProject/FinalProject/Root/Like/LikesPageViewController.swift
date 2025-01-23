//
//  LikesPageViewController.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import UIKit
import SwiftUI

final class LikesPageViewController: UIViewController {
    private let viewModel = HomePageViewModel()
    private var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(LikePageTableViewCell.self, forCellReuseIdentifier: "LikePageTableViewCell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension LikesPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikePageTableViewCell", for: indexPath) as? LikePageTableViewCell else {
            return UITableViewCell()
        }
        let event = viewModel.events[indexPath.row]
        cell.configure(with: event)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let event = viewModel.events[indexPath.row]
        let detailsView = EventDetailsView(event: event)
        let hostingController = UIHostingController(rootView: detailsView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

final class LikePageTableViewCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .systemGray5
        return view
    }()

    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private lazy var eventNameLabel = makeLabel(fontSize: 16, weight: .bold, color: .black)
    private lazy var eventAddressLabel = makeLabel(fontSize: 14, weight: .regular, color: .darkGray)
    private lazy var eventPriceLabel = makeLabel(fontSize: 14, weight: .bold, color: .systemGreen)
    private lazy var eventDateLabel = makeLabel(fontSize: 14, weight: .regular, color: .darkGray)

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(eventImageView)
        containerView.addSubview(mainStackView)

        mainStackView.addArrangedSubview(eventNameLabel)
        mainStackView.addArrangedSubview(eventAddressLabel)
        mainStackView.addArrangedSubview(eventPriceLabel)
        mainStackView.addArrangedSubview(eventDateLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            eventImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            eventImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            eventImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            eventImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),

            mainStackView.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with event: Event) {
        eventImageView.image = UIImage(named: event.photos.first ?? "")
        eventNameLabel.text = event.name
        eventAddressLabel.text = event.location.address ?? "No address"
        eventPriceLabel.text = "ფასი: $\(String(format: "%.2f", event.price.startPrice))"
        eventDateLabel.text = "თარიღი: \(event.date.startDate)"
    }

    private func makeLabel(fontSize: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = color
        return label
    }
}
