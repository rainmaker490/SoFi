//
//  FlickrSearchFactory.swift
//  FlickrSearch
//
//  Created by Varun D Patel on 4/18/19.
//  Copyright © 2019 Varun Patel. All rights reserved.
//

import Foundation

protocol FlickrSearchable: NSObjectProtocol {
    func newSearchResultsAvailable()
}

class FlickrSearchFactory: NSObject {
    var cache = [String:Data]() //An extremely light weight cache
    var searchResults = [FlickrSearchResult]() {
        didSet {
            delegate?.newSearchResultsAvailable()
        }
    }
    var flickrSearchQuery:String? {
        willSet {
            if let newValue = newValue, newValue != flickrSearchQuery {
                pageNumber = 0
                searchResults.removeAll()
                delegate?.newSearchResultsAvailable()
                cache.removeAll()
            }
        }
        
        didSet {
            getNextPage()
        }
    }
    weak open var delegate: FlickrSearchable?
    private(set) var pageNumber: Int!
    
    func getNextPage() {
        pageNumber = (pageNumber ?? 0) + 1
        makeRequest()
    }
}

//MARK: FlickrRequestable Protocol
extension FlickrSearchFactory: FlickrRequestable {
    var urlParameters: [[String : String]]? {
        return [["":"\(pageNumber ?? 0)"],["q":flickrSearchQuery ?? ""]]
    }
    
    var header: [String : String]? {
        return ["Authorization":"Client-ID 126701cd8332f32"]
    }
    
    var successCompletionBlock: FlickrableResponseBlock? {
        get {
            let successCompletionBlock: ([String:AnyObject]?) -> Void = {
                let searchResults = $0?["data"] as? [AnyObject]
                self.searchResults =
                    self.searchResults + (searchResults?
                        .map({ (flickrSearchResult) -> FlickrSearchResult in
                            return FlickrSearchResult(withDictionary: flickrSearchResult as! [String : AnyObject])
                        }) ?? [])
                        .reduce([FlickrSearchResult]()) {
                            return $0 + ($1.images ?? [])
                        }.filter {
                            let assetType = $0.link?.absoluteString.components(separatedBy: ".").last
                            return assetType == "png" || assetType == "jpg"
                        }
                }
                return successCompletionBlock
            }
    }
    
    var failureCompletionBlock: FlickrableResponseBlock? {
        get {
            //TODO: Failure Case
            //Log to something like Crashlytics?
            return nil
        }
    }
}
