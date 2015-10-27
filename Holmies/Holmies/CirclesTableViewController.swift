//
//  CirclesTableViewController.swift
//  Holmies
//
//  Created by Leonardo Geus on 22/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit
import QuartzCore

class CirclesTableViewController: UITableViewController {
    

    let lightBlue:UIColor = UIColor(red: 61.0/255.0, green: 210.0/255.0, blue: 228.0/255.0, alpha: 1)
    let mainRed: UIColor = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        let data = DataManager.sharedInstance.findDocumentsDirectory()

        
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self,action:"reloadData",forControlEvents:.ValueChanged)
        self.refreshControl = refresh
        
        navigationBarGradient()
        
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

        let number = DataManager.sharedInstance.allGroup.count
        // #warning Incomplete implementation, return the number of rows
        return DataManager.sharedInstance.allGroup.count
    }


    
    override func viewWillAppear(animated: Bool) {
        reloadData()
    }
    
    func reloadData() {
        DataManager.sharedInstance.requestGroups { (result) -> Void in
            
            DataManager.sharedInstance.allGroup = DataManager.sharedInstance.convertJsonToGroup(result)
            let friends = DataManager.sharedInstance.loadJsonFromDocuments("friends")
            
            DataManager.sharedInstance.allFriends = DataManager.sharedInstance.convertJsonToUser(friends)

            
            
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
            
        }
        
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let squareRed = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1)
        
        for activeGroup in DataManager.sharedInstance.activeGroup {
            if activeGroup.id == DataManager.sharedInstance.allGroup[indexPath.row].id {
                let cellActive = tableView.dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath) as! ActiveGroupTableViewCell
                print(DataManager.sharedInstance.allGroup)
                self.tableView.rowHeight = 75
                cellActive.nameGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].name
                cellActive.nameGroup.textColor = mainRed
                cellActive.nameGroup.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
                print("celula: \(cellActive.nameGroup.font)")
                cellActive.coloredSquare.backgroundColor = squareRed
                cellActive.numberLabel.font = UIFont(name: "SFUIDisplay-Ultralight", size: 47)
                cellActive.timeLabel.font = UIFont(name: "SFUIText-Medium", size: 12)
                cellActive.coloredSquare.layer.cornerRadius = 8.0

//                cellActive.coloredSquare.s
                
                
                return cellActive
            }
        }


        
        let cellPendent = tableView.dequeueReusableCellWithIdentifier("pendentCell", forIndexPath: indexPath) as! NewGroupTableViewCell
        self.tableView.rowHeight = 75
        cellPendent.nameGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].name
        cellPendent.nameGroup.textColor = mainRed
        cellPendent.nameGroup.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
        cellPendent.coloredSquare.backgroundColor = lightBlue
        cellPendent.numberLabel.font = UIFont(name: "SFUIDisplay-Ultralight", size: 47)
        cellPendent.timeLabel.font = UIFont(name: "SFUIText-Medium", size: 12)
        cellPendent.coloredSquare.layer.cornerRadius = 8.0
        
        

//        for family: String in UIFont.familyNames()
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNamesForFamilyName(family)
//            {
//                print("== \(names)")
//            }
//        }

       // cellPendent.coloredSquare.backgroundColor = UIColor(patternImage: radialGradient!)
        cellPendent.accepted = { [unowned self] (selectedCell) -> Void in
            let path = tableView.indexPathForRowAtPoint(selectedCell.center)!
            DataManager.sharedInstance.activeGroup.append(DataManager.sharedInstance.allGroup[path.row])
            let group = DataManager.sharedInstance.activeGroup
            
            let dic = DataManager.sharedInstance.convertGroupToNSDic(group)
            
            self.reloadData()
            DataManager.sharedInstance.createJsonFile("activeGroups", json: dic)
        }
        
        cellPendent.rejected = { [unowned self] (selectedCell) -> Void in
//            let path = tableVipew.indexPathForRowAtPoint(selectedCell.center)!
            DataManager.sharedInstance.removeUserFromGroupInBackEnd(DataManager.sharedInstance.allGroup[indexPath.row].id, completion: { (result) -> Void in
                self.reloadData()
            })
            
        }
        return cellPendent

//        cell.groupName.text = DataManager.sharedInstance.allGroup[indexPath.row].name
//        cell.idGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].id
//        cell.createAtGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].createdAt
        //cell.collectionView.numberOfItemsInSection()

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.tag == 2 {
            performSegueWithIdentifier("showMap", sender: self)
            DataManager.sharedInstance.activeUsers = DataManager.sharedInstance.allGroup[indexPath.row].users
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
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                DataManager.sharedInstance.removeUserFromGroupInBackEnd(DataManager.sharedInstance.allGroup[indexPath.row].id, completion: { (result) -> Void in
                    self.reloadData()
                })
        
        }
//        else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
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
    
    
}


    extension CAGradientLayer {
    class func gradientLayerForBounds(bounds: CGRect) -> CAGradientLayer {
        var layer = CAGradientLayer()
        layer.frame = bounds
        let navigationBarRed1 = UIColor(red: 205.0/255.0, green: 16.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        let navigationBarRed2 = UIColor(red: 213.0/250.0, green: 9.0/255.0, blue: 43.0/255.0, alpha: 1.0)
        layer.colors = [navigationBarRed1.CGColor, navigationBarRed2.CGColor]
        return layer
    }


}


