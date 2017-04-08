//
//  FilterViewController.swift
//  Yelp
//
//  Created by Pattanashetty, Sadananda on 4/6/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate : class {

    func searchButtonTapped(vc: FilterViewController, updatedSearchFilter: SearchFilters)
    func cancelButtonTapped(vc: FilterViewController)

}

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: FilterViewControllerDelegate?
    var viewModel: FilterViewModel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
   
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellFor(tableView: tableView, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForSectionHeader(index: section)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // Background color
        view.tintColor = UIColor.white
        view.backgroundColor = UIColor.white

        // Text Color
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.darkGray
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.rowSelected(indexPath: indexPath)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    @IBAction func searchButtonTap(_ sender: UIButton) {
        delegate?.searchButtonTapped(vc: self, updatedSearchFilter: viewModel.getUpdatedSearchFilter())
    }

    @IBAction func cancelButtonTap(_ sender: UIButton) {
        delegate?.cancelButtonTapped(vc: self)
    }


}

extension FilterViewController : FilterViewModelDelegate {
    func filtersUpdated() {
        tableView.reloadData()
    }
}


