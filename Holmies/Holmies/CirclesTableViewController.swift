//
//  CirclesTableViewController.swift
//  Holmies
//
//  Created by Leonardo Geus on 22/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class CirclesTableViewController: UITableViewController {

    let lightBlue:UIColor = UIColor(red: 61.0/255.0, green: 210.0/255.0, blue: 228.0/255.0, alpha: 1)
    let red: UIColor = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = DataManager.sharedInstance.findDocumentsDirectory()
        print(data)
        navigationController?.navigationBar.hidden = false
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("pendentCell", forIndexPath: indexPath) as! NewGroupTableViewCell
        print(DataManager.sharedInstance.allGroup)
        cell.groupName.text = DataManager.sharedInstance.allGroup[indexPath.row].name
        cell.groupName.textColor = red
        
        
        
//        cell.groupName.text = DataManager.sharedInstance.allGroup[indexPath.row].name
//        cell.idGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].id
//        cell.createAtGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].createdAt
        //cell.collectionView.numberOfItemsInSection()

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if tableView.cellForRowAtIndexPath(indexPath). == cellPendent {
//            performSegueWithIdentifier("showMap", sender: self)
//            DataManager.sharedInstance.activeUsers = DataManager.sharedInstance.allGroup[indexPath.row].users
//        }
//       
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
