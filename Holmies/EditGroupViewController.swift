//
//  EditGroupViewController.swift
//  Holmies
//
//  Created by Leonardo Koppe Malanski on 27/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class EditGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate  {

    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var upSliderLabel: UILabel!
    @IBOutlet weak var downSlideLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addUserButton: UIButton!
    
    let redCheck = UIImage(named: "redCheck.png")
    let grayCheck = UIImage(named: "grayCheck.png")
    let mainRed = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1.0)
    let lightGray = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
    let http = HTTPHelper()
    var until = ""
    var chosenHour:Int!
    var chosenDay:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
//        let buttonContinue = UIBarButtonItem(title: "Update name of Group", style: .Plain, target: self, action: "continueAction")
//        self.navigationItem.rightBarButtonItem = buttonContinue
        
        
        self.applyDesign()
        
        groupName.text = DataManager.sharedInstance.selectedGroup.name
        
        
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

        
        return DataManager.sharedInstance.activeUsers.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friend", forIndexPath: indexPath) as! CreateGroupTableViewCell
        
        //let data = DataManager.sharedInstance.selectedFriends
       
        
        
        
        
        var actualSharer = Sharer()
        for sharer in DataManager.sharedInstance.selectedSharer {
            if DataManager.sharedInstance.activeUsers[indexPath.row].userID == sharer.owner {
                actualSharer = sharer
                break
            }
        }
        
        if actualSharer.status == "pending" {
                cell.friendName.textColor = UIColor.orangeColor()
        }
        else if actualSharer.status == "accepted" {
            cell.friendName.textColor = UIColor.greenColor()
        }
        else if actualSharer.status == "rejected" {
            cell.friendName.textColor = UIColor.redColor()
        }
        
            cell.friendName.text = DataManager.sharedInstance.activeUsers[indexPath.row].name
            cell.friendPhoto.image = DataManager.sharedInstance.findImage("\(DataManager.sharedInstance.activeUsers[indexPath.row].userID)")
            
        
        //MARK - CRIAR METODO DE PERSISTIR NO DATAMANAGER PARA DEPOIS ACESSAR E VER SE PERMENECEU PERSISTIDO
        
        self.tableView.rowHeight = 45
        
        cell.friendName.font = UIFont(name: "SFUIText-Regular", size: 17)
        //cell.friendName.textColor = lightGray
        cell.friendPhoto.layer.cornerRadius = 19
        cell.friendPhoto.clipsToBounds = true
        cell.friendPhoto.layer.borderWidth = 0

        
        
        return cell
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !(groupName.text == DataManager.sharedInstance.selectedGroup.name){
            if !(groupName.text == ""){
                http.updateGroupWithID(DataManager.sharedInstance.selectedGroup.id, name: groupName.text, photo: nil, completion: { (result) -> Void in
                    
                    self.textFieldDismiss(textField, completion: { (result) -> Void in
                        DataManager.sharedInstance.createSimpleUIAlert(self, title: "Atenção", message: "Nome do grupo mudado para \(self.groupName.text!)", button1: "Ok")
                    })
                    
                })
            }
            else {
                DataManager.sharedInstance.createSimpleUIAlert(self, title: "Atenção", message: "Novo nome do grupo não deve ser vazio", button1: "Ok")
            }
        }
        else {
            DataManager.sharedInstance.createSimpleUIAlert(self, title: "Atenção", message: "Nome do grupo deve ser diferente do anterior", button1: "Ok")
        }
        
        
        return true
    }
    
    func textFieldDismiss(textField:UITextField,completion:(result:String)->Void) {
        textField.resignFirstResponder()
        completion(result: "dismiss")
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
    
    func continueAction() {
        if !(groupName.text == DataManager.sharedInstance.selectedGroup.name){
            if !(groupName.text == ""){
                    http.updateGroupWithID(DataManager.sharedInstance.selectedGroup.id, name: groupName.text, photo: nil, completion: { (result) -> Void in
                        DataManager.sharedInstance.createSimpleUIAlert(self, title: "Atenção", message: "Nome do grupo mudado para \(self.groupName.text!)", button1: "Ok")
                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    })
            }
            else {
                DataManager.sharedInstance.createSimpleUIAlert(self, title: "Atenção", message: "Novo nome do grupo não deve ser vazio", button1: "Ok")
            }
        }
        else {
            DataManager.sharedInstance.createSimpleUIAlert(self, title: "Atenção", message: "Nome do grupo deve ser diferente do anterior", button1: "Ok")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let myDict: [String:AnyObject] = [ "user": DataManager.sharedInstance.activeUsers[indexPath.row]]
        
        NSNotificationCenter.defaultCenter().postNotificationName("goToUser", object: nil ,userInfo: myDict)
        navigationController?.popViewControllerAnimated(true)
    }


    

}
