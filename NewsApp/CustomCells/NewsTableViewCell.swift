import UIKit
protocol NewsTableViewCellDelegat: AnyObject {
    func addToSaved(_ news: NewsViewModel )
    func removedFromSaved(_ news: NewsViewModel)
}

class NewsTableViewCell: UITableViewCell {
    // MARK: - UI Elements
    weak var delegate: NewsTableViewCellDelegat?
    static let identifier = "NewsTableViewCell"
    var newsModel: NewsViewModel? {
        didSet {
            if let newsModel = newsModel {
                titleLabel.text = "\(newsModel.title)"
                nameLabel.text = "Source: \(newsModel.name)"
                authorLabel.text = "Author: \(newsModel.author ?? "Unknown author")"
                descriptionLabel.text = "Description: \(newsModel.description)"
                
                if let imageURLString = newsModel.urlToImage, !imageURLString.isEmpty, imageURLString != "No image" {
                    print("URL string: \(imageURLString)")
                    NetworkManager.shared.getImage(urlString: imageURLString) { [weak self] data in
                        guard let self = self else { return }
                        if let data = data {
                            DispatchQueue.main.async {
                                self.newsImageView.image = UIImage(data: data)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.newsImageView.image = UIImage(systemName: "photo.artframe")
                                print("Failed to load image, using placeholder")
                            }
                        }
                    }
                }
            }
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel(color: Constant.Labels.secondarryFontColor, font: Constant.Labels.mainFont)
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .natural
        label.textColor = .systemBlue
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel(color: Constant.Labels.secondarryFontColor, font: Constant.Labels.secondarryFont)
        label.numberOfLines = 3
        label.textColor = .black
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel(color: Constant.Labels.secondarryFontColor, font: Constant.Labels.secondarryFont)
        label.textColor = .black
        return label
    }()
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.makeCustomLabel(color: Constant.Labels.secondarryFontColor, font: Constant.Labels.secondarryFont)
        label.textColor = .black
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let view = UIImageView()
        view.makeCustomImageView()
        return view
    }()
    private lazy var savedNewsButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let image = UIImage(systemName: "bookmark.square.fill", withConfiguration: configuration)
        button.tintColor = .systemGray3
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(savedTaped), for: .touchUpInside)
        return button
    }()
    private lazy var savedLabel: UILabel = {
        let label = UILabel()
        label.text = "Saved.."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 10, weight: .regular, width: .condensed)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var changeIcon: UIButton {
        return savedNewsButton
    }

    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        [titleLabel,descriptionLabel, nameLabel, authorLabel, newsImageView, savedNewsButton, savedLabel].forEach {
            contentView.addSubview($0)} 
        setupCell()
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
         
            // DescriptionLabel
           
            // TitleLabel
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -2),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor,constant: -2),
            
            nameLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -2),
            // AuthorLabel
            authorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -2),
            
            
            // ImageView
            newsImageView.widthAnchor.constraint(equalToConstant: 160),
            newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            newsImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 170),
            newsImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            //SavedNewsButton
            savedNewsButton.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -5),
            savedNewsButton.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor),
            //SavedLabel
            savedLabel.trailingAnchor.constraint(equalTo: savedNewsButton.leadingAnchor, constant: -2),
            savedLabel.centerYAnchor.constraint(equalTo: savedNewsButton.centerYAnchor)
        ])
    }
    @objc private func savedTaped() {
        let savedIsActive = savedNewsButton.isSelected
        savedNewsButton.tintColor = savedIsActive ? .systemGray3 : .systemBlue
        savedNewsButton.isSelected = !savedIsActive
        savedLabel.isHidden = false
        savedLabel.text = savedIsActive ? "Removed\nfrom Favorite" : "Saved\nto Favorite"
        savedLabel.textColor = !savedIsActive ? .systemGreen : .systemRed

        if !savedIsActive {
            guard let news = newsModel else {return}
            delegate?.addToSaved(news)
        } else {
            guard let news = newsModel else {return}
            delegate?.removedFromSaved(news)
            
        }
        buttonAnimate()
        titleAnimate()
        
    }
    private func setupCell() {
        // Background color and rounded corners
              backgroundColor = .clear
              contentView.layer.cornerRadius = 15
              contentView.layer.masksToBounds = true
              contentView.backgroundColor = UIColor.systemGray6

              // Shadow for cell
              layer.shadowColor = UIColor.black.cgColor
              layer.shadowOpacity = 0.3
              layer.shadowOffset = CGSize(width: 0, height: 5)
              layer.shadowRadius = 10
              layer.masksToBounds = false
    }
    private func titleAnimate() {
        UIView.animate(withDuration: 0.1, delay: 1.0, options: .curveEaseInOut) {
            self.savedLabel.alpha = 0
        } completion: { _ in
            self.savedLabel.isHidden = true
            self.savedLabel.alpha = 1
        }
    }
    private func buttonAnimate(){
        UIView.animate(withDuration: 0.3, animations: {
              self.savedNewsButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
          }) { _ in
              UIView.animate(withDuration: 0.3, animations: {
                  self.savedNewsButton.transform = CGAffineTransform.identity
              })
          }
    }
    }




private enum Constant {
    enum Labels {
        static let mainFont: UIFont = .monospacedSystemFont(ofSize: 15, weight: .heavy)
        static let secondarryFont: UIFont = .systemFont(ofSize: 10, weight: .regular)
        static let mainFontColor: UIColor = .black
        static let secondarryFontColor: UIColor = .gray
    }
}
