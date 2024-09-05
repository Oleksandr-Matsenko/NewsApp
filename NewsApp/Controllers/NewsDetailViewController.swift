//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Alex Matsenko on 03.09.2024.
//

import UIKit

import UIKit

class NewsDetailViewController: UIViewController {
    // Модель для відображення
    var detailModel: NewsViewModel?

    // Створення в'ю
    private let newsDetailView = NewsDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    
    }
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(newsDetailView)
        newsDetailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        newsDetailView.detailModel = detailModel
        navigationItem.largeTitleDisplayMode = .never
    }
}
