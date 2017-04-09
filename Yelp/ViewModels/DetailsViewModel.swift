//
//  DetailsViewModel.swift
//  Yelp
//
//  Created by Pattanashetty, Sadananda on 4/8/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import Foundation

class DetailsViewModel {

    //let imageUrl: String
    let name: String
    let address: String
    let ratingImageUrl: URL
    let businessImage: URL
    let reviewCount: String
    let categories: String
    let distance: String
    let snippetText: String
    var displayPhone : String
    var phone : String
    var lat : Double
    var lon : Double

    init(business: Business) {
        self.name = business.name

        let address = business.address
        self.address = address.joined(separator: ", ")

        self.distance = String((Double(business.distance)!/1609.344).rounded()) + " mi"
        self.reviewCount = Int(business.reviewCount)! > 1 ? (business.reviewCount + " Reviews") : (business.reviewCount + " Review")

        let categoryFirst = business.categories.map({$0[0]})
        self.categories = categoryFirst.joined(separator: ", ")

        self.ratingImageUrl = URL(string: business.ratingUrl)!
        self.businessImage = URL(string: business.imageUrl)!

        self.displayPhone = business.displayPhone
        self.phone = business.phone
        self.lat = business.lat
        self.lon = business.lon
        self.snippetText = business.snippetText

    }
    
}
