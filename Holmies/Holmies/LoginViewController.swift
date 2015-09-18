//
//  ViewController.swift
//  FacebookLogin
//
//  Created by Leonardo Koppe Malanski on 03/09/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    
    var friendsDictionary:Dictionary<String,AnyObject>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            
            println("Nao fez login")
        } else {
            self.performSegueWithIdentifier("mostrarMapa", sender: self)
            println("Ja logado")
            var loginButton = FBSDKLoginButton()
            loginButton.readPermissions = ["id","first_name","last_name","friends{id,name}","email"]
            var request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,friends{id,name}"], HTTPMethod: "GET")
            request.startWithCompletionHandler { (connection, result, error) -> Void in
                var resultData = result as! NSDictionary
                var id = 09;
                DataManager.sharedInstance.idFB = resultData["id"] as! String
                DataManager.sharedInstance.mail = resultData["email"] as! String
                DataManager.sharedInstance.user = resultData["name"] as! String
                println("\(DataManager.sharedInstance.idFB) \(DataManager.sharedInstance.mail) \(DataManager.sharedInstance.user)")
            
            }
            
            var friendRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil)
            friendRequest.startWithCompletionHandler{ (connection: FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
                if error == nil {
                    self.friendsDictionary = result as! Dictionary<String,AnyObject>
                    DataManager.sharedInstance.friendsArray = (self.friendsDictionary["data"]) as! NSArray
                    println("\(DataManager.sharedInstance.friendsArray)")
                }
                else {
                    println("\(error)")
                }
            }
            
            
        }
        
        var loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center

        
        loginButton.delegate = self
//        var request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email"], HTTPMethod: "GET")
//        request.startWithCompletionHandler { (connection, requestData, error) -> Void in
//            var result = requestData as! NSDictionary
//        }
//        
//        var friendRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil)
        
        
//        friendRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
//            
//            var friendsDictionary:Dictionary<String,AnyObject>!
//            
//            if error == nil {
//                
//                friendsDictionary = result as! Dictionary<String,AnyObject>
//                
//                //println("Friends are : \(result)")
//                println("\(friendsDictionary)")
//                // var nome =  ((friendsDictionary["data"]) as! Array<String,String>) ["name"]
//            } else {
//                
//                println("Error Getting Friends \(error)");
//                
//            }
//        }
        
        
        
        
        
        self.view.addSubview(loginButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: FB Login
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil {
            println("login complete")
            self.performSegueWithIdentifier("mostrarMapa", sender: self)
        } else {
            println(error.localizedDescription)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("user logged out")
    }
    
}

