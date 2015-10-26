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
    override func viewDidLoad() {
        super.viewDidLoad()
        labelInfo.text = "\(DataManager.sharedInstance.user)\né o seu username"

        
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

    func addFriend () {
        testUsername()
    }
    
    func testUsername() {

        if (username == "") {
            DataManager.sharedInstance.createSimpleUIAlert(self, title: "Naoo add", message: "Insira um username", button1: "Ok")
        } else {
            addFriend()
            navigationController!.popViewControllerAnimated(true)
        }
    }
    



}
