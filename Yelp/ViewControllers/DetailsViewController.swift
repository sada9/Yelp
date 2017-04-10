//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Pattanashetty, Sadananda on 4/8/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {

    var viewModel: DetailsViewModel!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cats: UILabel!
    
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var snippetText: UILabel!
    @IBOutlet weak var distance: UILabel!

    @IBOutlet weak var phone: UIButton!
    @IBOutlet weak var address: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = viewModel.name
        cats.text = viewModel.categories
        reviewCount.text = viewModel.reviewCount
        ratingsImageView.setImageWith(viewModel.ratingImageUrl)
        snippetText.text = viewModel.snippetText
        distance.text = viewModel.distance
        address.text = viewModel.address
        phone.setTitle("+1"+viewModel.phone, for: .normal)
        //set map view

        let coordinate = CLLocationCoordinate2DMake(viewModel.lat, viewModel.lon)
        let placemark = MKPlacemark(coordinate: coordinate , addressDictionary: nil);
        self.mapView.addAnnotation(placemark)

        let  viewRegion =
            MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
        let adjustedRegion = self.mapView.regionThatFits(viewRegion)
        self.mapView.setRegion(adjustedRegion, animated: true)
    }

    @IBAction func phoneNumberTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "telprompt://+1\(viewModel.phone)")!, options: [:]) { (flag) in
            NSLog("How did call go?")
        }

    }

}
