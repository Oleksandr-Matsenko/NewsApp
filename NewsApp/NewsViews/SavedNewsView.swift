//
//  SavedNewsView.swift
//  NewsApp
//
//  Created by Alex Matsenko on 05.09.2024.
//

import UIKit

class SavedNewsView: UIView {
    // MARK: - Properties
    var savedNews = [NewsViewModel]() {
        didSet {
//            updateUI()
        }
    }
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .lightGray.withAlphaComponent(0.1)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(SavedNewsTableViewCell.self, forCellReuseIdentifier: SavedNewsTableViewCell.identifier)
        return table
    }()
    
    private let itemsCountLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel(color: .systemGray3, font: .boldSystemFont(ofSize: 20))
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(tableView)
        addSubview(itemsCountLabel)
        updateUI()
        setupConstraints()
    }
    
    private func setupLabel() {
        itemsCountLabel.text = savedNews.isEmpty ? "Empty.." : ""
        itemsCountLabel.isHidden = !savedNews.isEmpty
    }
    
    private func updateUI() {
        setupLabel()
        tableView.reloadData()
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            itemsCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            itemsCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource
extension SavedNewsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedNewsTableViewCell.identifier, for: indexPath) as? SavedNewsTableViewCell else {
            assertionFailure("Can't create cell")
            return UITableViewCell()
        }
        let savedItem = savedNews[indexPath.row]
        cell.savedArticles = savedItem
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            savedNews.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            setupLabel()
        }
    }
}

// MARK: - UITableViewDelegate
extension SavedNewsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

