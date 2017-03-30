//
//  EmptyGroupTableViewCell.swift
//  Holmies
//
//  Created by Leonardo Geus on 30/11/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class EmptyGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var imageEmpty: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
