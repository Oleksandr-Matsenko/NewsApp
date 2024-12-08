//
//  UIImageView.swift
//  NewsApp
//
//  Created by Alex Matsenko on 02.09.2024.
//

import UIKit
extension UIImageView {
    func makeCustomImageView(cornerRadius: CGFloat = 10, contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.contentMode = contentMode
        self.tintColor = .systemGray
        self.backgroundColor = .systemBackground
//        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
