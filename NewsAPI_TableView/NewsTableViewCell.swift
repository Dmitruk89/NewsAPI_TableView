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
        
        newsTitleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 170,
            height: 70
        )
        
        newsDescriptionLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height/2
        )
        
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width - 160,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10
        )
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
