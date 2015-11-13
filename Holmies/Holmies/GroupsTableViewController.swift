//
//  GroupsTableViewController.swift
//  Holmies
//
//  Created by Leonardo Geus on 24/09/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        reloadData { (result) -> Void in
//            self.tableView.reloadData()
//        }
//        

        
    
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
        return DataManager.sharedInstance.allGroup.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! GroupTableViewCell

        //print("grupo \(DataManager.sharedInstance.allGroup)")
        cell.groupName.text = DataManager.sharedInstance.allGroup[indexPath.row].name
        cell.idGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].id
        cell.createAtGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].createdAt
        //cell.collectionView.numberOfItemsInSection()
        
        //print(DataManager.sharedInstance.allGroup[indexPath.row].createdAt)
        
        
        
        
//        let cellCollection:UserInGroupsCollectionView = cell.collectionView;
//        
//        
//        
//        for var i=0 ; i < DataManager.sharedInstance.allGroup.count ; i++ {
//            
//        let aux:UsersInGroupsCollectionViewCell =  UsersInGroupsCollectionViewCell()
//        
//        
//            
//        NSIndexSet aaa
//        
//        aaa.insertItem(aux)
//        }
//        
//       
//        aux.imageUser.image = DataManager.sharedInstance.findImage("915791175162407")
//        
//        cellCollection.insertSections(aaa)
//        cellCollection.numberOfItemsInSection(10)
//        
//        
        /*var img:UIImageView = UIImageView()
        img.image = UIImage(contentsOfFile: "teste")
        img.addConstraint(NSLayoutConstraint(item: <#T##AnyObject#>, attribute: <#T##NSLayoutAttribute#>, relatedBy: <#T##NSLayoutRelation#>, toItem: <#T##AnyObject?#>, attribute: <#T##NSLayoutAttribute#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>))
        cell.contentView.addSubview(img)*/
        
        
        
        return cell
    }
    
    func reloadData(completion:(result:Bool)->Void) {
        //DataManager.sharedInstance.requestGroups(<#T##completion: (result: NSDictionary) -> Void##(result: NSDictionary) -> Void#>)
        completion(result: true)
    }
    
    func refreshPulled() {
        
    }
    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 2
//    }
//    
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellUser", forIndexPath: indexPath) as! UsersInGroupsCollectionViewCell
//        cell.imageUser.image = DataManager.sharedInstance.findImage("915791175162407")
//        return cell
//    }


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
