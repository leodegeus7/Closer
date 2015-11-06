////
////  AddGroupNameViewController.swift
////  Holmies
////
////  Created by Leonardo Geus on 02/10/15.
////  Copyright © 2015 Leonardo Geus. All rights reserved.
////
//
//import UIKit
//import Alamofire
//
//class AddGroupNameViewController: UIViewController {
//    var selectID = [Int]()
//    var nameGroup = ""
//    @IBOutlet weak var textFieldGroupName: UITextField!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    @IBAction func addGroupButton(sender: AnyObject) {
//        nameGroup = textFieldGroupName.text!
//        var castString = nameGroup
//        if nameGroup.containsString(" ") {
//            castString = nameGroup.stringByReplacingOccurrencesOfString(" ", withString: "%20")
//            
//        }
//        
//        
//            Alamofire.request(.GET, "https://tranquil-coast-5554.herokuapp.com/groups/add_new_group?name=\(castString)").responseJSON { response in
//                
//                if let JSON = response.result.value {
//                    if let dic = JSON as? NSDictionary {
//                        var idGroup = -1
//                        idGroup = dic["id"] as! Int
//                        if !(idGroup < 0) {
//                            Alamofire.request(.GET, "https://tranquil-coast-5554.herokuapp.com/sharers/add_new_sharer?owner_user=\(DataManager.sharedInstance.idUser)&receiver_group=\(idGroup)&until=24jul07").responseJSON { response in
//                                if let JSON = response.result.value {
//                                    if let dic = JSON as? NSDictionary {
//                                        print("aquii \(dic)")
//                                    }
//                                }
//                            }
//                            
//                        }
//                        
//                        for user in self.selectID {
//                            Alamofire.request(.GET, "https://tranquil-coast-5554.herokuapp.com/sharers/add_new_sharer?owner_user=\(user)&receiver_group=\(idGroup)&until=24jul07")
//                            
//                        }
//                    }
//                }
//            }
//        
//        
//        performSegueWithIdentifier("gropSegue", sender: self)
//
//        
//
//    }
//
//
//
//}
