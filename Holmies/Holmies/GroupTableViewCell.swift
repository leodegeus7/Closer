//
//  GroupTableViewCell.swift
//  Holmies
//
//  Created by Leonardo Geus on 05/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var idGroup: UILabel!
    @IBOutlet weak var createAtGroup: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
