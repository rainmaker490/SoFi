//
//  FlickrRequestable.swift
//  FlickrSearch
//
//  Created by Varun D Patel on 4/19/19.
//  Copyright © 2019 Varun Patel. All rights reserved.
//

import Foundation

let FLICKR_SERVICE_TIMEOUT = 10.0
typealias FlickrableResponseBlock = ([String:AnyObject]?) -> Void

protocol FlickrRequestable {
    var baseURL: String? { get }
    var httpMethod: String { get }
    var urlParameters: [[String : String]]? { get }
    var header: [String : String]? { get }
    
    var successCompletionBlock: FlickrableResponseBlock? { get }
    var failureCompletionBlock: FlickrableResponseBlock? { get }
}

extension FlickrRequestable {
    var baseURL: String? {
        return "​https://api.imgur.com/3/gallery/search/time"
    }
    var httpMethod: String {
        return "GET"
    }
    var urlParameters: [[String : String]]? { return nil }
    var header: [String : String]? { return nil }
    
    func makeRequest() {
        var requestURL = baseURL ?? ""
        
        //URL Parameters:
        var urlParametersToString = urlParameters?.reduce("") {
            return $0 + $1.reduce("") {
                return $1.key == "" ? "\($0)?\($1.value)" : "\($0)?\($1.key)=\($1.value)"
            }
        } ?? ""
        urlParametersToString.remove(at: urlParametersToString.startIndex)
        requestURL = "\(requestURL)/\(urlParametersToString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        //Request URL:
        var request = URLRequest(url: URL(string: requestURL.trimmingCharacters(in: .whitespacesAndNewlines))!)
        request.httpMethod = httpMethod
        
        //Headers:
        header?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = FLICKR_SERVICE_TIMEOUT
        let session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
        
        //Data Task:
        DispatchQueue.global(qos: .userInitiated).async {
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let _ = error {
                    //TODO: Failure case
                    //Log to something like Crashlytics?
                } else {
                    let dirtyResponseDictionary = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : AnyObject]
                    let errorCode = (response as! HTTPURLResponse).statusCode
                    if let responseDictionary = dirtyResponseDictionary, errorCode >= 200, errorCode < 300 {
                        DispatchQueue.main.async {
                            self.successCompletionBlock?(responseDictionary)
                        }
                    } else {
                        //TODO: Failure case
                        //Log to something like Crashlytics?
                        //Call Failure Completion Block here, or your may not even need a failure case if in this case
                        //all we're going to do is log to Crashlytics
                    }
                }
            }).resume()
        }
    }
}
