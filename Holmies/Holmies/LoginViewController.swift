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
    
    
    
    var friendsDictionaryFace:Dictionary<String,AnyObject>!
    var logged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataManager.sharedInstance.importID()
        print("Aquiii o id user \(DataManager.sharedInstance.myUser.userID)")
        let idUser = DataManager.sharedInstance.myUser.userID
        if !(idUser == nil) {
            performSegueWithIdentifier("mostrarMapa", sender: self)
            logged = true
        }
        

        
        
        // Do any additional setup after loading the view, typically from a nib.
       
        print("Aquii \(FBSDKAccessToken.currentAccessToken())")
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            
            print("Nao fez login")
            
        } else {
            
            print("Ja logado")
            let loginButton = FBSDKLoginButton()
            loginButton.readPermissions = ["id","first_name","last_name","friends{id,name}","email"]
            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,friends{id,name}"], HTTPMethod: "GET")
            request.startWithCompletionHandler { (connection, result, error) -> Void in
               // print(error)
                if let resultData = result as? NSDictionary {
                
                    DataManager.sharedInstance.myUser.facebookID = resultData["id"] as! String
                    DataManager.sharedInstance.myUser.email = resultData["email"] as! String
                    DataManager.sharedInstance.myUser.username = resultData["name"] as! String
                    DataManager.sharedInstance.myUser.name = resultData["name"] as! String
                    print("\(DataManager.sharedInstance.myUser.facebookID) \(DataManager.sharedInstance.myUser.email) \(DataManager.sharedInstance.myUser.username)")
                    let data = ["id":DataManager.sharedInstance.myUser.facebookID,"email":DataManager.sharedInstance.myUser.email,"user":DataManager.sharedInstance.myUser.username]
                    DataManager.sharedInstance.createJsonFile("myData", json: data)
                    if self.logged == false {
                        self.performSegueWithIdentifier("showRegister", sender: self)}
                }
                else {
                    let myDic = DataManager.sharedInstance.loadJsonFromDocuments("myData") as! NSDictionary
                    DataManager.sharedInstance.myUser.facebookID = myDic["id"] as! String
                    DataManager.sharedInstance.myUser.email = myDic["email"] as! String
                    DataManager.sharedInstance.myUser.username = myDic["user"] as! String
                    print("Informacoes OFFLINE \(DataManager.sharedInstance.myUser.facebookID) \(DataManager.sharedInstance.myUser.email) \(DataManager.sharedInstance.myUser.username)")
                    if self.logged == false {
                        self.performSegueWithIdentifier("showRegister", sender: self)}
                }
                
                
            }
            
//            let friendRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil)
//            friendRequest.startWithCompletionHandler{ (connection: FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
//                if error == nil {
//                    self.friendsDictionary = result as! Dictionary<String,AnyObject>
//                    DataManager.sharedInstance.friendsArray = (self.friendsDictionary["data"]) as! NSMutableArray
//                    print("\(DataManager.sharedInstance.friendsArray)")
//                }
//                else {
//                    print("\(error)")
//                }
//            }
            
            
        }
        
        let loginButton = FBSDKLoginButton()
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
            print("login complete")
            //self.performSegueWithIdentifier("showRegister", sender: self)
        } else {
            print(error.localizedDescription)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user logged out")
    }
    
    
    
}

