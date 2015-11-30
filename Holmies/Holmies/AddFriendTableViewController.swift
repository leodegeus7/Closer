//
//  AddFriendTableViewController.swift
//  Holmies
//
//  Created by Leonardo Geus on 26/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class AddFriendTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var AddFriendTextField: UITextField!
    @IBOutlet weak var labelInfo: UILabel!
    var username = ""
    let http = HTTPHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        labelInfo.text = "\(DataManager.sharedInstance.myUser.username)\né o seu username"


        
        navigationController?.title = "Add Friend by Username"
        let confirm = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "testUsername")
        self.navigationItem.rightBarButtonItem = confirm
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AddFriendTableViewCell
        cell.addFriendTextField.placeholder = "text your username friend"
        self.tableView.rowHeight = 50
        


        
        let indent_large_enought_to_hidden:CGFloat = 10000
        cell.separatorInset = UIEdgeInsetsMake(0, indent_large_enought_to_hidden, 0, 0)
        cell.indentationWidth = indent_large_enought_to_hidden * -1
        cell.indentationLevel = 1
        return cell
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {

        testUsername()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        username = "\(textField.text!)\(string)"
        
        return true
    }

    func addFriend (completion:(result:String)->Void) {
        http.findFriendWithUsername("\(username)") { (result) -> Void in
            let JSON = result
            let dic = JSON as NSDictionary

            if dic["error"] != nil {
                DataManager.sharedInstance.createSimpleUIAlert(self, title: "Error", message: dic["error"] as! String, button1: "Ok")
                print("Nao Localizado")
            }
            else {
                
                let newUser = User()
                newUser.username = dic["username"] as? String
                newUser.altitude = dic["altitude"] as? String
                newUser.createdAt = dic["created_at"] as? String
                newUser.email = dic["email"] as? String
                newUser.facebookID = dic["fbid"] as? String
                let id = dic["id"] as? Int
                newUser.userID = "\(id!)"
                newUser.name = dic["name"] as? String
                if let locationString = dic["location"] as? String {
                    if locationString.containsString(":") {
                        let locationArray = locationString.componentsSeparatedByString(":") as [String]
                        newUser.location.latitude = locationArray[0]
                        newUser.location.longitude = locationArray[1]
                    }
                }
                
                var friendAlreadyExist = false
                for friend in DataManager.sharedInstance.allFriends {
                    if friend.userID == newUser.userID {
                        DataManager.sharedInstance.createSimpleUIAlert(self, title: "User ja amigo", message: "add outro user", button1: "Ok")
                        friendAlreadyExist = true
                    }
                    
                }
                
                if friendAlreadyExist == false {
                    DataManager.sharedInstance.allFriends.append(newUser)
//                    let friends = DataManager.sharedInstance.allFriends
                    
                    let alertController = UIAlertController(title: "Sucesso", message: "Amigo \(newUser.username)", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        self.navigationController!.popViewControllerAnimated(true)
                    }
                    
                    
                    alertController.addAction(okAction)
                    
                    let userdic = DataManager.sharedInstance.convertUserToNSDic(DataManager.sharedInstance.allFriends)
                    DataManager.sharedInstance.createJsonFile("friends", json: userdic)
                    
                    completion(result: "sucesso")
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                

            }
        }
        
    }
    
    func testUsername() {

        if (username == "") {
            DataManager.sharedInstance.createSimpleUIAlert(self, title: "Naoo add", message: "Insira um username", button1: "Ok")
        } else {
            if username == DataManager.sharedInstance.myUser.username {
                DataManager.sharedInstance.createSimpleUIAlert(self, title: "Naoo add", message: "Esse username é você", button1: "Ok")
            }
            else {
                addFriend({ (result) -> Void in
                })
            }

            
        }
    }
    

    



}
