//
//  AddFriendWithFriendsViewController.swift
//  Holmies
//
//  Created by Leonardo Geus on 01/12/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class AddFriendWithFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var FriendsTableView: UITableView!
    @IBOutlet weak var addFriendTextField: UITextField!
    let lightBlue:UIColor = UIColor(red: 61.0/255.0, green: 210.0/255.0, blue: 228.0/255.0, alpha: 1)
    let mainRed: UIColor = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1)
    let lightGray = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)

    
    let http = HTTPHelper()
    var viewIsOpen = false
    var supportViewForFriend = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FriendsTableView.separatorInset = UIEdgeInsetsZero
        FriendsTableView.layoutMargins = UIEdgeInsetsZero
        initializeGestureRecognizer()
        
        addFriendTextField.layer.borderColor = mainRed.CGColor
        addFriendTextField.layer.borderWidth = 1
        addFriendTextField.layer.cornerRadius = 8
        addFriendTextField.tintColor = mainRed
        addFriendTextField.textColor = mainRed
        addFriendTextField.attributedPlaceholder = NSAttributedString(string: "New friend username", attributes: [NSForegroundColorAttributeName: lightGray])
        
    
        self.FriendsTableView.rowHeight = 45
        
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
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let fontDictionary = [ NSForegroundColorAttributeName:UIColor.whiteColor() ]
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), forBarMetrics: UIBarMetrics.Default)
        FriendsTableView.reloadData()
        
        
        
        
    }
    
    private func imageLayerForGradientBackground() -> UIImage {
        
        var updatedFrame = self.navigationController?.navigationBar.bounds
        updatedFrame!.size.height += 20
        let layer = CAGradientLayer.gradientLayerForBounds(updatedFrame!)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = DataManager.sharedInstance.allFriends.count
        
        return count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friend", forIndexPath: indexPath) as! FriendsInFriendsTableViewCell
        
        let frameSize = cell.imageUser.frame.size.height
        //MARK - CRIAR METODO DE PERSISTIR NO DATAMANAGER PARA DEPOIS ACESSAR E VER SE PERMENECEU PERSISTIDO
        
        
        
        
        cell.imageUser.layer.cornerRadius = frameSize / 3.1
        cell.imageUser.clipsToBounds = true
        cell.imageUser.layer.borderWidth = 0
        cell.imageUser.image = DataManager.sharedInstance.findImage(DataManager.sharedInstance.allFriends[indexPath.row].userID)

        
        
        
        
        
        
        
//        
//        
//        
//        
//        
//        
//        
//        
//        cell.imageUser.layer.cornerRadius = cell.imageUser.frame.width / 2
//        cell.imageUser.clipsToBounds = true
//        cell.imageUser.layer.borderWidth = 0


        cell.friendUsername.text = DataManager.sharedInstance.allFriends[indexPath.row].username + "  \(cell.frame.height)" + "  \(cell.frame.width)"
        //cell.imageUser.image = DataManager.sharedInstance.findImage(DataManager.sharedInstance.allFriends[indexPath.row].userID)
        
        cell.friendUsername.font = UIFont(name: "SFUIText-Regular", size: 17)
        cell.friendUsername.textColor = mainRed
        
        
        
        print("height: \(cell.imageUser.frame.height)")
        print("width: \(cell.imageUser.frame.width)")
        print("corner: \(cell.imageUser.layer.cornerRadius)")
        
        return cell
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        continueAction()
        self.view.endEditing(true)
        return false
    }
    
    func continueAction() {
        
        if (addFriendTextField.text == "") {
            DataManager.sharedInstance.shakeTextField(addFriendTextField)
            DataManager.sharedInstance.createSimpleUIAlert(self, title: "Atenção", message: "Digite um username de amigo para adicionar", button1: "OK")
        } else {
            if addFriendTextField.text == DataManager.sharedInstance.myUser.username {
                DataManager.sharedInstance.createSimpleUIAlert(self, title: "Naoo add", message: "Esse username é você", button1: "Ok")
            }
            else {
                addFriend({ (result) -> Void in
                })
            }
        }
    }
    
    func addFriend (completion:(result:String)->Void) {
        http.findFriendWithUsername("\(addFriendTextField.text!)") { (result) -> Void in
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
                    }
                    
                    
                    alertController.addAction(okAction)
                    
                    let userdic = DataManager.sharedInstance.convertUserToNSDic(DataManager.sharedInstance.allFriends)
                    DataManager.sharedInstance.createJsonFile("friends", json: userdic)
                    
                    completion(result: "sucesso")
                    self.presentViewController(alertController, animated: true, completion: nil)
                    self.FriendsTableView.reloadData()
                }
                
                
            }
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            
            let alert = UIAlertController(title: "Attention", message: "\(DataManager.sharedInstance.allFriends[indexPath.row].username) will be delete", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Delete Friend", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
                DataManager.sharedInstance.allFriends.removeAtIndex(indexPath.row)
                let userdic = DataManager.sharedInstance.convertUserToNSDic(DataManager.sharedInstance.allFriends)
                DataManager.sharedInstance.createJsonFile("friends", json: userdic)
                tableView.reloadData()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
            

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let view = UIView(frame: CGRect(x: self.view.frame.width/2-100, y: self.view.frame.height/2-100, width: 200, height: 200))
        view.backgroundColor = UIColor.redColor()
        self.view.addSubview(view)
        //let friendViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ShowFriendView")
       // let friendView = friendViewController.view
        supportViewForFriend = view
        self.view.addSubview(supportViewForFriend)
        if let infoView = UIView.viewFromNibName("ShowFriendView") as? ShowFriendView {
            infoView.nameFriend.text = DataManager.sharedInstance.allFriends[indexPath.row].name
            infoView.userName.text = DataManager.sharedInstance.allFriends[indexPath.row].username
            infoView.userImage.image = DataManager.sharedInstance.findImage(DataManager.sharedInstance.allFriends[indexPath.row].userID)
            infoView.backgroundColor = DataManager.sharedInstance.mainRed
            infoView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            infoView.userName.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
            infoView.userName.textColor = DataManager.sharedInstance.lightBlue
            infoView.nameFriend.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
            infoView.nameFriend.textColor = UIColor.whiteColor()
            infoView.userImage.layer.cornerRadius = 100.0
            infoView.userImage.layer.borderColor = UIColor.whiteColor().CGColor
            infoView.userImage.layer.borderWidth = 3.0
            infoView.userImage.clipsToBounds = true
            
            view.addSubview(infoView)
            viewIsOpen = true
        }
        
        
    }
    
    func initializeGestureRecognizer() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("recognizeTapGesture"))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func recognizeTapGesture() {
        if viewIsOpen {
           supportViewForFriend.hidden = true
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
