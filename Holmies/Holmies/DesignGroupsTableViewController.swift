//
//  DesignGroupsTableViewController.swift
//  Holmies
//
//  Created by Leonardo Koppe Malanski on 20/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class DesignGroupsTableViewController: UITableViewController {

    
    let lightBlue:UIColor = UIColor(red: 61.0/255.0, green: 210.0/255.0, blue: 228.0/255.0, alpha: 1)
    let red: UIColor = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 7
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pendingGroup", forIndexPath: indexPath) as! NewGroupTableViewCell
            //cell.backgroundColorView.backgroundColor = lightBlue
            cell.nameGroup.textColor = red
         //   self.tableView.rowHeight = 100
            
            
            
        
        return cell
//        
//        if indexPath.row == 1 {
//        let cell = tableView.dequeueReusableCellWithIdentifier("pendingGroup", forIndexPath: indexPath)
//
//        // Configure the cell...
//
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCellWithIdentifier("group", forIndexPath: indexPath)
//        }
        
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        print("tamanho da tela: \(UIScreen.mainScreen().bounds.size.height)")
//        let aspectRatio:CGFloat = 350.0/620.0
//        let customSize = aspectRatio * UIScreen .mainScreen().bounds.size.width
//        return customSize
//        
//    }
//
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
