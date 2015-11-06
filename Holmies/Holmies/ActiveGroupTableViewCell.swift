//
//  ActiveGroupTableViewCell.swift
//  Holmies
//
//  Created by Leonardo Koppe Malanski on 26/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class ActiveGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var coloredSquare: UIView!


    @IBOutlet weak var friendsCollection: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
