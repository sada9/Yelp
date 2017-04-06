//
//  SearchListViewModel.swift
//  Yelp
//
//  Created by Pattanashetty, Sadananda on 4/4/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//
import UIKit

protocol SearchListViewModelListener: class {
    func dataReady()
    func error(err: String)
}

class SearchListViewModel {

    weak var delegate: SearchListViewModelListener?
    var businesses: [Business]?
    private let dataManager = DataManager()

    var businessCount: Int {
        get {
            guard let businesses = self.businesses else {
                return 0
            }
            return businesses.count
        }
    }

    init() {
        dataManager.delegate = self
        businesses = [Business]()
    }

    func search(key: String) {
        dataManager.search(withTerm: key, sort: nil, categories: [], deals: nil)
    }

    func business(at indexPath: IndexPath) -> Business? {
        return businesses?[indexPath.row]
    }
}

extension SearchListViewModel : DataManagerListener {

    func finishedFetchingData(result : Result) {

    switch result {
        case .Success(let businesses):
            print(businesses)
            self.businesses = businesses
            delegate?.dataReady()

        case .Failure(let errorStr):
            print(errorStr)
            delegate?.error(err: errorStr)
        }
    }
    
}
