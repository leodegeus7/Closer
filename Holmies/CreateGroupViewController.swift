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
    @IBOutlet weak var addUserButton: UIButton!
    
    let redCheck = UIImage(named: "redCheck.png")
    let grayCheck = UIImage(named: "grayCheck.png")
    let mainRed = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1.0)
    let lightGray = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
    var selectedFriends = [User]()
    let http = HTTPHelper()
    var until = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        let buttonContinue = UIBarButtonItem(title: "Continue", style: .Plain, target: self, action: "continueAction")
        self.navigationItem.rightBarButtonItem = buttonContinue
        
        
        applyDesign()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.sharedInstance.allFriends.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        self.tableView.rowHeight = 45
        
        let cell = tableView.dequeueReusableCellWithIdentifier("friend", forIndexPath: indexPath) as! CreateGroupTableViewCell
        cell.friendName.font = UIFont(name: "SFUIText-Regular", size: 17)
        cell.friendName.textColor = lightGray
        
        cell.friendName.text = DataManager.sharedInstance.allFriends[indexPath.row].name
        cell.friendPhoto.image = DataManager.sharedInstance.findImage("\(DataManager.sharedInstance.allFriends[indexPath.row].userID)")
        cell.friendPhoto.layer.cornerRadius = 19
        cell.friendPhoto.clipsToBounds = true
        cell.checkImage.image = grayCheck
    
        
        
        return cell
    }
    
    func applyDesign () {
       
    //MARK (Criar uma string para povoar o placeholder
        groupName.attributedPlaceholder = NSAttributedString(string: "Name of Group", attributes: [NSForegroundColorAttributeName: lightGray])
        groupName.font = UIFont(name: "SFUIText-Medium", size: 17)
        groupName.layer.borderColor = mainRed.CGColor
        groupName.layer.borderWidth = 1
        groupName.layer.cornerRadius = 8
        groupName.tintColor = mainRed
        groupName.textColor = mainRed
       
        tableView.layer.borderColor = mainRed.CGColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 8
        
        addUserButton.setTitle("New User", forState: UIControlState.Normal)
        addUserButton.setTitleColor(mainRed, forState: UIControlState.Normal)
        addUserButton.setAttributedTitle(NSAttributedString(string: "New User", attributes: [NSFontAttributeName: UIFont(name: "SFUIText-Medium", size: 17)!]), forState: UIControlState.Normal)
        addUserButton.titleLabel!.textColor = mainRed
        addUserButton.backgroundColor = UIColor.clearColor()
        addUserButton.layer.borderColor = mainRed.CGColor
        addUserButton.layer.borderWidth = 1
        addUserButton.layer.cornerRadius = 8
        
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CreateGroupTableViewCell
        selectedFriends.append(DataManager.sharedInstance.allFriends[indexPath.row])
        cell.checkImage.image = redCheck
        cell.friendPhoto.layer.borderColor = mainRed.CGColor
        cell.friendPhoto.layer.borderWidth = 1
        cell.friendName.textColor = mainRed
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CreateGroupTableViewCell
        var i = 0
        for userSelected in selectedFriends {
           
            if DataManager.sharedInstance.allFriends[indexPath.row].userID == userSelected.userID {
                selectedFriends.removeAtIndex(i)
                break
            }
            i++
        }
        cell.checkImage.image = grayCheck
        cell.friendPhoto.layer.borderWidth = 0
        cell.friendName.textColor = lightGray
    }
    
    
    @IBAction func addUser(sender: AnyObject) {
        performSegueWithIdentifier("addFriend", sender: self)
        
    }

    
    @IBAction func timeSlider(sender: UISlider) {
        let currentValue = Int(sender.value)
        upSliderLabel.text = "\(currentValue) hours"
        until = "\(currentValue)"
        
    }
    
    func continueAction () {
        
        if groupName.text?.isEmpty  == true {
            DataManager.sharedInstance.createSimpleUIAlert(self, title: "Alerta", message: "Digite um nome para o grupo", button1: "Ok")
        }
        else {
            let groupNameText = groupName.text
            
            http.createNewGroupWithName("\(groupNameText!)", completion: { (result) -> Void in
                
                let dic = result as NSDictionary
                let id = dic["id"]
                let formatId = "\(id!)"
                self.http.createNewSharerWithType(.userToGroup, ownerID: DataManager.sharedInstance.idUser, receiverID: formatId, until: "", completion: { (result) -> Void in
                })
                
                for user in self.selectedFriends {
                    let userId = user.userID
                    self.http.createNewSharerWithType(.userToGroup, ownerID: "\(userId)", receiverID: formatId, until: self.until, completion: { (result) -> Void in
                        
                    })
                   
                }
                
                let group = Group()
                group.id = formatId

                DataManager.sharedInstance.activeGroup.append(group)
                let activeGroup = DataManager.sharedInstance.activeGroup
                
                let dicio = DataManager.sharedInstance.convertGroupToNSDic(activeGroup)
                
                DataManager.sharedInstance.createJsonFile("activeGroups", json: dicio)
                
                self.navigationController?.popViewControllerAnimated(true)
            })
            
            
        
        }
        
        
        
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
