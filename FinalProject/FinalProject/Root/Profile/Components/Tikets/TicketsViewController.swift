//
//  TicketsViewControllerC.swift
//  FinalProject
//
//  Created by Apple on 26.01.25.
//


import UIKit

class TicketsViewController: UIViewController, TicketsViewModelDelegate {
    private let viewModel = TicketsViewModel()
    private let tableView = UITableView()
    
    private var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        fetchEvents()
        view.backgroundColor = .pageBack
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "ბილეთები"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TicketCell.self, forCellReuseIdentifier: "TicketCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func fetchEvents() {
        viewModel.fetchUserEvents()
    }
    
    // MARK: - TicketsViewModelDelegate
    
    func didLoadEvents(_ events: [Event]) {
        self.events = events
        tableView.reloadData()
    }
    
    func didFailWithError(_ error: Error) {
        let alert = UIAlertController(title: "შეცდომა", message: "ბილეთების მონაცემების მიღება ვერ მოხერხდა: \(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension TicketsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as? TicketCell else {
            return UITableViewCell()
        }
        
        let event = events[indexPath.row]
        guard let userId = UserDefaultsManager.shared.getUserId() else { return cell }
        
        let qrString = "\(userId)\(event.id)"
        let qrImage = QRCodeManager.generateQRCode(from: qrString)
        
        cell.configure(with: event, qrImage: qrImage)
        cell.backgroundColor = .tableCellBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

