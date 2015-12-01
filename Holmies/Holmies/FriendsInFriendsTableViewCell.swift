//
//  FriendsInFriendsTableViewCell.swift
//  Holmies
//
//  Created by Leonardo Geus on 01/12/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class FriendsInFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var friendUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
