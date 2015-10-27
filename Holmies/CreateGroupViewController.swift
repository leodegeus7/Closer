//
//  CreateGroupViewController.swift
//  Holmies
//
//  Created by Leonardo Koppe Malanski on 27/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var upSliderLabel: UILabel!
    @IBOutlet weak var downSlideLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friend", forIndexPath: indexPath) as! CreateGroupTableViewCell
        
        
        return cell
    }
    
    
    
    
    @IBAction func addUser(sender: AnyObject) {
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
