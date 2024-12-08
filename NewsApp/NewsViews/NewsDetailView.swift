//
//  NewsDetailView.swift
//  NewsApp
//
//  Created by Alex Matsenko on 03.09.2024.
//

import UIKit

final class NewsDetailView: UIView {
    // MARK: - UI Elements
    var detailModel: NewsViewModel? {
        didSet {
            if let detailModel = detailModel {
                self.titleLabel.text = detailModel.title
                self.contentLabel.text = detailModel.content
                self.descriptionLabel.text = "Description: \(detailModel.description)"
                self.authorLabel.text = "Author: \(detailModel.author ?? "Unknown author")"
                self.nameLabel.text = "Post by: \(detailModel.name)"
               
                if let formattedDate = formatDate(from: detailModel.date) {
                                    self.dateLabel.text = "Post on: \(formattedDate)"
                                } else {
                                    self.dateLabel.text = "Post on: Unknown date"
                                }
                
                guard let imageUrl = detailModel.urlToImage else {
                    print("Invalid URL...")
                    return
                }
                NetworkManager.shared.getImage(urlString: imageUrl) { [weak self] data in
                    guard let self = self else { return }
                    if let data = data {
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data)
                        }
                    } else {
                        print("Can't fetch Images...")
                    }
                }
            }
        }
    }

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.makeCustomImageView(cornerRadius: 10)
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel(color: .brown)
        label.numberOfLines = 0
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel(color: .black)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel(color: .systemGray)
        label.numberOfLines = 0
        return label
    }()
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel(color: .systemGray)
        label.numberOfLines = 0
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel(color: .systemGray)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .tertiarySystemFill
        [imageView, titleLabel, descriptionLabel, contentLabel, authorLabel, nameLabel, dateLabel].forEach {
            addSubview($0)
        }
        
        setupConstraints()
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            // ImageView Constraints
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            // TitleLabel Constraints
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            // DescriptionLabel Constraints
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            //ContantLabel
            contentLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            // AuthorLabel
            authorLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 5),
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            //NameLabel
            nameLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            //DateLabel
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    private func formatDate(from dateString: String) -> String? {
            let dateFormatter = ISO8601DateFormatter()
            if let date = dateFormatter.date(from: dateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateStyle = .medium
                outputFormatter.timeStyle = .none
                outputFormatter.locale = Locale.current
                return outputFormatter.string(from: date)
            }
            return nil
        }
}
