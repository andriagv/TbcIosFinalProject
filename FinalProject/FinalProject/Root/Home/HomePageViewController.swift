//
//  HomePageViewController.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import UIKit
import SwiftUI

final class HomePageViewController: UIViewController {
    
    private var viewModel: HomePageViewModelProtocol
    
    init(viewModel: HomePageViewModelProtocol = HomePageViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView = UIView()
    
    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let underView: UIView = {
        let underView = UIView()
        underView.backgroundColor = UIColor(named: "PageBackColor") ?? .systemBackground
        underView.layer.cornerRadius = 20
        underView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        underView.clipsToBounds = true
        return underView
    }()
    
    private lazy var popularLabel: UILabel = {
        let label = UILabel()
        label.text = "Most Popular places".localized()
        label.font = UIFont(name: "SourGummy-Bold", size: 20)
        label.textColor = .label
        return label
    }()
    
//    private lazy var seeMoreButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("See more".localized(), for: .normal)
//        button.setTitleColor(.systemGray, for: .normal)
//        button.titleLabel?.font = UIFont(name: "SourGummy-ThinItalic", size: 16)
//        return button
//    }()
    
    private lazy var popularCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 290, height: 160)
        layout.minimumLineSpacing = 5
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private lazy var forouLabel: UILabel = {
        let label = UILabel()
        label.text = "For you".localized()
        label.font = UIFont(name: "SourGummy-Bold", size: 20)
        return label
    }()
    
    private lazy var recommendedForYouTableView: UITableView = {
        let tb = UITableView()
        tb.backgroundColor = .clear
        return tb
    }()
    
    private lazy var partnersLabel: UILabel = {
        let label = UILabel()
        label.text = "Partners".localized()
        label.font = UIFont(name: "SourGummy-Bold", size: 20)
        return label
    }()
    
    private lazy var partnersStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .equalSpacing
        
        let imageNames = ["prt1", "prt2", "prt3", "prt4"]
        for name in imageNames {
            let imageView = UIImageView()
            imageView.image = UIImage(named: name)
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
            stack.addArrangedSubview(imageView)
        }
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollAndContent()
        setupHeaderView()
        setupUnderView()
        setupCollectionSection()
        setupTableSection()
        setupPartniorStackView()
        
        viewModel.onDataLoaded = { [weak self] in
            guard let self = self else { return }
            self.popularCollectionView.reloadData()
            self.recommendedForYouTableView.reloadData()
        }
        viewModel.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        popularLabel.text = "Most Popular places".localized()
        forouLabel.text = "For you".localized()
        partnersLabel.text = "Partners".localized()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup Scroll & Content
    private func setupScrollAndContent() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupHeaderView() {
        contentView.addSubview(headerImageView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -50),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalTo: headerImageView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupUnderView() {
        contentView.addSubview(underView)
        underView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor),
            underView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            underView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            underView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupCollectionSection() {
        underView.addSubview(popularLabel)
        //underView.addSubview(seeMoreButton)
        underView.addSubview(popularCollectionView)
        
        popularLabel.translatesAutoresizingMaskIntoConstraints = false
        //seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        popularCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popularLabel.topAnchor.constraint(equalTo: underView.topAnchor, constant: 32),
            popularLabel.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: 16),
            
//            seeMoreButton.centerYAnchor.constraint(equalTo: popularLabel.centerYAnchor),
//            seeMoreButton.trailingAnchor.constraint(equalTo: underView.trailingAnchor, constant: -16),
            
            popularCollectionView.topAnchor.constraint(equalTo: popularLabel.bottomAnchor, constant: 8),
            popularCollectionView.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: 6),
            popularCollectionView.trailingAnchor.constraint(equalTo: underView.trailingAnchor),
            popularCollectionView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
        popularCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    private func setupTableSection() {
        underView.addSubview(forouLabel)
        underView.addSubview(recommendedForYouTableView)
        
        forouLabel.translatesAutoresizingMaskIntoConstraints = false
        recommendedForYouTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            forouLabel.topAnchor.constraint(equalTo: popularCollectionView.bottomAnchor, constant: 16),
            forouLabel.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: 16),
            forouLabel.trailingAnchor.constraint(equalTo: underView.trailingAnchor, constant: -16),
            
            recommendedForYouTableView.topAnchor.constraint(equalTo: forouLabel.bottomAnchor, constant: 8),
            recommendedForYouTableView.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: 16),
            recommendedForYouTableView.trailingAnchor.constraint(equalTo: underView.trailingAnchor, constant: -16),
            recommendedForYouTableView.heightAnchor.constraint(equalToConstant: 480)
        ])
        
        recommendedForYouTableView.isScrollEnabled = false
        
        recommendedForYouTableView.dataSource = self
        recommendedForYouTableView.delegate = self
        recommendedForYouTableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    private func setupPartniorStackView() {
        underView.addSubview(partnersLabel)
        underView.addSubview(partnersStackView)
        
        partnersLabel.translatesAutoresizingMaskIntoConstraints = false
        partnersStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            partnersLabel.topAnchor.constraint(equalTo: recommendedForYouTableView.bottomAnchor, constant: 16),
            partnersLabel.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: 16),
            
            partnersStackView.topAnchor.constraint(equalTo: partnersLabel.bottomAnchor, constant: 16),
            partnersStackView.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: 30),
            partnersStackView.trailingAnchor.constraint(equalTo: underView.trailingAnchor, constant: -30),
            
            partnersStackView.bottomAnchor.constraint(equalTo: underView.bottomAnchor, constant: -24)
        ])
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HomePageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.eventsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionViewCell",
            for: indexPath
        ) as? CollectionViewCell else {
            fatalError("CollectionViewCell ვერ მოიძებნა")
        }
        
        let event = viewModel.events[indexPath.row]
        cell.configure(event: event)
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.layer.shadowOpacity = 0.3
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        
        let event = viewModel.events[indexPath.row]
        let detailsView = EventDetailsView(event: event)
        let hostingController = UIHostingController(rootView: detailsView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        viewModel.forYouEventsCount()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "TableViewCell",
            for: indexPath
        ) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let event = viewModel.forYouEvents[indexPath.row]
        cell.configure(event: event)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath
    ) {
        let event = viewModel.forYouEvents[indexPath.row]
        let detailsView = EventDetailsView(event: event)
        let hostingController = UIHostingController(rootView: detailsView)
        hostingController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

#Preview() {
    HomePageViewController()
}
