//
//  DataManager.swift
//  Yelp
//
//  Created by Pattanashetty, Sadananda on 4/4/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import Foundation

import UIKit
import Unbox
import OAuthSwift

let yelpConsumerKey = "mkRwV11HOYiZpLrs9Rht_Q"
let yelpConsumerSecret = "dJhb59MaPlPPb1TZHkBLuxtSXXk"
let yelpToken = "XqYDOzkkd0LdsYjmgllH4vRSlBzunW7T"
let yelpTokenSecret = "LsKLklj3QaaNQnDuWdQ3acPMc4Y"
let yelpBaseURL  = "https://api.yelp.com/v2/search"

enum SortType: Int {
    case bestMatched = 0, distance, highestRated
}

protocol DataManagerListener: class {
    func finishedFetchingData(result : Result)
}

enum Result {
    case Success([Business])
    case Failure(String)
}

class DataManager {

    static var sharedInstance = DataManager()
    weak var delegate: DataManagerListener?

    func search(withTerm term: String, sort: SortType?, categories: [String]?, deals: Bool?) {

        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": "37.785771,-122.406165" as AnyObject]

        if sort != nil {
            parameters["sort"] = sort!.rawValue as AnyObject?
        }

        if categories != nil {
            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
        }

        if deals != nil {
            parameters["deals_filter"] = deals! as AnyObject?
        }

        let oauthswift  = OAuth1Swift(
            consumerKey: yelpConsumerKey,
            consumerSecret: yelpConsumerSecret,
            requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
            authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
            accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
        )

        oauthswift.client.credential.oauthToken =  yelpToken
        oauthswift.client.credential.oauthTokenSecret = yelpTokenSecret

        let _ = oauthswift.client.get(yelpBaseURL, parameters: parameters,
                                      success: { response in
                                        let jsonDict = try? response.jsonObject()
                                        self.processResponse(response: jsonDict as! NSDictionary)
        },
                                      failure: { error in self.delegate?.finishedFetchingData(result: .Failure("Failed to parse response"))
        })

    }

    private func processResponse(response: NSDictionary) {

        var businessResults = [Business]()

        if response.count > 0 {
            let data = response["businesses"] as! [NSDictionary]

            for item in data {
                do {
                    let business: Business = try unbox(dictionary: item as! UnboxableDictionary)
                    businessResults.append(business)
                    delegate?.finishedFetchingData(result: .Success(businessResults))
                }
                catch {
                     delegate?.finishedFetchingData(result: .Failure("Failed to parse response"))
                    print("Unable to Initialize Business Data")
                }
            }
        }
    }
}
