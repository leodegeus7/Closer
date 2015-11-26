//
//  CirclesTableViewController.swift
//  Holmies
//
//  Created by Leonardo Geus on 22/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit
import QuartzCore
import FBSDKCoreKit
import FBSDKLoginKit

class CirclesTableViewController: UITableViewController {
    
    let http = HTTPHelper()
    let lightBlue:UIColor = UIColor(red: 61.0/255.0, green: 210.0/255.0, blue: 228.0/255.0, alpha: 1)
    let mainRed: UIColor = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1)
    var imageX = 0.0
    
    @IBOutlet var shareTypeSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        
        
        
        
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self,action:"refreshData",forControlEvents:.ValueChanged)
        self.refreshControl = refresh
        navigationBarGradient()
        //        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onTokenUpdated:", name:FBSDKAccessTokenDidChangeNotification, object: nil)
        
        
        
        
        DataManager.sharedInstance.selectedFriends.removeAll()
        
        
        
        self.refreshControl?.beginRefreshing()
        
        
        
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("reloadData"), userInfo: nil, repeats: true)
        
        
        
        
        //let ll = FBSDKAccessToken.currentAccessToken().tokenString
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("Nao fez login face")
        }
        else {
            DataManager.sharedInstance.requestFacebook({ (result) -> Void in
            })
        }
        
        
        
        
        
        //        DataManager.sharedInstance.requestFacebook { (result) -> Void in
        //
        //        }
        
        //        for family: String in UIFont.familyNames()
        //        {
        //            print("\(family)")
        //            for names: String in UIFont.fontNamesForFamilyName(family)
        //            {
        //                print("== \(names)")
        //            }
        //        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        DataManager.sharedInstance.linkGroupAndUserToSharer { (result) -> Void in
            self.tableView.reloadData()
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        // #warning Incomplete implementation, return the number of rows
        if shareTypeSegmentedControl.selectedSegmentIndex == 0 {
            return DataManager.sharedInstance.allGroup.count
        }
        else {
            return DataManager.sharedInstance.myCharms.count
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        DataManager.sharedInstance.selectedFriends.removeAll()
        reloadData()
    }
    
    func refreshData() {
        reloadData()
    }
    
    func reloadData() {
        self.tableView.reloadData()
        DataManager.sharedInstance.requestSharers { (result) -> Void in
            DataManager.sharedInstance.requestGroups { (result) -> Void in
                
                DataManager.sharedInstance.allGroup = DataManager.sharedInstance.convertJsonToGroup(result)
                
                DataManager.sharedInstance.linkGroupAndUserToSharer({ (result) -> Void in
                    print("\(result)")
                    //                    self.tableView.reloadData()
                })
                
                DataManager.sharedInstance.requestSharerInGroups()
                
                let friends = DataManager.sharedInstance.loadJsonFromDocuments("friends")
                
                
                let myPhoto = DataManager.sharedInstance.getProfPic(DataManager.sharedInstance.myUser.facebookID, serverId: DataManager.sharedInstance.myUser.userID)
                DataManager.sharedInstance.saveImage(myPhoto, id: DataManager.sharedInstance.myUser.userID)
                
                DataManager.sharedInstance.allFriends = DataManager.sharedInstance.convertJsonToUser(friends)
                for index in DataManager.sharedInstance.allFriends {
                    
                    
                    if !(index.facebookID == nil) && !(index.userID == nil) {
                        let image = DataManager.sharedInstance.getProfPic(index.facebookID, serverId: index.userID)
                        DataManager.sharedInstance.saveImage(image, id: index.userID)
                    }
                }
                DataManager.sharedInstance.linkGroupAndUserToSharer({ (result) -> Void in
                    print("\(result)")
                    self.tableView.reloadData()
                })
                self.refreshControl!.endRefreshing()
                DataManager.sharedInstance.finishedAllRequest = true
                //
                
                
            }
        }
        DataManager.sharedInstance.saveMyInfo()
        //        DataManager.sharedInstance.requestFacebook { (result) -> Void in
        //
        //        }
        
        
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let squareRed = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1)
        if shareTypeSegmentedControl.selectedSegmentIndex == 0 {
            for activeGroup in DataManager.sharedInstance.activeGroup {
                if activeGroup.id == DataManager.sharedInstance.allGroup[indexPath.row].id {
                    
                    let cellActive = tableView.dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath) as! ActiveGroupTableViewCell
                    //print(DataManager.sharedInstance.allGroup)
                    
                    
                    
                    //let sharers = DataManager.sharedInstance.allSharers
                    
                    
                    
                    
                    
                    
                    cellActive.timeLabel.text = ""
                    cellActive.nameGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].name
                    cellActive.numberLabel.text = ""
                    
                    self.tableView.rowHeight = 75
                    cellActive.nameGroup.textColor = UIColor(red: 56.0/255.0, green: 56.0/255.0, blue: 56.0/255.0, alpha: 1.0)
                    cellActive.nameGroup.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
                    //print("celula: \(cellActive.nameGroup.font)")
                    cellActive.coloredSquare.backgroundColor = squareRed
                    cellActive.numberLabel.font = UIFont(name: "SFUIDisplay-Ultralight", size: 47)
                    cellActive.timeLabel.font = UIFont(name: "SFUIText-Medium", size: 12)
                    cellActive.coloredSquare.layer.cornerRadius = 8.0
                    
                    
                    
                    
                    
                    let spaceInCell = 10.0
                    let numbersOfCellsInScrol = 6.0
                    let scrollViewSizeHeight = Double(cellActive.scrollViewFriends.frame.size.height)
                    let scrollViewSizeWidth = Double(cellActive.scrollViewFriends.frame.size.width)
                    let sizeOfImageHeight = scrollViewSizeHeight
                    let sizeOfImageWidth = (scrollViewSizeWidth/numbersOfCellsInScrol) - spaceInCell/2
                    
                    
                    

                    
                    let subViews = cellActive.scrollViewFriends.subviews
                    for subview in subViews {
                        subview.removeFromSuperview()
                    }
                    
                    if let _ = DataManager.sharedInstance.allGroup[indexPath.row].users {
                        for user in DataManager.sharedInstance.allGroup[indexPath.row].users {
                            let imageName = DataManager.sharedInstance.findImage(user.userID)
                            
                            
                            
                            let imageView = UIImageView(image: imageName)
                            
                            imageView.layer.cornerRadius = 22.85
                            imageView.layer.borderColor = mainRed.CGColor
                            imageView.layer.borderWidth = 2.0
                            imageView.clipsToBounds = true
                            
                            imageView.frame = CGRect(x: imageX, y: 0, width: sizeOfImageWidth, height: sizeOfImageHeight)
                            
                            
                            cellActive.scrollViewFriends.addSubview(imageView)
                            imageX += sizeOfImageWidth + spaceInCell
                            
                        }
                    }
                    
                    
                    imageX = 0
                    
                    
                    
                    if let _ = DataManager.sharedInstance.allGroup[indexPath.row].share {
                        
                        if !(DataManager.sharedInstance.allGroup[indexPath.row].share.until == nil) {
                            
                            
                            
                            
                            
                            let createdHour = DataManager.sharedInstance.allGroup[indexPath.row].createdAt
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
                            dateFormatter.timeZone = NSTimeZone(name: "UTC")
                            let date = dateFormatter.dateFromString(createdHour)
                            let durationString = DataManager.sharedInstance.allGroup[indexPath.row].share.until
                            if !(durationString == "0") {
                                let durationFloat = Float(durationString)
                                let finalDate = date?.dateByAddingTimeInterval(NSTimeInterval(durationFloat!))
                                
                                
                                let duration = finalDate?.timeIntervalSinceNow
                                if duration < 0 {
                                    cellActive.numberLabel.text = "0"
                                    cellActive.timeLabel.text = "expired"
                                    cellActive.selectionStyle = UITableViewCellSelectionStyle.None
                                    // cellActive.userInteractionEnabled = false
                                    cellActive.coloredSquare.backgroundColor = UIColor.grayColor()
                                    
                                }
                                else if duration <= 3600 {
                                    let newDurationMin = Int(duration!/60)
                                    cellActive.numberLabel.text = "\(newDurationMin)"
                                    cellActive.timeLabel.text = "minutes"
                                }
                                else if duration > 3600 && duration <= 360000 {
                                    var newDurationHours = Int(duration!/3600)
                                    newDurationHours++
                                    cellActive.numberLabel.text = "\(newDurationHours)"
                                    cellActive.timeLabel.text = "hours"
                                } else if duration > 360000 {
                                    let duration2 = duration!/86400
                                    
                                    var newDurationDays = Int(duration2)
                                    newDurationDays++
                                    cellActive.numberLabel.text = "\(newDurationDays)"
                                    cellActive.timeLabel.text = "days"
                                }
                                
                                
                            } else {
                                cellActive.numberLabel.text = "∞"
                                cellActive.timeLabel.text = "days"
                            }
                            
                            
                            
                            //                    var durationHours = Int(duration!/3600)
                            //                    durationHours++
                            //                    cellActive.numberLabel.text = "\(durationHours)"
                        }
                        
                    }
                    
                    
                    
                    
                    return cellActive
                    
                    
                }
            }
            
            
            
            let cellPendent = tableView.dequeueReusableCellWithIdentifier("pendentCell", forIndexPath: indexPath) as! NewGroupTableViewCell
            self.tableView.rowHeight = 75
            
            cellPendent.timeLabel.text = ""
            
            //let groups = DataManager.sharedInstance.allGroup
            
            
            let createdHour = DataManager.sharedInstance.allGroup[indexPath.row].createdAt
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            let date = dateFormatter.dateFromString(createdHour)
            let durationString = DataManager.sharedInstance.allGroup[indexPath.row].share.until
            
            if !(durationString == "0") {
                let durationFloat = Float(durationString)
                let finalDate = date?.dateByAddingTimeInterval(NSTimeInterval(durationFloat!))
                
                
                let duration = finalDate?.timeIntervalSinceNow
                
                
                if !(duration == nil) {
                    let duration = Int(duration!)
                    
                    if duration < 0 {
                        cellPendent.numberLabel.text = "0"
                        cellPendent.timeLabel.text = "expired"
                        //DataManager.sharedInstance.destroyGroupWithNotification(DataManager.sharedInstance.allGroup[indexPath.row], view: self)
                    }
                    else if duration <= 3600 {
                        let newDurationMin = Int(duration/60)
                        cellPendent.numberLabel.text = "\(newDurationMin)"
                        cellPendent.timeLabel.text = "minutes"
                    }
                    else if duration > 3600 && duration <= 360000 {
                        var newDurationHours = Int(duration/3600)
                        newDurationHours++
                        cellPendent.numberLabel.text = "\(newDurationHours)"
                        cellPendent.timeLabel.text = "hours"
                    } else if duration > 360000 {
                        var newDurationDays = Int(duration/86400)
                        newDurationDays++
                        cellPendent.numberLabel.text = "\(newDurationDays)"
                        cellPendent.timeLabel.text = "days"
                    }
                }
            }
            else {
                cellPendent.numberLabel.text = "∞"
                cellPendent.timeLabel.text = "days"
            }
            
            
            cellPendent.nameGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].name
            cellPendent.nameGroup.textColor = mainRed
            cellPendent.nameGroup.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
            cellPendent.coloredSquare.backgroundColor = lightBlue
            cellPendent.numberLabel.font = UIFont(name: "SFUIDisplay-Ultralight", size: 47)
            cellPendent.timeLabel.font = UIFont(name: "SFUIText-Medium", size: 12)
            cellPendent.coloredSquare.layer.cornerRadius = 8.0
            
            
            
            
            // cellPendent.coloredSquare.backgroundColor = UIColor(patternImage: radialGradient!)
            cellPendent.accepted = { [unowned self] (selectedCell) -> Void in
                let path = tableView.indexPathForRowAtPoint(selectedCell.center)!
                DataManager.sharedInstance.activeGroup.append(DataManager.sharedInstance.allGroup[path.row])
                let group = DataManager.sharedInstance.activeGroup
                
                let dic = DataManager.sharedInstance.convertGroupToNSDic(group)
                
                for sharer in DataManager.sharedInstance.allSharers {
                    if sharer.receiver == DataManager.sharedInstance.allGroup[path.row].id && sharer.owner == DataManager.sharedInstance.myUser.userID {
                        self.http.updateSharerWithID(sharer.id, until: nil, status: "accepted", completion: { (result) -> Void in
                            self.reloadData()
                        })
                    }
                }
                
                
                
                
                
                DataManager.sharedInstance.createJsonFile("activeGroups", json: dic)
            }
            
            
            
            cellPendent.rejected = { [unowned self] (selectedCell) -> Void in
                //            let path = tableVipew.indexPathForRowAtPoint(selectedCell.center)!
                let path = tableView.indexPathForRowAtPoint(selectedCell.center)!
                let id = DataManager.sharedInstance.allGroup[path.row].id as String
                self.http.destroySharerWithSharerType(.userToGroup, ownerID: DataManager.sharedInstance.myUser.userID, receiverID: id, completion: { (result) -> Void in
                    self.reloadData()
                })
                
            }
            return cellPendent
            
            //        cell.groupName.text = DataManager.sharedInstance.allGroup[indexPath.row].name
            //        cell.idGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].id
            //        cell.createAtGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].createdAt
            //cell.collectionView.numberOfItemsInSection()
            
        }
        else {
            let charmCell = tableView.dequeueReusableCellWithIdentifier("charmCell", forIndexPath: indexPath) as! CharmTableViewCell
            
            let actualCharm = DataManager.sharedInstance.myCharms[indexPath.row]
            let actualFriend = actualCharm.friend
            let actualSharer = actualCharm.sharer
            
            charmCell.nameLabel.text = actualFriend.name
            charmCell.remainingTimeLabel.text = "\(actualSharer.until) seconds remaining"
            
            let imageName = DataManager.sharedInstance.findImage(actualFriend.userID)
            
            
            
            let imageView = UIImageView(image: imageName)
            
            imageView.layer.cornerRadius = 20.0
            //            imageView.layer.borderColor = mainRed.CGColor
            //            imageView.layer.borderWidth = 5.0
            imageView.clipsToBounds = true
            
            imageView.frame.size = charmCell.userPictureImageView.frame.size
            imageView.frame.origin = CGPoint(x: 0, y: 0)
            
            
            for subview in charmCell.userPictureImageView.subviews {
                subview.removeFromSuperview()
            }
            charmCell.userPictureImageView.addSubview(imageView)
            
            let bgImageView = UIImageView()
            bgImageView.layer.cornerRadius = 20.0
            bgImageView.clipsToBounds = true
            bgImageView.frame.size = charmCell.backgroundImage.frame.size
            bgImageView.frame.origin = CGPoint(x: 0, y: 0)
            bgImageView.layer.borderColor = mainRed.CGColor
            bgImageView.layer.borderWidth = 2.0
            
            for subview in charmCell.backgroundImage.subviews {
                subview.removeFromSuperview()
            }
            charmCell.backgroundImage.addSubview(bgImageView)
            
            
            
            
            return charmCell
            
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.tag == 2 {
            if (DataManager.sharedInstance.allGroup[indexPath.row].users == nil) {
                DataManager.sharedInstance.createSimpleUIAlert(self, title: "Espere", message: "Espere terminar o request", button1: "OK")
                
            }
            else {
                if shareTypeSegmentedControl.selectedSegmentIndex == 0 {
                   
                    DataManager.sharedInstance.activeUsers = DataManager.sharedInstance.allGroup[indexPath.row].users
                    DataManager.sharedInstance.selectedGroup = DataManager.sharedInstance.allGroup[indexPath.row]
                    
                    
                    let sharersUniqueJson = DataManager.sharedInstance.loadJsonFromDocuments("sharers\(DataManager.sharedInstance.allGroup[indexPath.row].id)")
                    let sharerUnique = DataManager.sharedInstance.convertJsonToSharer(sharersUniqueJson)
                    DataManager.sharedInstance.selectedSharer = sharerUnique
                    
//                    for sharersInMap in DataManager.sharedInstance.sharesInGroups {
//                        if sharersInMap[0].receiver == DataManager.sharedInstance.selectedGroup.id {
//                            DataManager.sharedInstance.selectedSharer = sharersInMap
//                            break
//                        }
//                    }
                    
                    
                    if DataManager.sharedInstance.finishedAllRequest == true {
                        
                        performSegueWithIdentifier("showMap", sender: self)
                    }
                    else {
                        //
                    }
                }
                else {
                    //
                }
                
                
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showMap") {
            if let viewController: MapGoogleViewController = segue.destinationViewController as? MapGoogleViewController {
                viewController.enterInView = true
            }
        }
        if (segue.identifier == "addGroup") {
            if shareTypeSegmentedControl.selectedSegmentIndex == 1 {
                let viewController = segue.destinationViewController as! CreateGroupViewController
                viewController.isCharm = true
            }
        }
    }
    
    private func imageLayerForGradientBackground() -> UIImage {
        
        var updatedFrame = self.navigationController?.navigationBar.bounds
        updatedFrame!.size.height += 20
        let layer = CAGradientLayer.gradientLayerForBounds(updatedFrame!)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func navigationBarGradient () {
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let fontDictionary = [ NSForegroundColorAttributeName:UIColor.whiteColor() ]
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), forBarMetrics: UIBarMetrics.Default)
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.tag == 2 {
            return UITableViewCellEditingStyle.Delete
        }
        else {
            return UITableViewCellEditingStyle.None
        }
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if self.shareTypeSegmentedControl.selectedSegmentIndex == 0 {
                let id = DataManager.sharedInstance.allGroup[indexPath.row].id as String
                self.http.destroySharerWithSharerType(.userToGroup, ownerID: DataManager.sharedInstance.myUser.userID, receiverID: id, completion: { (result) -> Void in
                    self.reloadData()
                })
            }
            else {
                let myId = DataManager.sharedInstance.myUser.userID
                let friendId = DataManager.sharedInstance.myCharms[indexPath.row].friend.userID as String
                self.http.destroySharerWithSharerType(.userToUser, ownerID: myId, receiverID: friendId, completion: { (result) -> Void in
                    self.reloadData()
                })
            }
            
        }
        //        else if editingStyle == .Insert {
        //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //        }
    }
    

    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        return nil
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if #available(iOS 9.0, *) {
            tableView.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
            tableView.separatorInset = UIEdgeInsetsZero
            tableView.preservesSuperviewLayoutMargins = false
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
    }
    
    
    
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    
    */
    
    @IBAction func segmentedControlDidChangeValue(sender: AnyObject) {
        self.refreshData()
    }
    
}




extension CAGradientLayer {
    class func gradientLayerForBounds(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        let navigationBarRed1 = UIColor(red: 205.0/255.0, green: 16.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        let navigationBarRed2 = UIColor(red: 213.0/250.0, green: 9.0/255.0, blue: 43.0/255.0, alpha: 1.0)
        layer.colors = [navigationBarRed1.CGColor, navigationBarRed2.CGColor]
        return layer
    }
    
    
}


