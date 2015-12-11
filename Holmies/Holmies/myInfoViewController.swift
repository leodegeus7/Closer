//
//  myInfoViewController.swift
//  Holmies
//
//  Created by Leonardo Geus on 06/11/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import UIKit

class myInfoViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var facebookLogoutButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var myUserName: UILabel!
    
    var kbHeight: CGFloat!
    
    let http = HTTPHelper()
    let mainRed: UIColor = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1)
    let lightGray = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)

    var keyboardControl = true
    var inputTextField: UITextField?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = DataManager.sharedInstance.myUser.userID
        let image = DataManager.sharedInstance.findImage(id)
        myImage.image = image
      //  myImage.image = DataManager.sharedInstance.findImage(DataManager.sharedInstance.myUser.userID)
        myUserName.text = "\(DataManager.sharedInstance.myUser.username)\né o seu username"
        let buttonContinue = UIBarButtonItem(title: "Update Username", style: .Plain, target: self, action: "continueAction")
        //self.navigationItem.rightBarButtonItem = buttonContinue
        myImage.layer.cornerRadius = 100.0
        myImage.layer.borderColor = mainRed.CGColor
        myImage.layer.borderWidth = 3.0
        myImage.clipsToBounds = true
        myUserName.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
        myUserName.textColor = mainRed
        username.layer.borderColor = mainRed.CGColor
        username.layer.borderWidth = 1
        username.layer.cornerRadius = 8
        username.tintColor = mainRed
        username.textColor = mainRed
        username.attributedPlaceholder = NSAttributedString(string: "Type your new usename", attributes: [NSForegroundColorAttributeName: lightGray])
        facebookLogoutButton.tintColor = mainRed
        facebookLogoutButton.titleLabel!.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
        deleteAccountButton.tintColor = mainRed
        deleteAccountButton.titleLabel!.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
        
        
        let loggoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "loggoutButton")
        navigationItem.rightBarButtonItem = loggoutButton
        navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        
        
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            facebookLogoutButton.setTitle("Login Facebbok", forState: .Normal)
        }
        
        
        username.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func continueAction() {
        

        if username.text?.isEmpty == true {
            DataManager.sharedInstance.shakeTextField(username)
            DataManager.sharedInstance.createSimpleUIAlert(self, title: "Error", message: "Please insert an username to update", button1: "OK")
        }
        else {
            http.updateUserWithID(DataManager.sharedInstance.myUser.userID, username: "\(username.text!)", location: nil, altitude: nil, fbid: nil, photo: nil, name: nil, email: nil, password: nil, completion: { (result) -> Void in
                let JSON = result
                let dic = JSON as NSDictionary
                if dic["error"] != nil {
                    DataManager.sharedInstance.createSimpleUIAlert(self, title: "Error", message: dic["error"] as! String, button1: "Ok")
                    print("erro aqui")
                }
                else {
                    DataManager.sharedInstance.createSimpleUIAlert(self, title: "Username", message: "\(self.username.text!) is now your username", button1: "Ok")
                    DataManager.sharedInstance.myUser.username = "\(self.username.text!)"
                    DataManager.sharedInstance.saveMyInfo()
                    DataManager.sharedInstance.loadMyInfo()
                    self.myUserName.text = "\(self.username.text!)\nis your username"
                    self.exitView()
                }
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let fontDictionary = [ NSForegroundColorAttributeName:UIColor.whiteColor() ]
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), forBarMetrics: UIBarMetrics.Default)
        
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

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
            if let userInfo = notification.userInfo {
                if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                    kbHeight = keyboardSize.height
                    self.animateTextField(true)
                }
            }
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
            self.animateTextField(false)
        
    }
    
    func loggoutButton() {
        let alert = UIAlertController(title: "Attention", message: "Do you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:  { (UIAlertAction)in
            DataManager.sharedInstance.createSimpleUIAlert(self, title: "Logout", message: "Successfully logged out", button1: "Ok")
            
            let documentsDirectory = DataManager.sharedInstance.findDocumentsDirectory()
            let path = documentsDirectory + "/id.txt"
            let path1 = documentsDirectory + "/groups.json"
            let path2 = documentsDirectory + "/myInfo.json"
            let path3 = documentsDirectory + "/myInfolog.json"
            let path4 = documentsDirectory + "/receiverSharers.json"
            let path5 = documentsDirectory + "/sharers.json"
            let path6 = documentsDirectory + "/friends.json"
            
            let fileManager = NSFileManager.defaultManager()
            do {try fileManager.removeItemAtPath(path)} catch {}
            do {try fileManager.removeItemAtPath(path1)} catch {}
            do {try fileManager.removeItemAtPath(path2)} catch {}
            do {try fileManager.removeItemAtPath(path3)} catch {}
            do {try fileManager.removeItemAtPath(path4)} catch {}
            do {try fileManager.removeItemAtPath(path5)} catch {}
            do {try fileManager.removeItemAtPath(path6)} catch {}
            NSThread.mainThread()
            exit(0)

        
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }

    @IBAction func deleteAccount(sender: AnyObject) {

        
        let alert = UIAlertController(title: "Password", message: "Confirm your password to destroy your account", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            self.inputTextField = textField
        }
        
        
        alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler:  { (UIAlertAction)in
            self.http.destroyUserWithUsername(DataManager.sharedInstance.myUser.username, password: self.inputTextField!.text!, completion: { (result) -> Void in
                
                let JSON = result
                let dic = JSON as NSDictionary
                
                if dic["error"] != nil {
                    DataManager.sharedInstance.createSimpleUIAlert(self, title: "Error", message: dic["error"] as! String, button1: "Ok")
                }
                else {
                    DataManager.sharedInstance.createSimpleUIAlert(self, title: "Attention", message: "The account \(DataManager.sharedInstance.myUser.username) has been successfully destroyed", button1: "Ok")
                    
                    let documentsDirectory = DataManager.sharedInstance.findDocumentsDirectory()
                    let path = documentsDirectory + "/id.txt"
                    let path1 = documentsDirectory + "/groups.json"
                    let path2 = documentsDirectory + "/myInfo.json"
                    let path3 = documentsDirectory + "/myInfolog.json"
                    let path4 = documentsDirectory + "/receiverSharers.json"
                    let path5 = documentsDirectory + "/sharers.json"
                    let path6 = documentsDirectory + "/friends.json"

                    let fileManager = NSFileManager.defaultManager()
                    do {try fileManager.removeItemAtPath(path)} catch {}
                    do {try fileManager.removeItemAtPath(path1)} catch {}
                    do {try fileManager.removeItemAtPath(path2)} catch {}
                    do {try fileManager.removeItemAtPath(path3)} catch {}
                    do {try fileManager.removeItemAtPath(path4)} catch {}
                    do {try fileManager.removeItemAtPath(path5)} catch {}
                    do {try fileManager.removeItemAtPath(path6)} catch {}
                    NSThread.mainThread()
                    exit(0)


                }
                
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func loggoutFace(sender: AnyObject) {
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            self.getFBUserData({ (result) -> Void in
                let newFBID = result as String
                DataManager.sharedInstance.createSimpleUIAlert(self, title: "Success", message: "Successfully connected to your Facebook Account", button1: "Ok")
                DataManager.sharedInstance.myUser.facebookID = newFBID
                DataManager.sharedInstance.saveMyInfo()
                self.http.updateUserWithID(DataManager.sharedInstance.myUser.userID, username: nil, location: nil, altitude: nil, fbid: newFBID, photo: nil, name: nil, email: nil, password: nil, completion: { (result) -> Void in
                    
                })
                
                DataManager.sharedInstance.requestFacebook(self, completion: { (result) -> Void in
                    
                })

                
            })
        }
        else {
            let alert = UIAlertController(title: "Facebook", message: "Do you want to logout from Facebook? All the information imported will be destroyed", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Loggout", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                if (FBSDKAccessToken.currentAccessToken() == nil) {
                    self.facebookLogoutButton.setTitle("Logout", forState: .Normal)
                    self.http.updateUserWithID(DataManager.sharedInstance.myUser.userID, username: nil, location: nil, altitude: nil, fbid: "", photo: nil, name: nil, email: nil, password: nil, completion: { (result) -> Void in
                        
                    })

                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

            
        }
        
        
    }
    
    func getFBUserData(completion:(result:String)->Void){
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    if (FBSDKAccessToken.currentAccessToken() == nil) {
                        print("Nao fez login face")
                    }
                    else {
                        print("Ja logado face")
                        let loginButton = FBSDKLoginButton()
                        loginButton.readPermissions = ["id","first_name","last_name","friends{id,name}","email"]
                        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,friends{id,name}"], HTTPMethod: "GET")
                        request.startWithCompletionHandler { (connection, result, error) -> Void in
                            // print(error)
                            if let resultData = result as? NSDictionary {
                                
                                let fbID = resultData["id"] as! String
                                completion(result: fbID)
                            }
                            
                        }
                    }
                }
            }
        })
        
        
    }
    
    
    
    
    func exitView() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func animateTextField(up: Bool) {
        if keyboardControl == up {
            let movement = (up ? -kbHeight : kbHeight)
            UIView.animateWithDuration(0.3, animations: {
                self.view.frame = CGRectOffset(self.view.frame, 0, movement)
            })
            if up == true {
                keyboardControl = false
            }
            if up == false {
                keyboardControl = true
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        continueAction()
        self.view.endEditing(true)
        return false
    }
    
}
