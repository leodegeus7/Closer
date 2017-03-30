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
    let backgrounGrayAle = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)

    
    let http = HTTPHelper()
    var viewIsOpen = false
    var supportViewForFriend = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FriendsTableView.separatorInset = UIEdgeInsetsZero
        FriendsTableView.layoutMargins = UIEdgeInsetsZero
        
        addFriendTextField.layer.borderColor = mainRed.CGColor
        addFriendTextField.layer.borderWidth = 1
        addFriendTextField.layer.cornerRadius = 8
        addFriendTextField.tintColor = mainRed
        addFriendTextField.textColor = mainRed
        addFriendTextField.attributedPlaceholder = NSAttributedString(string: "Type new friend username", attributes: [NSForegroundColorAttributeName: lightGray, NSFontAttributeName: UIFont(name: "SFCompactDisplay-Light", size: 15)!])
        addFriendTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        addFriendTextField.autocorrectionType = .No
        addFriendTextField.autocapitalizationType = .None
        
        
        FriendsTableView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        FriendsTableView.layer.borderWidth = 1
        FriendsTableView.layer.borderColor = mainRed.CGColor
        FriendsTableView.separatorColor = mainRed
        FriendsTableView.layer.cornerRadius = 8
    
        self.FriendsTableView.rowHeight = 45
        
        
        let buttonName = UIButton()
        buttonName.setImage(UIImage(named: "backArrowInversed.png"), forState: .Normal)
        buttonName.frame = CGRect(x: 0, y: 0, width: 24 * 0.6, height: 41.29 * 0.6)
        buttonName.addTarget(self, action: Selector("goBackToMain"), forControlEvents: .TouchUpInside)
      //  buttonName.addTarget(self, action: Selector("dismissView"), forControlEvents: .TouchUpInside)
        
        let rightButton = UIBarButtonItem()
        rightButton.customView = buttonName
        self.navigationItem.rightBarButtonItem = rightButton
        
        self.navigationItem.hidesBackButton = true
        
        // Do any additional setup after loading the view.
    }
    
    func goBackToMain() {
        self.performSegueWithIdentifier("backToMain", sender: self)


        
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
        
        self.navigationItem.title = "Friends"
      //  self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "NexaRustScriptL-0", size: 30)!]
        
        
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


        cell.friendUsername.text = DataManager.sharedInstance.allFriends[indexPath.row].username
        //cell.imageUser.image = DataManager.sharedInstance.findImage(DataManager.sharedInstance.allFriends[indexPath.row].userID)
        
        cell.friendUsername.font = UIFont(name: "SFCompactDisplay-Light", size: 17)
        cell.friendUsername.textColor = UIColor.blackColor()
        
        
        
//        print("height: \(cell.imageUser.frame.height)")
//        print("width: \(cell.imageUser.frame.width)")
//        print("corner: \(cell.imageUser.layer.cornerRadius)")
        
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
            DataManager.sharedInstance.createSimpleUIAlert(self, title: "Friend", message: "Insert your friend's username", button1: "OK")
        } else {
            if addFriendTextField.text == DataManager.sharedInstance.myUser.username {
                DataManager.sharedInstance.createSimpleUIAlert(self, title: "Error", message: "This is your own username", button1: "OK")
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
                DataManager.sharedInstance.createSimpleUIAlert(self, title: "Error", message: dic["error"] as! String, button1: "OK")
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
                        DataManager.sharedInstance.createSimpleUIAlert(self, title: "Friend", message: "\(friend.name) is already your friend", button1: "OK")
                        friendAlreadyExist = true
                    }
                    
                }
                
                if friendAlreadyExist == false {
                    DataManager.sharedInstance.allFriends.append(newUser)
                    //                    let friends = DataManager.sharedInstance.allFriends
                    
                    let alertController = UIAlertController(title: "Success", message: "\(newUser.username) is your friend now", preferredStyle: .Alert)
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
            
            
            let alert = UIAlertController(title: "Attention", message: "\(DataManager.sharedInstance.allFriends[indexPath.row].username) will be removed from your friends. Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
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
        view.backgroundColor = mainRed
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
            
            let viewSize = 300 / 414 * self.view.frame.size.width
            
            infoView.frame = CGRect(x: self.view.frame.size.width / 2 - viewSize / 2, y: self.view.frame.size.height / 2 - viewSize/2, width: viewSize, height: viewSize)
            infoView.clipsToBounds = true
            infoView.userName.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
            infoView.userName.textColor = lightGray
            infoView.nameFriend.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
            infoView.nameFriend.textColor = UIColor.whiteColor()
            infoView.userImage.layer.cornerRadius = viewSize / 6
            infoView.userImage.layer.borderColor = UIColor.whiteColor().CGColor
            infoView.userImage.layer.borderWidth = 2.0
            infoView.userImage.clipsToBounds = true
            infoView.layer.cornerRadius = 15
            
            infoView.imageTopConstraint.constant = (viewSize / 4) - (viewSize / 6)
            let ok = infoView.imageTopConstraint.constant
            infoView.nameFriendTopConstraint.constant = (viewSize / 2) //+ (infoView.nameFriend.frame.size.height / 2)
            
            infoView.userNameTopConstant.constant = (viewSize * 3 / 4) //- (infoView.userName.frame.size.height / 2)

            
            let blackView = UIView()
            blackView.frame = CGRect(x: 0 - (self.view.frame.size.width / 2), y: 0 - (self.view.frame.size.height / 2), width: self.view.frame.size.width * 10, height: self.view.frame.size.height * 10)
            blackView.backgroundColor = UIColor.blackColor()
            blackView.alpha = 0.45

            
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("recognizeTapGesture"))
            tapGesture.cancelsTouchesInView = false
            blackView.addGestureRecognizer(tapGesture)
            blackView.tag = 37
            
            infoView.tag = 37
            
            self.view.addSubview(blackView)
            self.view.addSubview(infoView)
            viewIsOpen = true
            
           addFriendTextField.userInteractionEnabled = false
            
            
            
            
            
        }
        
        
    }
    
    
    func recognizeTapGesture() {
        if viewIsOpen {
        supportViewForFriend.hidden = true
        addFriendTextField.userInteractionEnabled = true
            
            for view in self.view.subviews {
                if view.tag == 37 {
                    view.alpha = 0
                }
            }
           
        
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
