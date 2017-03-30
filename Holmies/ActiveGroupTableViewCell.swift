//
//  ActiveGroupTableViewCell.swift
//  Holmies
//
//  Created by Leonardo Koppe Malanski on 26/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class ActiveGroupTableViewCell: UITableViewCell, UICollectionViewDelegate {

    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var coloredSquare: UIView!
//
//
//    @IBOutlet weak var friendsCollection: UICollectionView!
    
    @IBOutlet weak var scrollViewFriends: UIScrollView!
    
    var indexPathCell:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("2")

//        indexPathCell = DataManager.sharedInstance.actualCell
//        DataManager.sharedInstance.actualCell++
//        if (indexPathCell == DataManager.sharedInstance.allGroup.count+1) {
//            indexPathCell = 0
//        }

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
        if !(DataManager.sharedInstance.allGroup[indexPathCell].users == nil) {
                return DataManager.sharedInstance.allGroup[indexPathCell].users.count
        }
        else {
            return 0
        }

    }
    
    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let userCell = friendsCollection.dequeueReusableCellWithReuseIdentifier("usercell", forIndexPath: indexPath) as! UsersInGroupsCollectionViewCell
//        
//        let id = DataManager.sharedInstance.allGroup[indexPathCell].users[indexPath.row].userID
//        print("cell = \(indexPathCell) cellCollection = \(indexPath.row)")
//        userCell.imageUser.image = DataManager.sharedInstance.findImage(id)
//        userCell.imageUser.layer.cornerRadius = 20.0
//        userCell.imageUser.layer.borderColor = mainRed.CGColor
//        userCell.imageUser.layer.borderWidth = 2.0
//        userCell.imageUser.clipsToBounds = true
//        
//        return userCell
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSize(width: 40, height: 40)
//    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 0
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
//    }

    
    
}
