//
//  NewsTableViewCell.swift
//  NewsAPI_TableView
//
//  Created by Mac on 08.12.2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(newsDescriptionLabel)
        contentView.addSubview(newsImageView)
        NSLayoutConstraint.activate(staticConstraints())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    static let identifier = Constant.identifier
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .monospacedDigitSystemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let newsDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .monospacedDigitSystemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        
            var constraints = [NSLayoutConstraint]()
            
            constraints.append(contentsOf: [
                containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                
                newsTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
                newsTitleLabel.heightAnchor.constraint(equalToConstant: Constant.titleHeight),
                newsTitleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: Constant.inset),
                newsTitleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -Constant.imageWidth - Constant.inset * 3),
            
                newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor),
                newsDescriptionLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: Constant.inset),
                newsDescriptionLabel.rightAnchor.constraint(equalTo: newsTitleLabel.rightAnchor),
                newsDescriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constant.inset),
                
                newsImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -Constant.inset),
                newsImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constant.inset),
                newsImageView.heightAnchor.constraint(equalToConstant: Constant.imageHeight),
                newsImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constant.inset),
                newsImageView.widthAnchor.constraint(equalToConstant: Constant.imageWidth),
                
            ])
            
            return constraints
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
        
        ImageLoader.shared.loadImage(from: viewModel.imageUrl) { [weak self] image in
            DispatchQueue.main.async {
                self?.newsImageView.image = image
            }
        }
    }
}

private extension NewsTableViewCell {
    enum Constant {
        static let identifier = "NewsTableViewCell"
        static let inset: CGFloat = 10
        static let imageWidth: CGFloat = 140
        static let imageHeight: CGFloat = Constant.imageWidth
        static let titleHeight: CGFloat = 50
    }
}
