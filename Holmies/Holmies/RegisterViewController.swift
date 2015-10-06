//
//  RegisterViewController.swift
//  Holmies
//
//  Created by Leonardo Geus on 28/09/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var textFieldName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldName.resignFirstResponder()
        DataManager.sharedInstance.importID()
        if DataManager.sharedInstance.idUser != nil {
            textFieldName.text = "\(DataManager.sharedInstance.idUser)"
        
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(sender: AnyObject) {
        DataManager.sharedInstance.idUser = textFieldName.text
        print(DataManager.sharedInstance.idUser)
        DataManager.sharedInstance.saveID()
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
