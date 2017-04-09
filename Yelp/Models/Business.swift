//
//  Business.swift
//  Yelp
//
//  Created by Pattanashetty, Sadananda on 4/4/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import Unbox

struct Business: Unboxable {

    let imageUrl: String
    let name: String
    let address: [String]
    let ratingUrl: String
    let reviewCount: String
    let categories: [[String]]
    let distance: String
    let snippetText: String

    var displayPhone : String
    var phone : String

    var lat : Double
    var lon : Double

    init(unboxer: Unboxer) throws {
        self.imageUrl = try unboxer.unbox(key: "image_url")
        self.name = try unboxer.unbox(key: "name")
        self.address = try unboxer.unbox(keyPath: "location.display_address")
        self.ratingUrl = try unboxer.unbox(key: "rating_img_url")
        self.reviewCount = try unboxer.unbox(key: "review_count")
        self.categories = try unboxer.unbox(key: "categories")
        self.distance = try unboxer.unbox(key: "distance")
        self.displayPhone = try unboxer.unbox(key: "display_phone")
        self.phone = try unboxer.unbox(key: "phone")
        self.lat = ((unboxer.dictionary["location"] as! NSDictionary)["coordinate"]  as! NSDictionary)["latitude"]! as! Double
        self.lon = ((unboxer.dictionary["location"] as! NSDictionary)["coordinate"]  as! NSDictionary)["longitude"]! as! Double
        self.snippetText = unboxer.dictionary["snippet_text"] as! String

    }
}
