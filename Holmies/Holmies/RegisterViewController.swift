//
//  RegisterViewController.swift
//  Holmies
//
//  Created by Leonardo Geus on 28/09/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit
import Alamofire


class RegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    var facebookAuth:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldName.enabled = false
        textFieldName.resignFirstResponder()
        DataManager.sharedInstance.importID()
        textFieldName.text = "\(DataManager.sharedInstance.idUser)"
        if DataManager.sharedInstance.idUser != "nil" {
            textFieldName.text = "\(DataManager.sharedInstance.idUser)"
            performSegueWithIdentifier("showMap", sender: self)
        
        }
        print("ID FACEE \(DataManager.sharedInstance.idFB)")
        if DataManager.sharedInstance.idFB.isEmpty == false {
            password.alpha = 0
            password2.alpha = 0
            password.enabled = false
            password2.enabled = false
            username.text = DataManager.sharedInstance.user
            name.text = DataManager.sharedInstance.name
            email.text = DataManager.sharedInstance.email
            facebookAuth = true
        }
        else {
            facebookAuth = false
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(sender: AnyObject) {
        if facebookAuth == true {
            signUpWithFace()
        }
        else {
            signUpWithoutFace()
        }
        
        
//        DataManager.sharedInstance.idUser = textFieldName.text
//        print(DataManager.sharedInstance.idUser)

    }
    
    func signUpWithFace() {
        if username.text?.isEmpty == false {
            if email.text?.isEmpty == false  {
                if email.text?.containsString("@") == true {
                    if name.text?.isEmpty == false {
                        requestSignUp()
                        
                    } else{
                        name.placeholder = "Type your name"
                    }
                    
                } else {
                    email.placeholder = "Type a valid e-mail"
                }
            } else {
                email.placeholder = "Type your e-mail"
                
            }
        } else {
            username.placeholder = "Type your username"
        }
    }
    
    
    func signUpWithoutFace() {
        if username.text?.isEmpty == false {
            if email.text?.isEmpty == false  {
                if email.text?.containsString("@") == true {
                    if name.text?.isEmpty == false {
                        if password.text?.isEmpty == false {
                            if password2.text?.isEmpty == false {
                                if password.text == password2.text {
                                    requestSignUp()
                                    
                                    
                                } else {
                                    password2.placeholder = "Passwords must be the same"
                                }
                            }else {
                                password2.placeholder = "confirm your password"
                            }
                        
                        } else{
                            password.placeholder = "Type your password"
                        }
                    
                    } else{
                        name.placeholder = "Type your name"
                    }
                    
                } else {
                    email.placeholder = "Type a valid e-mail"
                }
            } else {
                email.placeholder = "Type your e-mail"
                
            }
        } else {
            username.placeholder = "Type your username"
        }
    }
    
    func requestSignUp() {
        var string = "https://tranquil-coast-5554.herokuapp.com/users/add_new_user?name=\(name.text!)&username=\(username.text!)&email=\(email.text!)&password=\(password2.text!)"
        if string.containsString(" ") {
            string = string.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
        }
        print("LINKcorrigido \(string)")
        
        Alamofire.request(.GET, string).responseJSON { response in
            
            if let JSON = response.result.value {
                if let dic = JSON as? NSDictionary {
                    
                    if dic["error"] != nil {
                        DataManager.sharedInstance.createLocalNotification("Erro", body: "Username ou e-mail ja existem", timeAfterClose: 0, userInfo: ["":""])
                        print("existe username ou email ja cadastrado")
                    }
                    else {
                        DataManager.sharedInstance.name = dic["name"] as! String
                        DataManager.sharedInstance.user = dic["username"] as! String
                        DataManager.sharedInstance.email = dic["email"] as! String
                        let id = dic["id"]
                        DataManager.sharedInstance.idUser = "\(id!)"
                        DataManager.sharedInstance.saveID()
                        
                    }
                }
            } else {
                print("Não deu certo o registro ASAOKAPKASPOAKPAOKOPKAOPKOPKOPAKSOPKASPOAKSAPSK LEO TU FEDE")
            }
            self.performSegueWithIdentifier("showMap", sender: self)
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
