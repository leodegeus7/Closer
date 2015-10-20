//
//  DesignViewController.swift
//  Holmies
//
//  Created by Leonardo Koppe Malanski on 15/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit
import QuartzCore

class DesignViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username2: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
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
        
        setUpBacckgrounGradient()

//        backgroundGradient.locations = [0.0, 1.0]
//        backgroundGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//        backgroundGradient.endPoint = CGPoint(x: 1.0, y: 1.0)
//        backgroundGradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.width)
//        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        
//        backgroundGradient.colors = [red3, red4]
//        backgroundGradient.locations = [0.0, 0,50]
//        self.view.layer.addSublayer(backgroundGradient)
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
