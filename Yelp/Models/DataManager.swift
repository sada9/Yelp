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


protocol DataManagerListener: class {
    func finishedFetchingData(result : Result)
}

enum Result {
    case Success([Business])
    case Failure(String)
}

struct Filter {
    var name: String?
    var value: String?
    var isOn: Bool = false

    init(name: String, value: String?, isOn: Bool) {
        self.name = name
        self.value = value
        self.isOn = isOn
    }
}

struct SearchFilters {
    var sortBy: Filter?
    var categories: [Filter]?
    var deals: Filter?
    var distance: Filter?
}

class DataManager {

    static var sharedInstance = DataManager()
    weak var delegate: DataManagerListener?
    
    func  search(withTerm term: String, filter: SearchFilters, offset: Int?) {
        let categories = filter.categories?.map({$0.value}) as? [String]
        search(withTerm: term, sort: filter.sortBy?.value , categories: categories,
               radiusFilter: filter.distance?.value, deals: filter.deals?.isOn, offset: offset)
    }

    func search(withTerm term: String, sort: String?, categories: [String]?, radiusFilter: String?, deals: Bool?, offset: Int? = 0) {
        //"37.785771,-122.406165"
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": "37.386051, -122.083855" as AnyObject]

        if sort != nil {
            parameters["sort"] = sort as AnyObject?
        }

        if categories != nil {
            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
        }

        if deals != nil {
            parameters["deals_filter"] = deals! as AnyObject?
        }

        if radiusFilter != nil {
            if Int(radiusFilter!)! > 0 {
                parameters["radius_filter"] = radiusFilter as AnyObject?
            }
        }

        if let offset = offset {
            parameters["offset"] = offset as AnyObject?
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
                                      failure: { error in self.delegate?.finishedFetchingData(result: .Failure("Failed to parse response \(error)"))
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
                }
                catch {
                     delegate?.finishedFetchingData(result: .Failure("Failed to parse response"))
                    print("Unable to Initialize Business Data")
                }
            }

            delegate?.finishedFetchingData(result: .Success(businessResults))
        }
    }
}
