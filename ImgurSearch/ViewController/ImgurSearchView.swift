//
//  ImgurSearchView.swift
//  ImgurSearch
//
//  Created by Varun D Patel on 4/18/19.
//  Copyright © 2019 Varun Patel. All rights reserved.
//

import UIKit

class ImgurSearchView: UIView {
    var collectionView: UICollectionView!
    lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Imgur Search"
        searchBar.tintColor = .white
        searchBar.barStyle = .default
        searchBar.sizeToFit()
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImgurSearchView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupImgurSearchView() {
        self.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        collectionView.backgroundColor = .white
        collectionView.register(ImgurCollectionViewCell.self, forCellWithReuseIdentifier: "ImgurCollectionViewCell")
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSearchCell")
    }
}
