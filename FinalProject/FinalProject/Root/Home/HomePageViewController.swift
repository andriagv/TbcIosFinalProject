//
//  HomePageViewController.swift
//  FinalProject
//
//  Created by Apple on 12.01.25.
//

import UIKit
import Firebase

final class HomePageViewController: UIViewController {
    
    private let viewModel = HomePageViewModel()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    //MARK: - CollectionView elements
    private let contentView = UIView()
    
    private let underView: UIView = {
        let underView = UIView()
        underView.backgroundColor = UIColor(named: "PageBackColor")
        underView.layer.cornerRadius = 20
        underView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        underView.clipsToBounds = true
        return underView
    }()
    
    private lazy var headerLabel = makeLabel(text: nil, fontSize: 28, weight: .bold, textColor: .black, lines: 2)
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private lazy var popularLabel = makeLabel(text: "Most popular places", fontSize: 18, weight: .semibold)
    
    private let seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("See more", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SourGummy-Bold", size: 16)
        
        button.backgroundColor = .systemGreen
        
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 4
        button.layer.masksToBounds = false
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    private lazy var popularCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 290, height: 180)
        layout.minimumLineSpacing = 5
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - tableView elements
    private lazy var forouLabel = makeLabel(text: "For You", fontSize: 20, weight: .bold, textColor: .blue)
    
    private lazy var recommendedForYouTableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
       
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        
        setupHeaderView()
        setupUnderView()
        popularView()
        forYouView()
    }
    
    private func setupHeaderView() {
        contentView.addSubview(headerImageView)
        headerImageView.addSubview(headerLabel)
        
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor), // contentView, არა view
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalTo: headerImageView.widthAnchor, multiplier: 0.6),
            
            headerLabel.centerXAnchor.constraint(equalTo: headerImageView.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: headerImageView.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupUnderView() {
        contentView.addSubview(underView)
        underView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            underView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -15),
            underView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            underView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            underView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            underView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
    }
    
    private func popularView() {
        underView.addSubview(popularLabel)
        underView.addSubview(seeMoreButton)
        underView.addSubview(popularCollectionView)
        
        popularLabel.translatesAutoresizingMaskIntoConstraints = false
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        popularCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popularLabel.topAnchor.constraint(equalTo: underView.topAnchor, constant: 24),
            popularLabel.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: 16),
            
            seeMoreButton.centerYAnchor.constraint(equalTo: popularLabel.centerYAnchor),
            seeMoreButton.trailingAnchor.constraint(equalTo: underView.trailingAnchor, constant: -16),
            
            popularCollectionView.topAnchor.constraint(equalTo: popularLabel.bottomAnchor, constant: 16),
            popularCollectionView.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: 5),
            popularCollectionView.trailingAnchor.constraint(equalTo: underView.trailingAnchor),
            popularCollectionView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private func forYouView() {
        underView.addSubview(forouLabel)
        underView.addSubview(recommendedForYouTableView)
        
        recommendedForYouTableView.dataSource = self
        recommendedForYouTableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        NSLayoutConstraint.activate([
            forouLabel.topAnchor.constraint(equalTo: popularCollectionView.bottomAnchor, constant: 16),
            forouLabel.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: 16),
            forouLabel.trailingAnchor.constraint(equalTo: underView.trailingAnchor, constant: -16),
            
            recommendedForYouTableView.topAnchor.constraint(equalTo: forouLabel.bottomAnchor, constant: 16),
            recommendedForYouTableView.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: 16),
            recommendedForYouTableView.trailingAnchor.constraint(equalTo: underView.trailingAnchor, constant: -16),
            recommendedForYouTableView.bottomAnchor.constraint(equalTo: underView.bottomAnchor),
            recommendedForYouTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func makeLabel(text: String?, fontSize: CGFloat, weight: UIFont.Weight, textColor: UIColor = .black, lines: Int = 1, fontName: String = "SourGummy-Bold") -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: fontName, size: fontSize)
        label.textColor = textColor
        label.numberOfLines = lines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension HomePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell
        cell?.configure(event: viewModel.events[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}

extension HomePageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.configure(event: viewModel.events[indexPath.row])
        return cell
    }
}

#Preview {
    HomePageViewController()
}
