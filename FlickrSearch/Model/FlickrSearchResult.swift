//
//  FlickrSearchResult.swift
//  FlickrSearch
//
//  Created by Varun D Patel on 4/18/19.
//  Copyright © 2019 Varun Patel. All rights reserved.
//

import Foundation

struct FlickrSearchResult { //TODO: Conform to Decodable
    var id: String
    var title: String?
    var description: String?
    var link: URL?
    var images_count: Int
    var images: [FlickrSearchResult]?
    
    init(withDictionary dictionary: [String: AnyObject]) {
        id = dictionary["id"] as! String
        title = dictionary["title"] as? String
        description = dictionary["description"] as? String
        link = URL(string: dictionary["link"] as? String ?? "")
        images_count = dictionary["images_count"] as? Int ?? 0
        
        let images = (dictionary["images"] as? [AnyObject])?.map({ (flickrSearchResult) -> FlickrSearchResult in
            return FlickrSearchResult(withDictionary: flickrSearchResult as! [String : AnyObject])
        })
        if let images = images {
            self.images = images
        }
    }
}
