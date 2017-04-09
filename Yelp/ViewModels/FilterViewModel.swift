//
//  FilterViewModel.swift
//  Yelp
//
//  Created by Pattanashetty, Sadananda on 4/6/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

protocol FilterViewModelDelegate {
    func filtersUpdated()
}

class FilterViewModel {

    let sectionTitles = ["", "Distance", "Sort By", "Category"]
    var featuredFilter: [Filter] = [Filter(name: "Offering a Deal", value: "Offering a Deal" , isOn: false)]
    var sortByFilter: [Filter] = [Filter]()
    var distanceFilter: [Filter] = [Filter]()
    var categoryFilter: [Filter] = [Filter]()
    var delegate: FilterViewModelDelegate?

    var isDistanceFilterCollapsed = true
    var isSortByFilterCollapsed = true
    var showAll = false

    init(currentSearchFilter: SearchFilters) {

        if let dealsOn = currentSearchFilter.deals {
            featuredFilter[0].isOn = dealsOn.isOn
        }

        self.initSortBy(currentSortBy: currentSearchFilter.sortBy)
        self.initDistance(currentDistance: currentSearchFilter.distance)
        self.initCategories(currentCategories: currentSearchFilter.categories)
    }

    open func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return  isDistanceFilterCollapsed ? 1 : distanceFilter.count
        case 2:
            return isSortByFilterCollapsed ? 1 : sortByFilter.count
        case 3:
            return showAll ? categoryFilter.count : 8
        default:
            return 0
        }
    }

    open func titleForSectionHeader(index: Int) -> String {
        return sectionTitles[index]
    }

    open func cellFor(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
                cell.filterLabel.text = featuredFilter[indexPath.row].name
                cell.filterSwitch.on = featuredFilter[indexPath.row].isOn
                cell.delegate = self
                cell.cellIndexPath = indexPath
                return cell

            case 1:
                if isDistanceFilterCollapsed {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell") as! DropDownCell
                    cell.name.text = distanceFilter.filter({$0.isOn})[0].name
                    cell.iconImage?.image = #imageLiteral(resourceName: "Expand")
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell") as! DropDownCell
                    cell.name.text = distanceFilter[indexPath.row].name
                    cell.delegate = self
                    cell.cellIndexPath = indexPath

                    if distanceFilter[indexPath.row].isOn {
                        cell.iconImage.image = #imageLiteral(resourceName: "Checked-80")
                    }
                    else {
                        cell.iconImage.image = #imageLiteral(resourceName: "Full Moon Filled-100")
                    }

                    return cell
                }
            case 2:
                if isSortByFilterCollapsed {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell") as! DropDownCell
                    cell.name.text = sortByFilter.filter({$0.isOn})[0].name
                    cell.iconImage?.image = #imageLiteral(resourceName: "Expand")
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell") as! DropDownCell
                    cell.name.text = sortByFilter[indexPath.row].name
                    cell.delegate = self
                    cell.cellIndexPath = indexPath

                    if sortByFilter[indexPath.row].isOn {
                        cell.iconImage.image = #imageLiteral(resourceName: "Checked-80")
                    }
                    else {
                        cell.iconImage.image = #imageLiteral(resourceName: "Full Moon Filled-100")
                    }

                    return cell
                }

            case 3:

                if !showAll && indexPath.row == 7 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SeeAllCell")
                    return cell!
                }

                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
                cell.filterLabel.text = categoryFilter[indexPath.row].name
                cell.filterSwitch.on = categoryFilter[indexPath.row].isOn
                cell.delegate = self
                cell.cellIndexPath = indexPath
                return cell


            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
                cell.cellIndexPath = indexPath
                cell.delegate = self
                return cell
        }
    }


    func rowSelected(indexPath: IndexPath) {

        switch indexPath.section {
            case 1:
                if indexPath.row == 0 {
                    if !isDistanceFilterCollapsed {
                        self.updateFilter(indexPath: indexPath)
                    }
                    isDistanceFilterCollapsed = !isDistanceFilterCollapsed
                    delegate?.filtersUpdated()
                }
                else {
                    isDistanceFilterCollapsed = true
                    self.updateFilter(indexPath: indexPath)
                    delegate?.filtersUpdated()
                }

            case 2:

                if indexPath.row == 0 {
                    if !isSortByFilterCollapsed {
                        self.updateFilter(indexPath: indexPath)
                    }
                    isSortByFilterCollapsed = !isSortByFilterCollapsed
                    delegate?.filtersUpdated()
                }
                else {
                    isSortByFilterCollapsed = true
                    self.updateFilter(indexPath: indexPath)
                    delegate?.filtersUpdated()
                }
        case 3:
            if !showAll && indexPath.row == 7 {
                showAll = true
                delegate?.filtersUpdated()
            }


        default: print()
        }
    }

    func updateFilter(indexPath: IndexPath, isOn: Bool = false) {
        switch indexPath.section {
        case 0:
            featuredFilter[indexPath.row].isOn = !featuredFilter[indexPath.row].isOn
        case 1:
            let index = self.distanceFilter.index(where: { $0.isOn })

            if indexPath.row != index {
                distanceFilter[index!].isOn = false
                distanceFilter[indexPath.row].isOn = true
            }
            //inform VC to update the table
            delegate?.filtersUpdated()

        case 2:

            let index = self.sortByFilter.index(where: { $0.isOn })

            if indexPath.row != index {
                sortByFilter[index!].isOn = false
                sortByFilter[indexPath.row].isOn = true
            }
            //inform VC to update the table
            delegate?.filtersUpdated()

        case 3:
            categoryFilter[indexPath.row].isOn = !categoryFilter[indexPath.row].isOn

        default: NSLog("Not a valid filter")
        }
    }

    func getUpdatedSearchFilter() -> SearchFilters {
        var filter = SearchFilters()

        //update deals
        filter.deals = featuredFilter[0]

        //update distanceFilter
        let distanceFilter =  self.distanceFilter.filter { $0.isOn }
        filter.distance = distanceFilter[0]

        let sortByFilter =  self.sortByFilter.filter { $0.isOn }
        filter.sortBy = sortByFilter[0]

        filter.categories = self.categoryFilter.filter { $0.isOn }

        return filter
    }

    private func initCategories(currentCategories: [Filter]?) {
        let yelpCategories = YelpFilters.yelpCategories()

        for item in yelpCategories {
            let flag = currentCategories?.filter({ $0.name == item["name"]! }) ?? []
            categoryFilter.append(Filter(name: item["name"]!, value: item["code"], isOn: flag.count > 0))
        }
    }

    private func initDistance(currentDistance: Filter?) {
        let yelpDistance = YelpFilters.yelpDistance()

        for item in yelpDistance {
            distanceFilter.append(Filter(name: item["distance"]!, value: item["meters"], isOn: item["distance"] == currentDistance?.name ? true : false))
        }
    }
    private func initSortBy(currentSortBy: Filter?) {
        sortByFilter.append(Filter(name: "Best Match", value: "0" , isOn: currentSortBy?.value == "0" ? true : false))
        sortByFilter.append(Filter(name: "Distance", value: "1" , isOn: currentSortBy?.value == "1" ? true : false))
        sortByFilter.append(Filter(name: "Highest Rating", value: "2" , isOn: currentSortBy?.value == "2" ? true : false))
    }
}

extension FilterViewModel: SwitchCellDelegate {

    func switchChanged(cell: SwitchCell, isSwitchOn: Bool) {
        self.updateFilter(indexPath: cell.cellIndexPath, isOn: isSwitchOn)
    }
}

extension FilterViewModel: DropDownCellDelegate {
    func checkboxChanged(cell: DropDownCell, isChecked: Bool) {
        self.updateFilter(indexPath: cell.cellIndexPath, isOn: isChecked)
    }
}
