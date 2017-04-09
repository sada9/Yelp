//
//  DropDownCell.swift
//  Yelp
//
//  Created by Pattanashetty, Sadananda on 4/7/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

import UIKit
protocol DropDownCellDelegate {
    func checkboxChanged(cell: DropDownCell, isChecked: Bool)
}

class DropDownCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    var delegate: DropDownCellDelegate?
    var cellIndexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.awakeFromNib()
        /*self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true */

    }

    

    override func layoutSubviews() {
        super.layoutSubviews()

       /* self.bounds = CGRect(x: self.bounds.origin.x,
                             y: self.bounds.origin.y,
                             width: (self.superview?.bounds.size.width)! - 40,
                             height: self.bounds.size.height) */
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
