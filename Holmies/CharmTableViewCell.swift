//
//  CharmTableViewCell.swift
//  Holmies
//
//  Created by Ramon Martinez on 21/11/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class CharmTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var userPictureImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
