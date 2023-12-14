//
//  NewsTableViewCell.swift
//  NewsAPI_TableView
//
//  Created by Mac on 08.12.2023.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let description: String
    let imageUrl: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        description: String,
        imageUrl: URL?
    ) {
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
    }
}

class NewsTableViewCell: UITableViewCell {

    static let identifier = NewsCellConstant.identifier
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .monospacedDigitSystemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let newsDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .monospacedDigitSystemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(newsDescriptionLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset: CGFloat = 10
        let imageWidth: CGFloat = 140
        let titleHeight: CGFloat = 70
        
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: inset),
            newsTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -imageWidth - inset * 3),
            newsTitleLabel.heightAnchor.constraint(equalToConstant: titleHeight),
            
            newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor),
            newsDescriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: inset),
            newsDescriptionLabel.rightAnchor.constraint(equalTo: newsTitleLabel.rightAnchor),
            newsDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            
            newsImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -inset),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            newsImageView.widthAnchor.constraint(equalToConstant: imageWidth),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        newsDescriptionLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        newsDescriptionLabel.text = viewModel.description
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageUrl {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}

private extension NewsTableViewCell {
    enum NewsCellConstant {
        static let identifier = "NewsTableViewCell"
    }
}
