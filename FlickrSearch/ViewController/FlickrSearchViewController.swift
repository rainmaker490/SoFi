//
//  FlickrSearchViewController.swift
//  FlickrSearch
//
//  Created by Varun D Patel on 4/18/19.
//  Copyright © 2019 Varun Patel. All rights reserved.
//

import UIKit

class FlickrSearchViewController: UIViewController, FlickrSearchable {
    private var flickrSearchFactory = FlickrSearchFactory()
    private var flickrSearchView: FlickrSearchView!
    private var timer: Timer?
    
    override func loadView() {
        flickrSearchView = FlickrSearchView(frame: UIScreen.main.bounds)
        self.view = flickrSearchView
    }
    
    override func viewDidLoad() {
        self.title = "SoFi Flickr Image Search"
        flickrSearchView.collectionView.delegate = self
        flickrSearchView.collectionView.dataSource = self
        flickrSearchView.searchBar.delegate = self
        
        flickrSearchFactory.delegate = self
    }
    
    func newSearchResultsAvailable() {
        flickrSearchView.collectionView.reloadData()
    }
}

//MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension FlickrSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrSearchFactory.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let flickrCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCollectionViewCell", for: indexPath) as! FlickrCollectionViewCell
        
        //Download || Use Cached Images:
        if let cachedUrl = flickrSearchFactory.searchResults[indexPath.row].link?.absoluteString, let cachedData = flickrSearchFactory.cache[cachedUrl] {
            flickrCollectionViewCell.flickrImage = UIImage(data: cachedData)
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                if let flickrSearchLink = self.flickrSearchFactory.searchResults[indexPath.row].link {
                    let imageData = try? Data(contentsOf: flickrSearchLink)
                    self.flickrSearchFactory.cache[flickrSearchLink.absoluteString] = imageData
                    DispatchQueue.main.async {
                        if let cell = collectionView.cellForItem(at: indexPath), let imageData = imageData {
                            (cell as! FlickrCollectionViewCell).flickrImage = UIImage(data: imageData)
                            (cell as! FlickrCollectionViewCell).flickrImageTitle = self.flickrSearchFactory.searchResults[indexPath.row].description
                        }
                    }
                }
            }
       }
        
        //if you're 8 images away from the "bottom", get next page
        if (indexPath.row == 50 * flickrSearchFactory.pageNumber - 8) {
            flickrSearchFactory.getNextPage()
        }
        return flickrCollectionViewCell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSearchCell", for: indexPath)
        header.addSubview(flickrSearchView.searchBar)
        flickrSearchView.searchBar.translatesAutoresizingMaskIntoConstraints = false
        flickrSearchView.searchBar.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        flickrSearchView.searchBar.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
        flickrSearchView.searchBar.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        flickrSearchView.searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        return header
    }
}

//MARK: UISearchBarDelegate
extension FlickrSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector:#selector(performFlickrSearch(timer:)), userInfo: ["query" : searchText], repeats: false)
    }
    
    @objc func performFlickrSearch(timer: Timer) {
        let userInfo = timer.userInfo as! [String:String]
        flickrSearchFactory.flickrSearchQuery = userInfo["query"]!
        flickrSearchFactory.getNextPage()
    }
}
