//
//  SavedNewsViewController.swift
//  NewsApp
//
//  Created by Alex Matsenko on 05.09.2024.
//

import UIKit

import UIKit

class SavedNewsViewController: UIViewController {
    var savedNews: [NewsViewModel]

    // MARK: - Initializer
    init(savedNews: [NewsViewModel]) {
        self.savedNews = savedNews
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved News"
        view.backgroundColor = .white
        
        // Тут можете налаштувати SavedNewsView і передати в нього збережені новини
        let savedNewsView = SavedNewsView()
        savedNewsView.savedNews = savedNews
        view.addSubview(savedNewsView)
        savedNewsView.frame = view.bounds // Налаштовуємо фрейм для всього екрану
    }
}
