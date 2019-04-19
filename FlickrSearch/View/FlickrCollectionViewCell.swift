//
//  FlickrCollectionViewCell.swift
//  FlickrSearch
//
//  Created by Varun D Patel on 4/19/19.
//  Copyright © 2019 Varun Patel. All rights reserved.
//

import UIKit

class FlickrCollectionViewCell: UICollectionViewCell {
    var flickrImage: UIImage? {
        didSet {
            if let image = flickrImage {
                imageView.image = image
            }
        }
    }
    
    var flickrImageTitle: String? {
        didSet {
            titleLabel.text = flickrImageTitle
        }
    }
    
    private var imageView = UIImageView(frame: .zero)
    private var titleLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFlickrTableViewCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        flickrImageTitle = ""
        flickrImage = UIImage(named: "placeholder")
    }
    
    private func setupFlickrTableViewCell() {
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
