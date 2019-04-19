//
//  ImgurSearchFactory.swift
//  ImgurSearch
//
//  Created by Varun D Patel on 4/18/19.
//  Copyright © 2019 Varun Patel. All rights reserved.
//

import Foundation

protocol ImgurSearchable: NSObjectProtocol {
    func newSearchResultsAvailable()
}

class ImgurSearchFactory: NSObject {
    var cache = [String:Data]() //An extremely light weight cache
    var searchResults = [ImgurSearchResult]() {
        didSet {
            delegate?.newSearchResultsAvailable()
        }
    }
    var imgurSearchQuery:String? {
        willSet {
            if let newValue = newValue, newValue != imgurSearchQuery {
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
    weak open var delegate: ImgurSearchable?
    private(set) var pageNumber: Int!
    
    func getNextPage() {
        pageNumber = (pageNumber ?? 0) + 1
        makeRequest()
    }
}

//MARK: ImgurRequestable Protocol
extension ImgurSearchFactory: ImgurRequestable {
    var urlParameters: [[String : String]]? {
        return [["":"\(pageNumber ?? 0)"],["q":imgurSearchQuery ?? ""]]
    }
    
    var header: [String : String]? {
        return ["Authorization":"Client-ID 126701cd8332f32"]
    }
    
    var successCompletionBlock: ImgurableResponseBlock? {
        get {
            let successCompletionBlock: ([String:AnyObject]?) -> Void = {
                let searchResults = $0?["data"] as? [AnyObject]
                self.searchResults =
                    self.searchResults + (searchResults?
                        .map({ (imgurSearchResult) -> ImgurSearchResult in
                            return ImgurSearchResult(withDictionary: imgurSearchResult as! [String : AnyObject])
                        }) ?? [])
                        .reduce([ImgurSearchResult]()) {
                            return $0 + ($1.images ?? [])
                        }
                        .filter {
                            let assetType = $0.link?.absoluteString.components(separatedBy: ".").last
                            return assetType == "png" || assetType == "jpg"
                        }
                }
                return successCompletionBlock
            }
    }
    
    var failureCompletionBlock: ImgurableResponseBlock? {
        get {
            //TODO: Failure Case
            //Log to something like Crashlytics?
            return nil
        }
    }
}
