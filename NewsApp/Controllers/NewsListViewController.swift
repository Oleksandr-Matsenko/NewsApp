import UIKit
import SafariServices

import UIKit
import SafariServices

class NewsListViewController: UIViewController {
    // MARK: - Properties
    private var newsArticles = [NewsViewModel]()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        return tableView
    }()
    private let slideView = SlideMenuView()
    private let menuWidth: CGFloat = 300
    private var isMenuVisible: Bool = false
    var savedNews = [NewsViewModel]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchNews()
        setupSlideMenu()
        setupPanGesture()
        setupTapSlideMenu()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .darkGray
        tableView.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorStyle = .singleLine
        // Constraints for tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchNews() {
        NetworkManager.shared.fetchNews { [weak self] articles in
            guard let self = self else { return }
            guard let articles = articles else { return }
            self.newsArticles = articles.map { NewsViewModel(newsArticles: $0) }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private func setupSlideMenu() {
        view.addSubview(slideView)
        slideView.backgroundColor = .systemBackground
        slideView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slideView.widthAnchor.constraint(equalToConstant: menuWidth),
            slideView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55),
            slideView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -menuWidth), // Start hidden
            slideView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        // Setup large title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Top News"
        // Setup left button
        let menuButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "line.3.horizontal.circle"), target: self, action: #selector(slideMenuTaped))
        menuButton.tintColor = .systemGray.withAlphaComponent(0.7)
        navigationItem.leftBarButtonItem = menuButton
    }

    @objc private func slideMenuTaped() {
        isMenuVisible.toggle()
        let targetX = isMenuVisible ? 0 : -menuWidth

        UIView.animate(withDuration: 0.3) {
            self.slideView.frame.origin.x = targetX
        }

        let buttonImage = isMenuVisible ? UIImage(systemName: "x.square") : UIImage(systemName: "line.3.horizontal.circle")
        navigationItem.leftBarButtonItem?.image = buttonImage
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if gesture.state == .changed {
            let newOriginX = min(0, max(-menuWidth, slideView.frame.origin.x + translation.x))
            slideView.frame.origin.x = newOriginX
            gesture.setTranslation(.zero, in: view)
        } else if gesture.state == .ended {
            let velocity = gesture.velocity(in: view).x
            let isMovingRight = velocity > 0
            let shouldShowMenu = isMovingRight || slideView.frame.origin.x > -menuWidth / 2
            toggleSlideMenu(isVisible: shouldShowMenu)
        }
    }
    
    private func toggleSlideMenu(isVisible: Bool) {
        let targetX = isVisible ? 0 : -menuWidth

        UIView.animate(withDuration: 0.3) {
            self.slideView.frame.origin.x = targetX
        }

        isMenuVisible = isVisible
        let buttonImage = isMenuVisible ? UIImage(systemName: "x.square") : UIImage(systemName: "line.3.horizontal.circle")
        navigationItem.leftBarButtonItem?.image = buttonImage
    }
    private func setupTapSlideMenu(){
        slideView.didSelectMenuItem = {[weak self] index in
            guard let self = self else {return}
            self.handleMenuSelection(at: index)}
    }
    private func handleMenuSelection(at index: Int) {
        switch index {
                case 0:
                    // Handle "Upgraded to Pro"
                    print("Navigate to Pro upgrade screen")
                case 1:
                let savedVC = SavedNewsViewController(savedNews: savedNews)
                navigationController?.pushViewController(savedVC, animated: true)
                    print("Navigate to Saved News screen")
                case 2:
                    // Handle "Settings"
                    print("Navigate to Settings screen")
                case 3:
                    // Handle "Rate App"
                    print("Open App Rating screen")
                case 4:
                    // Handle "Contact Us"
                    print("Navigate to Contact Us screen")
                case 5:
                    // Handle "Profile"
                    print("Navigate to Profile screen")
                case 6:
                    // Handle "Notifications"
                    print("Navigate to Notifications screen")
                case 7:
                    // Handle "Help & Support"
                    print("Navigate to Help & Support screen")
                case 8:
                    // Handle "Share App"
                    print("Share App with others")
                case 9:
                    // Handle "Delete Account"
                    print("Delete Account confirmation")
                default:
                    break
                }
                
                // Optionally hide the slide menu after selection
                slideMenuTaped()
            }

    }


// MARK: - UITableViewDataSource
extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError("Failed to dequeue NewsTableViewCell")
        }
        cell.newsModel = newsArticles[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170 // Set the desired row height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNews = newsArticles[indexPath.row]
        
        // Create alert controller
        let alertVC = UIAlertController(title: selectedNews.title, message: nil, preferredStyle: .actionSheet)
        
        // Add actions
        let openInAppAction = UIAlertAction(title: "Open in App", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let detailVC = NewsDetailViewController()
            detailVC.detailModel = selectedNews
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        let openInSafariAction = UIAlertAction(title: "Open in Safari", style: .default) { _ in
            if let urlString = selectedNews.url, let url = URL(string: urlString) {
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(openInAppAction)
        alertVC.addAction(openInSafariAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
}
extension NewsListViewController: NewsTableViewCellDelegat {
    func removedFromSaved(_ news: NewsViewModel) {
        if let index = savedNews.firstIndex(where: {$0.title == news.title } ){
            savedNews.remove(at: index)
            print("Removed news with Title: \(news.title)")
        }
    }
    
    func addToSaved(_ news: NewsViewModel) {
        if !savedNews.contains(where: {$0.title == news.title}) {
            savedNews.append(news)
            _ = SavedNewsViewController(savedNews: savedNews)
            print("Saved news, with Title: \(news.title)")
        }
        
    }
    
    
}
