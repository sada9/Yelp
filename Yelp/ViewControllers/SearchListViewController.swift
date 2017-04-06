//
//  SearchListViewController
//  Yelp
//
//  Created by Pattanashetty, Sadananda on 4/4/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

class SearchListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!


    var viewModel: SearchListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        viewModel = SearchListViewModel()
        viewModel?.delegate = self
        viewModel?.search(key: "vegan")
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

        return viewModel.businessCount
    }
}

extension SearchListViewController : SearchListViewModelListener {

    func dataReady() {
        print("dataReady")
        print(viewModel?.businesses ?? "")
        tableView.reloadData()

    }
    func error(err: String) {
        print(err)
    }
}

