//
//  LaunchScreenViewController.swift
//  NewsApp
//
//  Created by Alex Matsenko on 05.09.2024.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "TOP"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.alpha = 0 // Сховати лейбл до початку анімації
        return label
    }()
    
    private let newsLabel: UILabel = {
        let label = UILabel()
        label.text = "NEWS"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.alpha = 0 // Сховати лейбл до початку анімації
        return label
    }()
    
    private let applicationLabel: UILabel = {
        let label = UILabel()
        label.text = "APPLICATION"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.alpha = 0 // Сховати лейбл до початку анімації
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        animateLabels()
    }
    
    private func setupViews() {
        [topLabel, newsLabel, applicationLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            
            newsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newsLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10),
            
            applicationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applicationLabel.topAnchor.constraint(equalTo: newsLabel.bottomAnchor, constant: 10)
        ])
    }
    
    private func animateLabels() {
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
            self.topLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
                self.newsLabel.alpha = 1.0
            }) { _ in
                UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
                    self.applicationLabel.alpha = 1.0
                }) { _ in
                    // Перехід до основного контролера після анімації
                    self.transitionToMainScreen()
                }
            }
        }
    }
    
    private func transitionToMainScreen() {
        // Створення та показ основного контролера
        let newsListViewController = NewsListViewController()
        let navigationController = UINavigationController(rootViewController: newsListViewController)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)

        }

    }

