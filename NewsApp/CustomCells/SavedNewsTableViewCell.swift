//
//  SavedNewsTableViewCell.swift
//  NewsApp
//
//  Created by Alex Matsenko on 05.09.2024.
//

import UIKit

import UIKit

class SavedNewsTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "SavedNewsTableViewCell"
    
    var savedArticles: NewsViewModel? {
        didSet {
            guard let savedArticles = savedArticles else { return }
            self.titleLabel.text = savedArticles.title
            if let urlToImage = savedArticles.urlToImage {
                getImage(urlString: urlToImage)
            }
        }
    }
    
    // MARK: - UI Elements
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeCustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel()
        label.numberOfLines = 0 // Можливість багаторядкового тексту
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        setupConstraints()
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            newsImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            newsImageView.widthAnchor.constraint(equalToConstant: 100),
            newsImageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Image Fetching
    private func getImage(urlString: String?) {
        guard let url = urlString else { return }
        NetworkManager.shared.getImage(urlString: url) { [weak self] data in
            guard let self = self else { return }
            if let data = data {
                DispatchQueue.main.async {
                    self.newsImageView.image = UIImage(data: data)
                }
            }
        }
    }
}
