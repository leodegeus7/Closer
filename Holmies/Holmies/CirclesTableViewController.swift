//
//  CirclesTableViewController.swift
//  Holmies
//
//  Created by Leonardo Geus on 22/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class CirclesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let data = DataManager.sharedInstance.findDocumentsDirectory()
        print(data)
        
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self,action:"reloadData",forControlEvents:.ValueChanged)
        self.refreshControl = refresh
        
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
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        for activeGroup in DataManager.sharedInstance.activeGroup {
            if activeGroup.id == DataManager.sharedInstance.allGroup[indexPath.row].id {
                let cellActive = tableView.dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath) as! GroupsTableViewCell
                print(DataManager.sharedInstance.allGroup)
                cellActive.nameGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].name
        
                return cellActive
            }
        }


        
        let cellPendent = tableView.dequeueReusableCellWithIdentifier("pendentCell", forIndexPath: indexPath) as! NewGroupTableViewCell
        cellPendent.groupName.text = DataManager.sharedInstance.allGroup[indexPath.row].name
        cellPendent.accepted = { [unowned self] (selectedCell) -> Void in
            let path = tableView.indexPathForRowAtPoint(selectedCell.center)!
            DataManager.sharedInstance.activeGroup.append(DataManager.sharedInstance.allGroup[path.row])
            let group = DataManager.sharedInstance.activeGroup
            
            let dic = DataManager.sharedInstance.convertGroupToNSDic(group)
            
            self.reloadData()
            DataManager.sharedInstance.createJsonFile("activeGroups", json: dic)
        }
        
        cellPendent.rejected = { [unowned self] (selectedCell) -> Void in
//            let path = tableView.indexPathForRowAtPoint(selectedCell.center)!
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
