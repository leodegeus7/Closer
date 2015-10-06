//
//  LocationUserTableViewCell.swift
//  Holmies
//
//  Created by Leonardo Geus on 17/09/15.
//  Copyright (c) 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class LocationUserTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
