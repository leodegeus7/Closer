//
//  DesignViewController.swift
//  Holmies
//
//  Created by Leonardo Koppe Malanski on 15/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class DesignViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username2: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var email: UITextField!
    
    let backgroundGradient: CAGradientLayer = CAGradientLayer()
    let red1 = UIColor(red: 200, green: 12, blue: 37, alpha: 1)
    let red2 = UIColor(red: 211, green: 0, blue: 43, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.backgroundColor = UIColor.clearColor()
        username.layer.borderColor = (UIColor.whiteColor()).CGColor
        username.layer.borderWidth = 1
        username.layer.cornerRadius = 8
        username.tintColor = UIColor.whiteColor()
        username.textColor = UIColor.whiteColor()
        username.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        
        password.backgroundColor = UIColor.clearColor()
        password.layer.borderColor = (UIColor.whiteColor()).CGColor
        password.layer.borderWidth = 1
        password.layer.cornerRadius = 8
        password.tintColor = UIColor.whiteColor()
        password.textColor = UIColor.whiteColor()
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        backgroundGradient.colors = [red1, red2]
        backgroundGradient.locations = [0.0, 1.0]
        
//
//        username2.backgroundColor = UIColor.clearColor()
//        username2.layer.borderColor = (UIColor.whiteColor()).CGColor
//        username2.layer.borderWidth = 1
//        username2.layer.cornerRadius = 8
//        username2.tintColor = UIColor.whiteColor()
//        username2.textColor = UIColor.whiteColor()
//        username2.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
//        
//        password2.backgroundColor = UIColor.clearColor()
//        password2.layer.borderColor = (UIColor.whiteColor()).CGColor
//        password2.layer.borderWidth = 1
//        password2.layer.cornerRadius = 8
//        password2.tintColor = UIColor.whiteColor()
//        password2.textColor = UIColor.whiteColor()
//        password2.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
//        
//        email.backgroundColor = UIColor.clearColor()
//        email.layer.borderColor = (UIColor.whiteColor()).CGColor
//        email.layer.borderWidth = 1
//        email.layer.cornerRadius = 8
//        email.tintColor = UIColor.whiteColor()
//        email.textColor = UIColor.whiteColor()
//        email.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
       
    
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
