//
//  UIStackView.swift
//  NewsApp
//
//  Created by Alex Matsenko on 02.09.2024.
//

import UIKit
extension UIStackView {
    func makeCustomStackView(axis: NSLayoutConstraint.Axis) {
        self.axis = axis
        self.spacing = 10
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
