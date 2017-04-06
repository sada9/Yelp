//
//  BusinessCell.swift
//  Yelp
//
//  Created by Pattanashetty, Sadananda on 4/5/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {

    @IBOutlet weak var ratingsImage: UIImageView!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var foodTypes: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var reviewsCount: UILabel!
    @IBOutlet weak var name: UILabel!

    var viewModel: BusinessCellViewModel?

    var business: Business! {
        didSet {
            self.viewModel = BusinessCellViewModel(business: business)
            self.name.text = business.name
            var address = business.address
            address.remove(at: address.count - 1 )
            self.address.text = address.joined(separator: ", ")
            self.distance.text = String((Double(business.distance)!/1609.344).rounded()) + " mi"
            self.reviewsCount.text = Int(business.reviewCount)! > 1 ? (business.reviewCount + " Reviews") : (business.reviewCount + " Review")

            let categoryFirst = business.categories.map({$0[0]})
            self.foodTypes.text = categoryFirst.joined(separator: ", ")

            self.ratingsImage.setImageWith(URL(string: business.ratingUrl)!)
            self.businessImage.setImageWith(URL(string: business.imageUrl)!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.ratingsImage.layer.cornerRadius = 3
         self.ratingsImage.clipsToBounds = true
        self.name.preferredMaxLayoutWidth = self.name.frame.size.width
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.name.preferredMaxLayoutWidth = self.name.frame.size.width
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

class BusinessCellViewModel {
    var business: Business!

    var categories: String {
        get {
            var categoriesStr: String = ""

            for line in self.business.categories {
                categoriesStr += line[0] + ","
            }
            return categoriesStr
        }
    }

    init(business: Business) {
        self.business = business
    }
}
