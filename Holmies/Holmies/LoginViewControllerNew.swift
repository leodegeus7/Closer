//
//  LoginViewControllerNew.swift
//  Holmies
//
//  Created by Leonardo Geus on 19/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewControllerNew: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var forgetButton: UIButton!
    var kbHeight: CGFloat!
    var logged = false
    var position = false
    var controle = false
    let helper = HTTPHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let documents = DataManager.sharedInstance.findDocumentsDirectory()
        print(documents)
        activityIndicator.stopAnimating()
        DataManager.sharedInstance.importID()
        let idUser = "\(DataManager.sharedInstance.idUser)"
        let number = Int(idUser)
        if number > 0 {
            performSegueWithIdentifier("showTableView", sender: self)
            logged = true
        }
        
        
//        if (FBSDKAccessToken.currentAccessToken() == nil) {
//            print("Nao fez login")
//        }
//        else {
//            print("Ja logado")
//            let loginButton = FBSDKLoginButton()
//            loginButton.readPermissions = ["id","first_name","last_name","friends{id,name}","email"]
//            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,friends{id,name}"], HTTPMethod: "GET")
//            request.startWithCompletionHandler { (connection, result, error) -> Void in
//                // print(error)
//                if let resultData = result as? NSDictionary {
//                    
//                    DataManager.sharedInstance.idFB = resultData["id"] as! String
//                    DataManager.sharedInstance.email = resultData["email"] as! String
//                    DataManager.sharedInstance.user = resultData["name"] as! String
//                    DataManager.sharedInstance.name = resultData["name"] as! String
//                    print("\(DataManager.sharedInstance.idFB) \(DataManager.sharedInstance.email) \(DataManager.sharedInstance.user)")
//                    let data = ["id":DataManager.sharedInstance.idFB,"email":DataManager.sharedInstance.email,"user":DataManager.sharedInstance.user]
//                    DataManager.sharedInstance.createJsonFile("myData", json: data)
//                    if self.logged == false {
//                        self.performSegueWithIdentifier("showTableView", sender: self)}
//                }
//                else {
//                    let myDic = DataManager.sharedInstance.loadJsonFromDocuments("myData") as! NSDictionary
//                    DataManager.sharedInstance.idFB = myDic["id"] as! String
//                    DataManager.sharedInstance.email = myDic["email"] as! String
//                    DataManager.sharedInstance.user = myDic["user"] as! String
//                    print("Informacoes OFFLINE \(DataManager.sharedInstance.idFB) \(DataManager.sharedInstance.email) \(DataManager.sharedInstance.user)")
//                    if self.logged == false {
//                        self.performSegueWithIdentifier("showTableView", sender: self)}
//                    }
//                }
//        }
//        
//        let loginButton = FBSDKLoginButton()
//        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
//        loginButton.center = self.view.center
//        loginButton.delegate = self
//        self.view.addSubview(loginButton)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
    @IBAction func loginButton(sender: AnyObject) {
        if userNameTextField.text?.isEmpty == true {
            DataManager.sharedInstance.shakeTextField(userNameTextField)
        }
        else {
            if passwordTextField.text?.isEmpty == true {
                DataManager.sharedInstance.shakeTextField(passwordTextField)
            }
            else {
                activityIndicator.startAnimating()
                helper.signInWithUsername(userNameTextField.text!, password: passwordTextField.text!, completion: { (result) -> Void in
                    let JSON = result
                    let dic = JSON as NSDictionary
                    if dic["error"] != nil {
                        let error = dic["error"]
                        self.createSimpleUIAlert(self, title: "Login not conclued", message: "\(error!)", button1: "Ok")
                        
                    }
                    else {
                        DataManager.sharedInstance.name = dic["name"] as! String
                        DataManager.sharedInstance.user = dic["username"] as! String
                        DataManager.sharedInstance.email = dic["email"] as! String
                        let id = dic["id"]
                        DataManager.sharedInstance.idUser = "\(id!)"
                        DataManager.sharedInstance.saveID()
                        self.performSegueWithIdentifier("showTableView", sender: self)
                    }
                    self.afterLogin()
                })
            }
            
        }
        
        
        
    }
    
    @IBAction func registerUserButton(sender: AnyObject) {
        self.performSegueWithIdentifier("showRegister", sender: self)
    }

    @IBAction func facebookLoginButtonAction(sender: AnyObject) {
        activityIndicator.startAnimating()
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    fbLoginManager.logOut()
                }
            }
        })
    }
    
    func getFBUserData(){
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
                    
                    DataManager.sharedInstance.idFB = resultData["id"] as! String
                    DataManager.sharedInstance.email = resultData["email"] as! String
                    DataManager.sharedInstance.user = resultData["name"] as! String
                    DataManager.sharedInstance.name = resultData["name"] as! String
                    print("\(DataManager.sharedInstance.idFB) \(DataManager.sharedInstance.email) \(DataManager.sharedInstance.user)")
                    let data = ["id":DataManager.sharedInstance.idFB,"email":DataManager.sharedInstance.email,"user":DataManager.sharedInstance.user]
                    DataManager.sharedInstance.createJsonFile("myData", json: data)
                    let idUser = "\(DataManager.sharedInstance.idUser)"
                    let id = Int(idUser)
                    if !(id > 0) {
                        self.requestSignUp(DataManager.sharedInstance.name, email: DataManager.sharedInstance.email,faceId:DataManager.sharedInstance.idFB)
                    }
                    
                    
                }
                else {
                    let myDic = DataManager.sharedInstance.loadJsonFromDocuments("myData") as! NSDictionary
                    DataManager.sharedInstance.idFB = myDic["id"] as! String
                    DataManager.sharedInstance.email = myDic["email"] as! String
                    DataManager.sharedInstance.user = myDic["user"] as! String
                    print("Informacoes OFFLINE \(DataManager.sharedInstance.idFB) \(DataManager.sharedInstance.email) \(DataManager.sharedInstance.user)")
                    if self.logged == false {
                        self.performSegueWithIdentifier("showTableView", sender: self)}
                }
                self.afterLogin()
            }
        }
        
    }
    
    

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil {
            print("login complete")
            //self.performSegueWithIdentifier("showRegister", sender: self)
        } else {
            print(error.localizedDescription)
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField === userNameTextField)
        {
            userNameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
           
        }
        else {
            
            self.view.endEditing(true)
        }
        return true
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func keyboardWillShow(notification: NSNotification) {
        if controle == false {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                self.animateTextField(true)
                position = true
                controle = true
            }
        } }
    
    
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if position == true {
            self.animateTextField(false)
            position = false
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if controle == true {
            if position == false {
                self.animateTextField(true)
                position = true
            }}
        
    }
    
    func animateTextField(up: Bool) {
        let movement = (up ? -kbHeight : kbHeight)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }


    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user logged out")
    }
    
    func createSimpleUIAlert (view:UIViewController,title:String,message:String,button1:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: button1, style: UIAlertActionStyle.Default, handler: nil))
        view.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func requestSignUp(name:String,email:String,faceId:String) {
        let nameArray = name.componentsSeparatedByString(" ")
        
        let firstName = nameArray.first!.lowercaseString as String
        let lastName = nameArray.last!.lowercaseString as String
        let username = "\(firstName).\(lastName)"
        
        helper.signUpWithName(name, username: username, email: email, password: "") { (result) -> Void in
            let JSON = result
            let dic = JSON as NSDictionary
            if dic["error"] != nil {
                
                self.createSimpleUIAlert(self, title: "Error", message: dic["error"] as! String, button1: "Ok")
                print("existe username ou email ja cadastrado")
            }
            else {
                DataManager.sharedInstance.name = dic["name"] as! String
                DataManager.sharedInstance.user = dic["username"] as! String
                DataManager.sharedInstance.email = dic["email"] as! String
                let id = dic["id"]
                DataManager.sharedInstance.idUser = "\(id!)"
                self.helper.updateUserWithID("\(id!)", username: nil, location: nil, altitude: nil, fbid: faceId, photo: nil, name: nil, email: nil, password: nil, completion: { (result) -> Void in
                    
                    })
                
                DataManager.sharedInstance.saveID()
            }
            self.performSegueWithIdentifier("showTableView", sender: self)
        }
    }
    
    func afterLogin() {
        activityIndicator.stopAnimating()

        
    }
    
    

}
