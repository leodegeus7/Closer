//
//  DesignViewController.swift
//  Holmies
//
//  Created by Leonardo Koppe Malanski on 15/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit
import QuartzCore

class RegisterNewViewController: UIViewController {

    @IBOutlet weak var username2: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var email: UITextField!
    let helper = HTTPHelper()
    var kbHeight: CGFloat!
    var facebookAuth:Bool!
    var position = false
    var controle = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username2.resignFirstResponder()

        
        setUpBacckgrounGradient()
        applyDesign()

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func applyDesign () {
        
        username2.backgroundColor = UIColor.clearColor()
        username2.layer.borderColor = (UIColor.whiteColor()).CGColor
        username2.layer.borderWidth = 1
        username2.layer.cornerRadius = 8
        username2.tintColor = UIColor.whiteColor()
        username2.textColor = UIColor.whiteColor()
        username2.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        
        password2.backgroundColor = UIColor.clearColor()
        password2.layer.borderColor = (UIColor.whiteColor()).CGColor
        password2.layer.borderWidth = 1
        password2.layer.cornerRadius = 8
        password2.tintColor = UIColor.whiteColor()
        password2.textColor = UIColor.whiteColor()
        password2.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        email.backgroundColor = UIColor.clearColor()
        email.layer.borderColor = (UIColor.whiteColor()).CGColor
        email.layer.borderWidth = 1
        email.layer.cornerRadius = 8
        email.tintColor = UIColor.whiteColor()
        email.textColor = UIColor.whiteColor()
        email.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])

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
    
    @IBAction func registerNewUser(sender: AnyObject) {
        signUpWithoutFace()
    }
    
    func signUpWithoutFace() {
        if username2.text?.isEmpty == false {
            if email.text?.isEmpty == false  {
                if email.text?.containsString("@") == true {
                    if password2.text?.isEmpty == false {
                        requestSignUp()
                    }else {
                        password2.placeholder = "confirm your password"
                        DataManager.sharedInstance.shakeTextField(password2)
                    }
                }
                else {
                    email.placeholder = "Type a valid e-mail"
                    DataManager.sharedInstance.shakeTextField(email)
                }
            }
            else {
                email.placeholder = "Type your e-mail"
                DataManager.sharedInstance.shakeTextField(email)
            }
        }
        else {
            self.username2.placeholder = "Type your username"
            DataManager.sharedInstance.shakeTextField(self.username2)
        }
        
    }

    func requestSignUp() {
        
        helper.signUpWithName("", username: username2.text!, email: email.text!, password: password2.text!) { (result) -> Void in
            let JSON = result
            let dic = JSON as NSDictionary
            if dic["error"] != nil {
                
                DataManager.sharedInstance.createSimpleUIAlert(self, title: "Error", message: dic["error"] as! String, button1: "Ok")
                print("existe username ou email ja cadastrado")
            }
            else {
                

                DataManager.sharedInstance.name = dic["name"] as! String
                DataManager.sharedInstance.username = dic["username"] as! String
                DataManager.sharedInstance.email = dic["email"] as! String
                
                let id = dic["id"]
                DataManager.sharedInstance.idUser = "\(id!)"
                if !(DataManager.sharedInstance.idFB == nil) {
                    self.helper.updateUserWithID("\(id!)", username: nil, location: nil, altitude: nil, fbid: DataManager.sharedInstance.idFB, photo: nil, name: nil, email: nil, password: nil, completion: { (result) -> Void in
                        print(result)
                    })
                }
                
                var myInfo = Dictionary<String,AnyObject>()
                myInfo["name"] = DataManager.sharedInstance.name
                myInfo["id"] = DataManager.sharedInstance.idUser
                myInfo["email"] = DataManager.sharedInstance.email
                myInfo["username"] = DataManager.sharedInstance.username
                myInfo["idFb"] = DataManager.sharedInstance.idFB
                DataManager.sharedInstance.createJsonFile("myInfo", json: myInfo)
                
                
                DataManager.sharedInstance.saveID()
            }
            self.performSegueWithIdentifier("showMap", sender: self)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField === username2)
        {
            username2.resignFirstResponder()
            password2.becomeFirstResponder()
            
        }
        else  if (textField === password2)
        {
            password2.resignFirstResponder()
            email.becomeFirstResponder()
            
        }
        else {
            
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if controle == true {
            if position == false {
                self.animateTextField(true)
                position = true
            }}
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if position == true {
            self.animateTextField(false)
            position = false
        }
    }

    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
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
    
    func animateTextField(up: Bool) {
        let movement = (up ? -kbHeight : kbHeight)
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
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
