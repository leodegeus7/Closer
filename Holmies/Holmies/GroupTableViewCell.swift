//
//  GroupTableViewCell.swift
//  Holmies
//
//  Created by Leonardo Geus on 05/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var idGroup: UILabel!
    @IBOutlet weak var createAtGroup: UILabel!
    @IBOutlet weak var collectionView: UserInGroupsCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellUser", forIndexPath: indexPath) as! UsersInGroupsCollectionViewCell
                cell.imageUser.image = DataManager.sharedInstance.findImage("19")
        return cell
        
    }
}
