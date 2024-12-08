//
//  SlideMenuView.swift
//  NewsApp
//
//  Created by Alex Matsenko on 04.09.2024.
//

import UIKit

final class SlideMenuView: UIView {
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .lightGray.withAlphaComponent(0.2)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(SlideMenuItemsTableViewCell.self, forCellReuseIdentifier: SlideMenuItemsTableViewCell.identifier)
        return table
    }()
    
    private let menuItems: [(imageName: String, title: String)] = [
        ("star.fill", "Upgraded to Pro"),
        ("bookmark.fill", "Show Saved"),
        ("gearshape.fill", "Settings"),
        ("hand.thumbsup.fill", "Rate App"),
        ("envelope.fill", "Contact Us"),
        ("person.fill", "Profile"),
        ("bell.fill", "Notifications"),
        ("questionmark.circle.fill", "Help & Support"),
        ("square.and.arrow.up.fill", "Share App"),
        ("trash.fill", "Delete Account")
    ]
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel(color: .systemGray)
        label.text = "Version 1.0"
        return label
    }()
    private let menuSize: CGFloat = 300.0
    var didSelectMenuItem: ((Int) -> Void)?
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(tableView)
        addSubview(versionLabel)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        layer.cornerRadius = 20
        layer.borderColor = UIColor.systemGray.cgColor
        layer.masksToBounds = true
        layer.borderWidth = 1
        backgroundColor = .systemGray.withAlphaComponent(0.2)
    }
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            //VersionLabel
            versionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            versionLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -40),
        ])
    }
    
//    // MARK: - Public Methods
//    func toggleMenu(isVisible: Bool, completion: ((Bool) -> Void)? = nil) {
//        UIView.animate(withDuration: 0.3, animations: {
//            self.frame.origin.x = isVisible ? 0 : -self.menuSize
//        }, completion: completion)
//    }
}

// MARK: - UITableViewDataSource
extension SlideMenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SlideMenuItemsTableViewCell.identifier, for: indexPath) as? SlideMenuItemsTableViewCell else {
            assertionFailure("Cannot create Cell")
            return UITableViewCell()
        }
        let item = menuItems[indexPath.row]
        cell.configCell(imageName: item.imageName, title: item.title)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SlideMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        didSelectMenuItem?(indexPath.row)
        
        
           DispatchQueue.main.async {
               tableView.deselectRow(at: indexPath, animated: true)
           }
       }
    }

