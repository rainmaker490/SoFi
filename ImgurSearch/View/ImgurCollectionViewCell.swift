//
//  ImgurCollectionViewCell.swift
//  ImgurSearch
//
//  Created by Varun D Patel on 4/19/19.
//  Copyright © 2019 Varun Patel. All rights reserved.
//

import UIKit

class ImgurCollectionViewCell: UICollectionViewCell {
    var imgurImage: UIImage? {
        didSet {
            if let image = imgurImage {
                imageView.image = image
            }
        }
    }
    
    var imgurImageTitle: String? {
        didSet {
            titleLabel.text = imgurImageTitle
        }
    }
    
    private var imageView = UIImageView(frame: .zero)
    private var titleLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImgurTableViewCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        imgurImageTitle = ""
        imgurImage = UIImage(named: "placeholder")
    }
    
    private func setupImgurTableViewCell() {
        self.backgroundColor = .white
        setupImageView()
        setupTitleLabel()
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        //DEBUG:
        //imageView.layer.borderWidth = 2.0
        //imageView.layer.borderColor = UIColor.red.cgColor
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        
        titleLabel.numberOfLines = 0
        titleLabel.font = .preferredFont(forTextStyle: .caption1)
    }
}
