//
//  FriendsTableViewCell.swift
//  Holmies
//
//  Created by Leonardo Koppe Malanski on 21/09/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendPicture: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}