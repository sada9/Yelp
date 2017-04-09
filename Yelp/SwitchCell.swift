//
//  SwitchCell.swift
//  Yelp
//
//  Created by Pattanashetty, Sadananda on 4/6/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit
import SevenSwitch

protocol SwitchCellDelegate {
    func switchChanged(cell: SwitchCell, isSwitchOn: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var swich: UISwitch!

    @IBOutlet weak var filterSwitch: SevenSwitch!


    var delegate: SwitchCellDelegate?
    var cellIndexPath: IndexPath!
    
    override func awakeFromNib() {

        super.awakeFromNib()

         filterSwitch.addTarget(self, action: #selector(SwitchCell.switchValueChanged), for: UIControlEvents.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    @IBAction func switchChanged(_ sender: UISwitch) {
        delegate?.switchChanged(cell: self, isSwitchOn: sender.isOn)
    }

    func switchValueChanged() {
        print("switchValueChanged")
        delegate?.switchChanged(cell: self, isSwitchOn: filterSwitch.on)
    }

    override func prepareForReuse() {
         super.prepareForReuse()
    }


}
