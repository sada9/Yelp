//
//  SearchListViewController
//  Yelp
//
//  Created by Pattanashetty, Sadananda on 4/4/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit
import FTIndicator

class SearchListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var searchBar: UISearchBar?
    var filterButton: UIButton?
    var searchActive = false
   
    var viewModel: SearchListViewModel?
    var filterViewController: FilterViewController?
    var isMoreDataLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        //initiate search bar
        searchBar = UISearchBar()
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Restaurants"
        searchBar?.delegate = self
        navigationItem.titleView = searchBar

        filterButton = UIButton()
        filterButton?.setTitle("Filter", for: .focused)

         //set progress indicator style
        FTIndicator.setIndicatorStyle(.dark)

        //adjust row height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        //create view model
        viewModel = SearchListViewModel()
        viewModel?.delegate = self
        
        FTIndicator.showProgressWithmessage("Loading...", userInteractionEnable: false)
        viewModel?.search(key: "Indian")



    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell

        cell.business = viewModel?.business(at: indexPath)
        return cell
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }

        return viewModel.rowCount()
    }

    @IBAction func filterButtonTap(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.filterViewController = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController

        guard let filterViewController = self.filterViewController else {
            return
        }

        filterViewController.delegate = self
        filterViewController.viewModel = FilterViewModel(currentSearchFilter: (viewModel?.searchFilters)!)
        self.present(filterViewController, animated: true, completion: nil)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let indexPath: IndexPath! = tableView.indexPathForSelectedRow
        let business = viewModel?.business(at: indexPath)

        let detailsViewController = segue.destination as! DetailsViewController
        detailsViewController.viewModel = DetailsViewModel(business: business!)
        
    }

}

extension SearchListViewController : UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel?.isSearchActive = true

    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.search(key: searchText)
        FTIndicator.showToastMessage("Searching...")
    }

}

extension SearchListViewController : SearchListViewModelListener {

    func dataReady() {
        print("dataReady")
        print(viewModel?.businesses ?? "")
        FTIndicator.dismissProgress()
        tableView.reloadData()
        isMoreDataLoading = false


    }
    func error(err: String) {
        print(err)
        FTIndicator.dismissNotification()
    }
}

extension SearchListViewController : FilterViewControllerDelegate {

    func searchButtonTapped(vc: FilterViewController, updatedSearchFilter: SearchFilters){
        self.viewModel?.searchFilters = updatedSearchFilter
        
        guard let filterViewController = self.filterViewController else {
            return
        }
        filterViewController.dismiss(animated: true, completion: nil)

        //apply new filters
        FTIndicator.showProgressWithmessage("Applying filter...", userInteractionEnable: false)
        viewModel?.search()
    }

    func cancelButtonTapped(vc: FilterViewController){
        guard let filterViewController = self.filterViewController else {
            return
        }
        filterViewController.dismiss(animated: true, completion: nil)
    }
}

extension SearchListViewController :  UIScrollViewDelegate {
    // enable inifite scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height

            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {

                isMoreDataLoading = true
                viewModel?.search(offset: 1)
            }
        }
    }
}



