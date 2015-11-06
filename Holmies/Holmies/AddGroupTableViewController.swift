////
////  AddGroupTableViewController.swift
////  Holmies
////
////  Created by Leonardo Geus on 30/09/15.
////  Copyright © 2015 Leonardo Geus. All rights reserved.
////
//
//import UIKit
//
//class AddGroupTableViewController: UITableViewController {
//
//    var selectID = [Int]()
//    enum UIBarButtonItemStyle : Int {
//        case Plain
//        case Bordered
//        case Done
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        
//        let buttonContinue = UIBarButtonItem(title: "Continue", style: .Plain, target: self, action: "continueAction")
//        self.navigationItem.rightBarButtonItem = buttonContinue
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        print(DataManager.sharedInstance.allUser[0].name)
//        
//        return DataManager.sharedInstance.allUser.count
//    }
//
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AddGroupTableViewCell
//
//        cell.userName.text = DataManager.sharedInstance.allUser[indexPath.row].name
//        cell.id.text = "\(DataManager.sharedInstance.allUser[indexPath.row].userID)"
//
//        return cell
//    }
//
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let indexSelect = indexPath.row
//        
//        selectID.append(DataManager.sharedInstance.allUser[indexSelect].userID)
//
//        print(selectID)
//        
//    }
//    
//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        let indexSelect = indexPath.row
//        let idToErase = DataManager.sharedInstance.allUser[indexSelect].userID
//        var i = 0
//        for index in selectID {
//            
//            if index == idToErase {
//                selectID.removeAtIndex(i)
//            }
//            i++
//        }
//        print(selectID)
//    }
//
//    func continueAction () {
//        performSegueWithIdentifier("addGroup", sender: self)
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "addGroup" {
//            if let destinationVC = segue.destinationViewController as? AddGroupNameViewController {
//                destinationVC.selectID = selectID
//            }
//        }
//    }
//    
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
