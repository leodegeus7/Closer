//
//  NewGroupTableViewCell.swift
//  Holmies
//
//  Created by Leonardo Koppe Malanski on 20/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class NewGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
