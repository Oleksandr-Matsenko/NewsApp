//
//  UILable.swift
//  NewsApp
//
//  Created by Alex Matsenko on 02.09.2024.
//

import UIKit
extension UILabel {
    func makeCustomLabel(color: UIColor = .systemBlue, font: UIFont = .systemFont(ofSize: 15, weight: .bold)) {
        self.textColor = color
        self.font = font
        self.textAlignment = .natural
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
