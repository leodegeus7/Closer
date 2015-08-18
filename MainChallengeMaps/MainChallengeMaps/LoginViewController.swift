//
//  LoginViewController.swift
//  MainChallengeMaps
//
//  Created by Leonardo Koppe Malanski on 17/08/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return loginTextField.resignFirstResponder()
        
    }
    
    @IBAction func ok(sender: AnyObject) {
        
        if loginTextField.text.isEmpty {
            let errorAlert = UIAlertView(title: "Erro", message: "Insira o login", delegate: nil, cancelButtonTitle: "OK")
          errorAlert.show()
        } else {
            let nome = loginTextField.text as NSString
            if nome.containsString(" ") {
                let errorAlert = UIAlertView(title: "Erro", message: "Não insira espaços no campo de login", delegate: nil, cancelButtonTitle: "OK")
                errorAlert.show()
            } else {
                DataManager.sharedInstance.nome = nome as String
                self.performSegueWithIdentifier("showMapView", sender: self)
            }
            
        
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
