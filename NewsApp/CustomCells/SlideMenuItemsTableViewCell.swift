//
//  SlideMenuItemsCellTableViewCell.swift
//  NewsApp
//
//  Created by Alex Matsenko on 04.09.2024.
//

import UIKit

final class SlideMenuItemsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "SlideMenucell"
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.makeCustomImageView()
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel(color: .systemBlue, font: .systemFont(ofSize: 20))
        return label
    }()
    
// MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        [iconImageView, titleLabel].forEach{
            contentView.addSubview($0)
        }
        setupConstraints()
    }
    private func setupConstraints() {
        // Layout constraints
        NSLayoutConstraint.activate([
                    iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    iconImageView.widthAnchor.constraint(equalToConstant: 24),
                    iconImageView.heightAnchor.constraint(equalToConstant: 24),
                    
                    titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
                    titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    
                    // Ensure contentView has non-zero height
                    contentView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8),
                    contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
                ])
      }
    // MARK: - Config Cell
    func configCell(imageName: String, title: String) {
        iconImageView.image = UIImage(systemName: imageName)
        titleLabel.text = title
    }
        
}

