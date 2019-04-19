//
//  ImgurSearchViewController.swift
//  ImgurSearch
//
//  Created by Varun D Patel on 4/18/19.
//  Copyright © 2019 Varun Patel. All rights reserved.
//

import UIKit

class ImgurSearchViewController: UIViewController, ImgurSearchable {
    private var imgurSearchFactory = ImgurSearchFactory()
    private var imgurSearchView: ImgurSearchView!
    private var timer: Timer?
    
    override func loadView() {
        imgurSearchView = ImgurSearchView(frame: UIScreen.main.bounds)
        self.view = imgurSearchView
    }
    
    override func viewDidLoad() {
        self.title = "SoFi Imgur Image Search"
        imgurSearchView.collectionView.delegate = self
        imgurSearchView.collectionView.dataSource = self
        imgurSearchView.searchBar.delegate = self
        
        imgurSearchFactory.delegate = self
    }
    
    func newSearchResultsAvailable() {
        imgurSearchView.collectionView.reloadData()
    }
}

//MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ImgurSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgurSearchFactory.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imgurCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgurCollectionViewCell", for: indexPath) as! ImgurCollectionViewCell
        
        //Download || Use Cached Images:
        if let cachedUrl = imgurSearchFactory.searchResults[indexPath.row].link?.absoluteString, let cachedData = imgurSearchFactory.cache[cachedUrl] {
            imgurCollectionViewCell.imgurImage = UIImage(data: cachedData)
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imgurSearchLink = self.imgurSearchFactory.searchResults[indexPath.row].link {
                    let imageData = try? Data(contentsOf: imgurSearchLink)
                    self.imgurSearchFactory.cache[imgurSearchLink.absoluteString] = imageData
                    DispatchQueue.main.async {
                        if let cell = collectionView.cellForItem(at: indexPath), let imageData = imageData {
                            (cell as! ImgurCollectionViewCell).imgurImage = UIImage(data: imageData)
                            (cell as! ImgurCollectionViewCell).imgurImageTitle = self.imgurSearchFactory.searchResults[indexPath.row].description
                        }
                    }
                }
            }
       }
        
        //if you're 8 images away from the "bottom", get next page
        if (indexPath.row == imgurSearchFactory.searchResults.count - 8) {
            imgurSearchFactory.getNextPage()
        }
        return imgurCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cachedUrl = imgurSearchFactory.searchResults[indexPath.row].link?.absoluteString, let cachedData = imgurSearchFactory.cache[cachedUrl] {
            let detailVC = ImgurDetailViewController()
            detailVC.image = UIImage(data: cachedData)
            detailVC.title = imgurSearchFactory.searchResults[indexPath.row].title ?? "Title not Available"
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSearchCell", for: indexPath)
        header.addSubview(imgurSearchView.searchBar)
        imgurSearchView.searchBar.translatesAutoresizingMaskIntoConstraints = false
        imgurSearchView.searchBar.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        imgurSearchView.searchBar.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
        imgurSearchView.searchBar.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        imgurSearchView.searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        return header
    }
}

//MARK: UISearchBarDelegate
extension ImgurSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector:#selector(performImgurSearch(timer:)), userInfo: ["query" : searchText], repeats: false)
    }
    
    @objc func performImgurSearch(timer: Timer) {
        let userInfo = timer.userInfo as! [String:String]
        if let query = userInfo["query"], !query.isEmpty {
            imgurSearchFactory.imgurSearchQuery = query
        }
    }
}
