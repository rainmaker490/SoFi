//
//  FlickrDetailViewController.swift
//  FlickrSearch
//
//  Created by Varun D Patel on 4/19/19.
//  Copyright © 2019 Varun Patel. All rights reserved.
//

import UIKit

class FlickrDetailViewController: UIViewController {
    var image: UIImage?
    private var imageView: UIImageView!
    
    override func viewDidLoad() {
        self.setupFlickrDetailViewController()
        imageView.image = image
    }
    
    private func setupFlickrDetailViewController() {
        imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
    }
}
