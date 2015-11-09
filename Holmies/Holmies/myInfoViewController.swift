//
//  myInfoViewController.swift
//  Holmies
//
//  Created by Leonardo Geus on 06/11/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class myInfoViewController: UIViewController {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var myUserName: UILabel!
    let http = HTTPHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImage.image = DataManager.sharedInstance.findImage(DataManager.sharedInstance.myUser.userID)
        username.text = "\(DataManager.sharedInstance.myUser.username)\né o seu username"
        let buttonContinue = UIBarButtonItem(title: "Update Username", style: .Plain, target: self, action: "continueAction")
        self.navigationItem.rightBarButtonItem = buttonContinue

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func continueAction() {
        if myUserName.text?.isEmpty == true {
            DataManager.sharedInstance.createSimpleUIAlert(self, title: "Atenção", message: "Digite um username para atualizar", button1: "OK")
        }
        else {
            http.updateUserWithID(DataManager.sharedInstance.myUser.userID, username: "\(myUserName.text!)", location: nil, altitude: nil, fbid: nil, photo: nil, name: nil, email: nil, password: nil, completion: { (result) -> Void in
                let JSON = result
                let dic = JSON as NSDictionary
                if dic["error"] != nil {
                    DataManager.sharedInstance.createSimpleUIAlert(self, title: "Error", message: dic["error"] as! String, button1: "Ok")
                    print("erro aqui")
                }
                else {
                    DataManager.sharedInstance.createSimpleUIAlert(self, title: "Atenção", message: "Usuário Atualizado: \(self.myUserName.text!)", button1: "Ok")
                    self.exitView()
                }
            })
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

    @IBAction func deleteAccount(sender: AnyObject) {
    }
    
    
    @IBAction func loggoutFace(sender: AnyObject) {
    }
    
    func exitView() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
