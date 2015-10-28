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
    
    let mainRed = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1.0)
    let lightGray = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        
        appyDesign()

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
        
        let redCheck = UIImage(named: "redCheck.png")
        let grayCheck = UIImage(named: "grayCheck.png")
        self.tableView.rowHeight = 45
        
        let cell = tableView.dequeueReusableCellWithIdentifier("friend", forIndexPath: indexPath) as! CreateGroupTableViewCell
        cell.friendName.font = UIFont(name: "SFUIText-Regular", size: 17)
        cell.friendName.textColor = lightGray
    
        
        
        switch indexPath.row {
        case 0:
            cell.checkImage.image = redCheck
            cell.friendName.text = "Marie Stevens"
            break
        case 1:
            cell.checkImage.image = redCheck
            cell.friendName.text = "Evelyn Little"
            break
        default:
            cell.checkImage.image = grayCheck
            cell.friendName.text = "No name Ø"
            break
            
        }
        
        
        return cell
    }
    
    func appyDesign () {
       
    //MARK (Criar uma string para povoar o placeholder
        groupName.attributedPlaceholder = NSAttributedString(string: "Name of Group", attributes: [NSForegroundColorAttributeName: mainRed])
        groupName.font = UIFont(name: "SFUIText-Medium", size: 17)
        groupName.layer.borderColor = mainRed.CGColor
        groupName.layer.borderWidth = 1.25
        groupName.layer.cornerRadius = 8
        groupName.tintColor = mainRed
        groupName.textColor = mainRed
       
        tableView.layer.borderColor = mainRed.CGColor
        tableView.layer.borderWidth = 1.25
        tableView.layer.cornerRadius = 8
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
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
    
    
    @IBAction func addUser(sender: AnyObject) {
        
        
    }

    
    @IBAction func timeSlider(sender: UISlider) {
        
        var currentValue = Int(sender.value)
        upSliderLabel.text = "\(currentValue) hours"
        
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
