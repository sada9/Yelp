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
    var filteredBusinesses: [Business]?
    private let dataManager = DataManager()
    var isSearchActive = false
    var searchFilters: SearchFilters?
    var lastSearchKey: String?

     private var businessCount: Int {
        get {
            guard let businesses = self.businesses else {
                return 0
            }
            return businesses.count
        }
    }

   private var filteredBusinessesCount: Int {
        get {
            guard let filteredBusinesses = self.filteredBusinesses else {
                return 0
            }
            return filteredBusinesses.count
        }
    }

    init() {
        dataManager.delegate = self
        businesses = [Business]()

        //initiate seach filter
        searchFilters = SearchFilters(sortBy: Filter(name: "Best Match", value: "0", isOn: true) ,
                                 categories: nil,
                                 deals: Filter(name: "Offering a Deal", value: "Offering a Deal" , isOn: false),
                                 distance: Filter(name: "Auto", value: "-1", isOn: true))
    }

    func search(key: String) {
        lastSearchKey = key
        dataManager.search(withTerm: lastSearchKey!, filter: searchFilters!)
    }

    func search() {
        dataManager.search(withTerm: lastSearchKey!, filter: searchFilters!)
    }

    func business(at indexPath: IndexPath) -> Business? {

        if isSearchActive {
            return filteredBusinesses?[indexPath.row]
        }
        else {
            return businesses?[indexPath.row]
        }
    }
    

    func rowCount() -> Int {
        return isSearchActive ? filteredBusinessesCount : businessCount
    }

}

extension SearchListViewModel : DataManagerListener {

    func finishedFetchingData(result : Result) {

    switch result {
        case .Success(let result):
            print(result)
            if isSearchActive {
                self.filteredBusinesses = result
            }
            else {
                self.businesses = result
            }

            delegate?.dataReady()

        case .Failure(let errorStr):
            print(errorStr)
            delegate?.error(err: errorStr)
        }
    }
    
}
