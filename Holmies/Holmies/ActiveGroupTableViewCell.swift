//
//  ActiveGroupTableViewCell.swift
//  Holmies
//
//  Created by Leonardo Koppe Malanski on 26/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class ActiveGroupTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var coloredSquare: UIView!


    @IBOutlet weak var friendsCollection: UICollectionView!
    
    
    var indexPathCell:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("2")
        indexPathCell = DataManager.sharedInstance.actualCell
        DataManager.sharedInstance.actualCell++
        if (indexPathCell == DataManager.sharedInstance.allGroup.count+1) {
            indexPathCell = 0
        }

//        friendsCollection.numberOfItemsInSection(1)
//        let index = NSIndexPath(forItem: 0, inSection: 0)
//        let userCell = friendsCollection.dequeueReusableCellWithReuseIdentifier("usercell", forIndexPath: index) as! UsersInGroupsCollectionViewCell
//        userCell.imageUser.image = DataManager.sharedInstance.findImage(DataManager.sharedInstance.myUser.userID)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let groups = DataManager.sharedInstance.allGroup
        let indexTeste = indexPathCell
        if !(DataManager.sharedInstance.allGroup[indexPathCell].users == nil) {
                return DataManager.sharedInstance.allGroup[indexPathCell].users.count
        }
        else {
            return 0
        }

    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let userCell = friendsCollection.dequeueReusableCellWithReuseIdentifier("usercell", forIndexPath: indexPath) as! UsersInGroupsCollectionViewCell
        
        let i1 = DataManager.sharedInstance.allGroup[indexPathCell]
        let i2 = DataManager.sharedInstance.allGroup[indexPathCell].users[indexPath.row]
        let i3 = DataManager.sharedInstance.allGroup[indexPathCell].users[indexPath.row].userID
        
        let id = DataManager.sharedInstance.allGroup[indexPathCell].users[indexPath.row].userID
        print("cell = \(indexPathCell) cellCollection = \(indexPath.row)")
        userCell.imageUser.image = DataManager.sharedInstance.findImage(id)
        
        
        
        return userCell
    }


}
