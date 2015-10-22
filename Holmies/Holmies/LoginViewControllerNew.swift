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

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var forgetButton: UIButton!
    var kbHeight: CGFloat!
    var logged = false
    var isDown = false
    let helper = HTTPHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let documents = DataManager.sharedInstance.findDocumentsDirectory()
        print(documents)
        
        DataManager.sharedInstance.importID()
        let idUser = DataManager.sharedInstance.idUser
        if !(idUser == nil) {
            //performSegueWithIdentifier("showTableView", sender: self)
            logged = true
        }
        
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("Nao fez login")
        }
        else {
            print("Ja logado")
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
                    if self.logged == false {
                        self.performSegueWithIdentifier("showTableView", sender: self)}
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
                }
        }
        
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)

        
        //MARK Design Functions
        setUpBacckgrounGradient()
        applyDesignColors()
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
    @IBAction func loginButton(sender: AnyObject) {
        if userNameTextField.text?.isEmpty == true {
            DataManager.sharedInstance.shakeTextField(userNameTextField)
            if passwordTextField.text?.isEmpty == true {
                DataManager.sharedInstance.shakeTextField(passwordTextField)
            }
            else {
                helper.signInWithUsername(userNameTextField.text!, password: passwordTextField.text!, completion: { (result) -> Void in
                    let JSON = result
                    let dic = JSON as NSDictionary
                    if dic["error"] != nil {
                        print("naolocalizado")
                    }
                    else {
                        DataManager.sharedInstance.name = dic["name"] as! String
                        DataManager.sharedInstance.user = dic["username"] as! String
                        DataManager.sharedInstance.email = dic["email"] as! String
                        let id = dic["id"]
                        DataManager.sharedInstance.idUser = "\(id!)"
                        DataManager.sharedInstance.saveID()
                    }
                })
            }
        }
        
    }
    
    @IBAction func registerUserButton(sender: AnyObject) {
        
    }

    @IBAction func facebookLoginButtonAction(sender: AnyObject) {
        
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
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                self.animateTextField(true)
            
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if isDown {
                animateTextField(false)
                
            
        }
        if textField == userNameTextField {
                animateTextField(false)
                
            
        }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(false)
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
    
    func applyDesignColors () {
        
        userNameTextField.backgroundColor = UIColor.clearColor()
        userNameTextField.layer.borderColor = (UIColor.whiteColor()).CGColor
        userNameTextField.layer.borderWidth = 1
        userNameTextField.layer.cornerRadius = 8
        userNameTextField.tintColor = UIColor.whiteColor()
        userNameTextField.textColor = UIColor.whiteColor()
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        
        passwordTextField.backgroundColor = UIColor.clearColor()
        passwordTextField.layer.borderColor = (UIColor.whiteColor()).CGColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.tintColor = UIColor.whiteColor()
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
    }

    
    func setUpBacckgrounGradient () {
        
        let red1 = UIColor(red: 210/255, green: 37/255, blue: 53/255, alpha: 1)
        let red2 = UIColor(red: 219/255, green: 33/255, blue: 62/255, alpha: 1)
        
        let gradientColors: [CGColor] = [red1.CGColor, red2.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        navigationController?.navigationBar.hidden = true
        //        let fontDictionary = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        //        navigationController?.navigationBar.titleTextAttributes = fontDictionary
        
        
    }
    
    
}
