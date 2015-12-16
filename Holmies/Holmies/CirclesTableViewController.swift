//
//  CirclesTableViewController.swift
//  Holmies
//
//  Created by Leonardo Geus on 22/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit
import QuartzCore
import FBSDKCoreKit
import FBSDKLoginKit

class CirclesTableViewController: UITableViewController {
    
    let http = HTTPHelper()
    let lightBlue:UIColor = UIColor(red: 61.0/255.0, green: 210.0/255.0, blue: 228.0/255.0, alpha: 1)
    let mainRed: UIColor = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1)
    let lightGray = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)

    var imageX = 0.0
    
    var lastSelectedIndex = 0
    
    @IBOutlet var shareTypeSegmentedControl: UISegmentedControl!
    

    let app = UIApplication.sharedApplication()
    
    //view do user
    @IBOutlet weak var imageUserInView: UIImageView!
    @IBOutlet weak var usernameInView: UILabel!
    @IBOutlet weak var userView: UIView!
    @IBAction func buttonToEditGroup(sender: AnyObject) {
        performSegueWithIdentifier("myUserInfo", sender: self)
    }
    
    //variaveis controle de sem grupo
    var noGroups = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.sharedInstance.appIsActive = true
        print("PRINT PARA VER SE ESTA EMPLIHANDO MUITAS TELAS")
        
        DataManager.sharedInstance.activeView = "circles"
        
        reloadData()
        
        
        let buttonName = UIButton()
        buttonName.setImage(UIImage(named:"people32.png"), forState: .Normal)
        buttonName.frame = CGRect(x: 0, y: 0, width: 46 * 0.6, height: 34 * 0.6)
        buttonName.addTarget(self, action: "addFriendSelector", forControlEvents: .TouchUpInside)
        let leftButton = UIBarButtonItem()
        leftButton.customView = buttonName
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.hidesBackButton = true
        
    
        
       let screenSize = self.view.frame.size.width
//        let peopleButton = DataManager.sharedInstance.imageResize(UIImage(named: "people32.png")!, sizeChange: CGSizeMake(46 * 0.6 * screenSize / 414, 34 * 0.6 * screenSize / 414))
//        
//        
//        
//        self.navigationItem.leftBarButtonItem?.image = peopleButton
//       self.navigationItem.leftBarButtonItem?.title = ""
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "charmAccepted:", name: "charmAccepted", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "charmReceived:", name: "charmReceived", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "charmRejected:", name: "charmRejected", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "charmExpired:", name: "charmExpired", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "charmFound:", name: "charmFound", object: nil)
        

        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
//                for family: String in UIFont.familyNames()
//                {
//                    print("\(family)")
//                    for names: String in UIFont.fontNamesForFamilyName(family)
//                    {
//                        print("== \(names)")
//                    }
//                }
        
        if screenSize == 480 {
            
        }
        
        self.refreshControl?.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)

        
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self,action:"refreshData",forControlEvents:.ValueChanged)
        self.refreshControl = refresh
        
        
        navigationBarGradient()
        //        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onTokenUpdated:", name:FBSDKAccessTokenDidChangeNotification, object: nil)
        
        
        userView.layer.borderWidth = 0
        
        DataManager.sharedInstance.selectedFriends.removeAll()
        
        if refreshControl?.refreshing == false {
        
            self.refreshControl?.beginRefreshing()
        }

        
        DataManager.sharedInstance.timer2 = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("reloadData"), userInfo: nil, repeats: true)
        
        
        
        //view auxiliar
        
        let id = DataManager.sharedInstance.myUser.userID
        let image = DataManager.sharedInstance.findImage(id)
        imageUserInView.image = image
        usernameInView.text = "\(DataManager.sharedInstance.myUser.username)"
        //self.navigationItem.rightBarButtonItem = buttonContinue
        imageUserInView.layer.cornerRadius = imageUserInView.frame.size.width / 2
        imageUserInView.layer.borderColor = UIColor.whiteColor().CGColor
        imageUserInView.layer.borderWidth = 1.0
        imageUserInView.clipsToBounds = true
        usernameInView.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
        usernameInView.textColor = UIColor.whiteColor()
        
       imageUserInView.autoresizingMask = [UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleWidth]
        imageUserInView.contentMode = UIViewContentMode.ScaleAspectFill

        

        
//        let userViewBackgroundImage = DataManager.sharedInstance.imageResize(UIImage(named: "redLights.png")!, sizeChange: CGSize(width: self.view.frame.width, height: self.view.frame.height / 5.15))
//        userView.backgroundColor = UIColor(patternImage: userViewBackgroundImage)
        
        
        
        
        
        
        

        
        
        //let ll = FBSDKAccessToken.currentAccessToken().tokenString
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("Nao fez login face")
            if let fbId = DataManager.sharedInstance.myUser.facebookID {
                print(fbId)
                
                let alert = UIAlertController(title: "Facebook", message: "We need to link your Facebook Account again", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
                    self.getFBUserData({ (result) -> Void in
                        let newFBID = result as String
                            print(newFBID)
//                        if newFBID == fbId {
                            DataManager.sharedInstance.createSimpleUIAlert(self, title: "Success", message: "Successfully connected to your Facebook Account", button1: "OK")
                            DataManager.sharedInstance.requestFacebook(self,completion: { (result) -> Void in
                            })
//                        }
//                        else {
//                            DataManager.sharedInstance.createSimpleUIAlert(self, title: "Atenção", message: "Login com facebook não concluido, pois esta conta não condiz com nossos registros. Porfavor, deslogue de sua conta antiga para logar em uma nova", button1: "Ok")
//                            let loginManager = FBSDKLoginManager()
//                            loginManager.logOut()
//                            
//                        }
                    })
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
                
                
                

            }
        }
        else {
            DataManager.sharedInstance.requestFacebook(self,completion: { (result) -> Void in
            })
        }
        
    
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let id = DataManager.sharedInstance.myUser.userID
        let image = DataManager.sharedInstance.findImage(id)
        imageUserInView.image = image
        
        if DataManager.sharedInstance.allGroup.count == 0 {
            noGroups = true
            self.viewDidLoad()
        }
        else {
            noGroups = false
        }
        DataManager.sharedInstance.activeView = "circles"
        DataManager.sharedInstance.linkGroupAndUserToSharer { (result) -> Void in
            self.tableView.reloadData()
            
        
            
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "existGroups", name:"ExistGroup", object: nil)
        DataManager.sharedInstance.timer3 = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "UpdateTableView", userInfo: nil, repeats: true)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: "ExistGroup", object: nil)
        DataManager.sharedInstance.timer3.invalidate()
    }
    
    func existGroups() {
        noGroups = false
    }
    
    func UpdateTableView() {
        tableView.reloadData()
    }

    
    func getFBUserData(completion:(result:String)->Void){
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    if (FBSDKAccessToken.currentAccessToken() == nil) {
                        print("Nao fez login face")
                    }
                    else {
                        print("Ja logado face")
                        let loginButton = FBSDKLoginButton()
                        loginButton.readPermissions = ["id","first_name","last_name","friends{id,name}","email"]
                        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,friends{id,name}"], HTTPMethod: "GET")
                        request.startWithCompletionHandler { (connection, result, error) -> Void in
                            // print(error)
                            if let resultData = result as? NSDictionary {
                                
                                let fbID = resultData["id"] as! String
                                completion(result: fbID)
                            }
                            
                        }
                    }
                }
            }
        })

        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if DataManager.sharedInstance.allGroup.count == 0 {
            self.noGroups = true
        }
        else {
            self.noGroups = false
        }
        
        if shareTypeSegmentedControl.selectedSegmentIndex == 0 {
            if noGroups {
                return 1
            }
            return DataManager.sharedInstance.allGroup.count
        }
        else {
            if DataManager.sharedInstance.myCharms.count == 0 {
                return 1
            }
            return DataManager.sharedInstance.myCharms.count
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        DataManager.sharedInstance.selectedFriends.removeAll()
        reloadData()
        
        let navigationBarBackgroundImage = DataManager.sharedInstance.imageResize(UIImage(named: "topNavigationBackground.png")!, sizeChange: CGSizeMake((self.navigationController?.navigationBar.frame.size.width)!, ((self.navigationController?.navigationBar.frame.height)! + app.statusBarFrame.size.height)))
        
        self.navigationController?.navigationBar.setBackgroundImage(navigationBarBackgroundImage, forBarMetrics: .Default)
        
    }
    
    func refreshData() {
        reloadData()
    }
    
    func reloadData() {
        if DataManager.sharedInstance.appIsActive {
            self.tableView.reloadData()
            DataManager.sharedInstance.isUpdating = true
            if DataManager.sharedInstance.testIfFileExistInDocuments("/\(DataManager.sharedInstance.myUser.userID).jpg") {
                let id = DataManager.sharedInstance.myUser.userID
                let image = DataManager.sharedInstance.findImage(id)
                imageUserInView.image = image
            }
            DataManager.sharedInstance.requestSharers { (result) -> Void in
                
                
                DataManager.sharedInstance.requestGroups { (result) -> Void in
                    
                    DataManager.sharedInstance.allGroup = DataManager.sharedInstance.convertJsonToGroup(result)
                    
                    DataManager.sharedInstance.linkGroupAndUserToSharer({ (result) -> Void in
                    })
                    

                    
                    
                    
                    
                    DataManager.sharedInstance.requestSharerInGroups()
                    let friends = DataManager.sharedInstance.loadJsonFromDocuments("friends")
                    for index in DataManager.sharedInstance.allFriends {
                        if !(index.facebookID == nil) && !(index.userID == nil) {
                            let image = DataManager.sharedInstance.getProfPic(index.facebookID, serverId: index.userID)
                            DataManager.sharedInstance.saveImage(image, id: index.userID)
                        }
                    }
                    if DataManager.sharedInstance.myUser.facebookID != nil {
                        let myPhoto = DataManager.sharedInstance.getProfPic(DataManager.sharedInstance.myUser.facebookID, serverId: DataManager.sharedInstance.myUser.userID)
                        DataManager.sharedInstance.saveImage(myPhoto, id: DataManager.sharedInstance.myUser.userID)
                    }
                    DataManager.sharedInstance.allFriends = DataManager.sharedInstance.convertJsonToUser(friends)
                    DataManager.sharedInstance.didUpdateCharms = true
                    NSNotificationCenter.defaultCenter().postNotificationName("delegateUpdate", object: nil)
                    DataManager.sharedInstance.finishedAllRequest = true
                    DataManager.sharedInstance.isUpdating = false
                    
                    if DataManager.sharedInstance.allGroup.count < 1 {
                        self.noGroups = true
                    }
                    else {
                        self.noGroups = false
                    }
                    
					DataManager.sharedInstance.linkGroupAndUserToSharer({ (result) -> Void in
                    	print("\(result)")
                    	self.tableView.reloadData()
                    	if self.refreshControl?.refreshing == true {
                        	self.refreshControl?.endRefreshing()
                        	if self.shareTypeSegmentedControl.selectedSegmentIndex == 1 {
                            	DataManager.sharedInstance.didUpdateCharms = true
                            	NSNotificationCenter.defaultCenter().postNotificationName("delegateUpdate", object: nil)
                        	}
                    	}
                    	DataManager.sharedInstance.finishedAllRequest = true
                    	DataManager.sharedInstance.isUpdating = false
                    
                	})
                    
                    
                }
            }
            DataManager.sharedInstance.saveMyInfo()
        }
        else {
            DataManager.sharedInstance.eraseData()
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        
        let squareRed = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1)
        if shareTypeSegmentedControl.selectedSegmentIndex == 0 {
            if DataManager.sharedInstance.allGroup.count < 1 {
                self.noGroups = true
            }
            else {
                self.noGroups = false
            }
            if noGroups == true {
                
                let emptyGroup = tableView.dequeueReusableCellWithIdentifier("noGroup", forIndexPath: indexPath) as! EmptyGroupTableViewCell
                self.tableView.rowHeight = 100
                emptyGroup.imageEmpty.layer.borderWidth = 2.0
                emptyGroup.imageEmpty.layer.cornerRadius = 8 / 414 * self.view.frame.size.width
                emptyGroup.imageEmpty.layer.borderColor = lightBlue.CGColor

                emptyGroup.firstLabel.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
                emptyGroup.firstLabel.textColor = mainRed
                emptyGroup.secondLabel.font = UIFont(name: "SFCompactDisplay-Light", size: 17)
                emptyGroup.secondLabel.textColor = UIColor.blackColor()
                emptyGroup.firstLabel.text = "No groups"
                emptyGroup.secondLabel.text = "Click here to create a group"
                emptyGroup.tag = 999
                
                switch self.view.frame.size.height {
                    case 416:
                    emptyGroup.secondLabel.font = UIFont(name: "SFCompactDisplay-Light", size: 12)
                    break
                    
                    case 504:
                    emptyGroup.secondLabel.font = UIFont(name: "SFCompactDisplay-Light", size: 12)
                    break
                    
                    default:
                    emptyGroup.secondLabel.font = UIFont(name: "SFCompactDisplay-Light", size: 17)
                    break
                }
            
            
                return emptyGroup
                
            }
            
            for activeGroup in DataManager.sharedInstance.activeGroup {
                if activeGroup.id == DataManager.sharedInstance.allGroup[indexPath.row].id {
                    
                    let cellActive = tableView.dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath) as! ActiveGroupTableViewCell
                    //print(DataManager.sharedInstance.allGroup)
                    
                    
                    
                    //let sharers = DataManager.sharedInstance.allSharers
                    
                    
                    
                    
                    
                    
                    cellActive.timeLabel.text = ""
                    cellActive.nameGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].name
                    cellActive.numberLabel.text = ""
                    
                    self.tableView.rowHeight = 75
                    cellActive.nameGroup.textColor = UIColor(red: 56.0/255.0, green: 56.0/255.0, blue: 56.0/255.0, alpha: 1.0)
                    cellActive.nameGroup.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
                    //print("celula: \(cellActive.nameGroup.font)")
                    cellActive.coloredSquare.backgroundColor = squareRed
                    cellActive.numberLabel.font = UIFont(name: "SFUIDisplay-Ultralight", size: 47)
                    cellActive.timeLabel.font = UIFont(name: "SFUIText-Medium", size: 12)
                    cellActive.coloredSquare.layer.cornerRadius = 8.0 / 414.0 * self.view.frame.size.width
                    
                    
                    
                    
                    
                    let spaceInCell = 10.0
                    let numbersOfCellsInScrol = 6.0
                    let scrollViewSizeHeight = Double(cellActive.scrollViewFriends.frame.size.height)
                    let scrollViewSizeWidth = Double(cellActive.scrollViewFriends.frame.size.width)
                    var sizeOfImageHeight = Double()
                    var sizeOfImageWidth = Double()
                    
                    
   
                    
                    
                    if (scrollViewSizeWidth/numbersOfCellsInScrol) - spaceInCell/2 < scrollViewSizeHeight {
                        sizeOfImageWidth = (scrollViewSizeWidth/numbersOfCellsInScrol) - spaceInCell/2
                    }
                    else {
                        sizeOfImageWidth = (scrollViewSizeWidth/numbersOfCellsInScrol) - spaceInCell/2 - 8
                    }
                    
                    sizeOfImageHeight = sizeOfImageWidth
                    
                    
                    

                    
                    let subViews = cellActive.scrollViewFriends.subviews
                    for subview in subViews {
                        subview.removeFromSuperview()
                    }
                    
                    if let _ = DataManager.sharedInstance.allGroup[indexPath.row].users {
                        var  i = 0
                        for user in DataManager.sharedInstance.allGroup[indexPath.row].users {
                            let userid = user.userID
                            let imageName = DataManager.sharedInstance.findImage(userid)
                            
                            let status = DataManager.sharedInstance.findStatusOfUserInGroup(user.userID, groupId: DataManager.sharedInstance.allGroup[indexPath.row].id)
                            
                          
                            let imageView = UIImageView(frame: CGRect(x: imageX, y: 0, width: sizeOfImageWidth, height: sizeOfImageHeight))
                            imageView.image = imageName
                            
                            imageView.frame = CGRect(x: imageX, y: 0, width: sizeOfImageWidth, height: sizeOfImageHeight)
                            imageView.layer.cornerRadius = 20 / 414 * self.view.frame.size.width
                        
                            print("tamanho da tela: \(self.view.frame.size.width)")
                            
                            if status == "accepted" {
                                imageView.layer.borderWidth = 2.0
                            } else {
                                imageView.layer.borderWidth = 0
                                imageView.alpha = 0.6

                            }
                            
                            imageView.layer.borderColor = mainRed.CGColor
                            imageView.clipsToBounds = true
                            

                            if i < 5 {
                            
                                cellActive.scrollViewFriends.addSubview(imageView)
                                imageX += sizeOfImageWidth + spaceInCell}
                            i++
                            
                        }
                    }
                    
                    
                    imageX = 0
                    
                    
                    
                    if let _ = DataManager.sharedInstance.allGroup[indexPath.row].share {
                        
                        if !(DataManager.sharedInstance.allGroup[indexPath.row].share.until == nil) {
                            
                            
                            
                            
                            
                            let createdHour = DataManager.sharedInstance.allGroup[indexPath.row].createdAt
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
                            dateFormatter.timeZone = NSTimeZone(name: "UTC")
                            let date = dateFormatter.dateFromString(createdHour)
                            let durationString = DataManager.sharedInstance.allGroup[indexPath.row].share.until
                            cellActive.tag = 2
                            if !(durationString == "0") {
                                let durationFloat = Float(durationString)
                                let finalDate = date?.dateByAddingTimeInterval(NSTimeInterval(durationFloat!))
                                
                                
                                let duration = finalDate?.timeIntervalSinceNow
                                if duration < 0 {
                                    cellActive.numberLabel.text = "0"
                                    cellActive.timeLabel.text = "expired"
                                    cellActive.selectionStyle = UITableViewCellSelectionStyle.None
                                    //cellActive.userInteractionEnabled = false
                                    cellActive.coloredSquare.backgroundColor = UIColor.grayColor()
                                    cellActive.tag = 100
                                    
                                }
                                else if duration <= 3600 {
                                    let newDurationMin = Int(duration!/60)
                                    cellActive.numberLabel.text = "\(newDurationMin)"
                                    cellActive.timeLabel.text = "minutes"
                                    
                                }
                                else if duration > 3600 && duration <= 360000 {
                                    var newDurationHours = Int(duration!/3600)
                                    newDurationHours++
                                    cellActive.numberLabel.text = "\(newDurationHours)"
                                    cellActive.timeLabel.text = "hours"
                                } else if duration > 360000 {
                                    let duration2 = duration!/86400
                                    
                                    var newDurationDays = Int(duration2)
                                    newDurationDays++
                                    cellActive.numberLabel.text = "\(newDurationDays)"
                                    cellActive.timeLabel.text = "days"
                                }
                        
                            } else {
                                cellActive.numberLabel.text = "∞"
                                cellActive.timeLabel.text = "days"
                            }
                    
                        }
                        
                    }
                    
                    return cellActive
                    
                    
                }
            }
            
            
            
            let cellPendent = tableView.dequeueReusableCellWithIdentifier("pendentCell", forIndexPath: indexPath) as! NewGroupTableViewCell
            self.tableView.rowHeight = 75
            
            cellPendent.timeLabel.text = ""
            

            
            let createdHour = DataManager.sharedInstance.allGroup[indexPath.row].createdAt
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            let date = dateFormatter.dateFromString(createdHour)
            let durationString = DataManager.sharedInstance.allGroup[indexPath.row].share.until
            cellPendent.tag = 1
            if !(durationString == "0") {
                let durationFloat = Float(durationString)
                let finalDate = date?.dateByAddingTimeInterval(NSTimeInterval(durationFloat!))
                
                
                let duration = finalDate?.timeIntervalSinceNow
                
                
                if !(duration == nil) {
                    let duration = Int(duration!)
                    
                    if duration < 0 {
                        cellPendent.numberLabel.text = "0"
                        cellPendent.timeLabel.text = "expired"

                    }
                    else if duration <= 3600 {
                        let newDurationMin = Int(duration/60)
                        cellPendent.numberLabel.text = "\(newDurationMin)"
                        cellPendent.timeLabel.text = "minutes"
                    }
                    else if duration > 3600 && duration <= 360000 {
                        var newDurationHours = Int(duration/3600)
                        newDurationHours++
                        cellPendent.numberLabel.text = "\(newDurationHours)"
                        cellPendent.timeLabel.text = "hours"
                    } else if duration > 360000 {
                        var newDurationDays = Int(duration/86400)
                        newDurationDays++
                        cellPendent.numberLabel.text = "\(newDurationDays)"
                        cellPendent.timeLabel.text = "days"
                    }
                }
            }
            else {
                cellPendent.numberLabel.text = "∞"
                cellPendent.timeLabel.text = "days"
            }
            
            
            cellPendent.nameGroup.text = DataManager.sharedInstance.allGroup[indexPath.row].name
            cellPendent.nameGroup.textColor = mainRed
            cellPendent.nameGroup.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
            cellPendent.coloredSquare.backgroundColor = lightBlue
            cellPendent.numberLabel.font = UIFont(name: "SFUIDisplay-Ultralight", size: 47)
            cellPendent.timeLabel.font = UIFont(name: "SFUIText-Medium", size: 12)
            cellPendent.coloredSquare.layer.cornerRadius = 8.0
            
            
            
            
            // cellPendent.coloredSquare.backgroundColor = UIColor(patternImage: radialGradient!)
            cellPendent.accepted = { [unowned self] (selectedCell) -> Void in
                let path = tableView.indexPathForRowAtPoint(selectedCell.center)!
                DataManager.sharedInstance.activeGroup.append(DataManager.sharedInstance.allGroup[path.row])
                let group = DataManager.sharedInstance.activeGroup
                
                let dic = DataManager.sharedInstance.convertGroupToNSDic(group)
                
                for sharer in DataManager.sharedInstance.allSharers {
                    if sharer.receiver == DataManager.sharedInstance.allGroup[path.row].id && sharer.owner == DataManager.sharedInstance.myUser.userID {
                        self.http.updateSharerWithID(sharer.id, until: nil, status: "accepted", completion: { (result) -> Void in
                            self.reloadData()
                        })
                    }
                }
                
                
                
                
                
                DataManager.sharedInstance.createJsonFile("activeGroups", json: dic)
            }
            
            
            
            cellPendent.rejected = { [unowned self] (selectedCell) -> Void in
                //            let path = tableVipew.indexPathForRowAtPoint(selectedCell.center)!
                let path = tableView.indexPathForRowAtPoint(selectedCell.center)!
                let id = DataManager.sharedInstance.allGroup[path.row].id as String
                self.http.destroySharerWithSharerType(.userToGroup, ownerID: DataManager.sharedInstance.myUser.userID, receiverID: id, completion: { (result) -> Void in
                    self.reloadData()
                })
                
            }
            return cellPendent
            

            
        }
        else {
            
            
            
            if DataManager.sharedInstance.myCharms.count == 0 {
                let emptyGroup = tableView.dequeueReusableCellWithIdentifier("noGroup", forIndexPath: indexPath) as! EmptyGroupTableViewCell
                self.tableView.rowHeight = 100
                emptyGroup.imageEmpty.layer.cornerRadius = emptyGroup.imageEmpty.frame.size.width / 2
                emptyGroup.imageEmpty.layer.borderColor = lightBlue.CGColor
                emptyGroup.imageEmpty.layer.borderWidth = 2.0
                emptyGroup.firstLabel.font = UIFont(name: "SFUIDisplay-Medium", size: 17)
                emptyGroup.firstLabel.textColor = mainRed
                emptyGroup.firstLabel.text = "No whistle"
                
                emptyGroup.secondLabel.textColor = UIColor.blackColor()
                emptyGroup.secondLabel.text = "Click here to send a whistle"
                emptyGroup.tag = 998
                
                switch self.view.frame.size.height {
                case 416:
                    emptyGroup.secondLabel.font = UIFont(name: "SFCompactDisplay-Light", size: 12)
                    break
                case 504:
                    emptyGroup.secondLabel.font = UIFont(name: "SFCompactDisplay-Light", size: 12)
                    break
                    
                default:
                    emptyGroup.secondLabel.font = UIFont(name: "SFCompactDisplay-Light", size: 17)
                    break
                }

                return emptyGroup
            }
            
            
            
            
            
            
            
            let charmCell = tableView.dequeueReusableCellWithIdentifier("charmCell", forIndexPath: indexPath) as! CharmTableViewCell
            self.tableView.rowHeight = 100

            let actualCharm = DataManager.sharedInstance.myCharms[indexPath.row]
            let actualFriend = actualCharm.friend
            let actualSharer = actualCharm.sharer
            
            charmCell.nameLabel.text = actualFriend.username
            let imageName = DataManager.sharedInstance.findImage(actualFriend.userID)
            
            charmCell.userPictureImageView.layer.cornerRadius = charmCell.userPictureImageView.frame.size.width / 2
            charmCell.userPictureImageView.layer.borderColor = mainRed.CGColor
            charmCell.userPictureImageView.layer.borderWidth = 3
            charmCell.userPictureImageView.clipsToBounds = true
            charmCell.userPictureImageView.image = imageName
            
            
//            let imageView = UIImageView(image: imageName)
//            
//            imageView.layer.cornerRadius = 20.0
//            imageView.clipsToBounds = true
//            imageView.frame.size = charmCell.userPictureImageView.frame.size
//            imageView.frame.origin = CGPoint(x: 0, y: 0)
//            
            
//            for subview in charmCell.userPictureImageView.subviews {
//                subview.removeFromSuperview()
//            }
//            charmCell.userPictureImageView.addSubview(imageView)
//            
//            let bgImageView = UIImageView()
//            bgImageView.layer.borderColor = mainRed.CGColor
//            bgImageView.layer.cornerRadius = 20.0
//            bgImageView.clipsToBounds = true
//            bgImageView.frame.size = charmCell.backgroundImage.frame.size
//            bgImageView.frame.origin = CGPoint(x: 0, y: 0)
//            bgImageView.layer.borderWidth = 2.0
//            
//            for subview in charmCell.backgroundImage.subviews {
//                subview.removeFromSuperview()
//            }
            
            let duration = DataManager.sharedInstance.verifySharerStatus(actualSharer)

            
            if actualSharer.status == "pending" {
                
                if actualSharer.owner == DataManager.sharedInstance.myUser.userID {
                    charmCell.userPictureImageView.layer.borderColor = lightBlue.CGColor
                    charmCell.nameLabel.textColor = lightBlue
                    charmCell.nameLabel.font = UIFont(name: "SFUIDisplay-Medium", size: 20)
                    charmCell.remainingTimeLabel.textColor = lightGray
                    charmCell.remainingTimeLabel.font = UIFont(name: "SFCompactDisplay-Light", size: 17)
                    // bgImageView.layer.borderColor = mainRed.CGColor
                    if duration > 60 {
                        if duration == 1 {
                            charmCell.remainingTimeLabel.text = "\(duration!/60) minute remaining"

                        }else {
                        
                        charmCell.remainingTimeLabel.text = "\(duration!/60) minutes remaining"
                    }
                        
                    }
                    else if duration <= 0 {
                        charmCell.remainingTimeLabel.text = "Expired"
                        actualSharer.status = "Expired"
                        //NSNotificationCenter.defaultCenter().postNotificationName("delegateUpdate", object: nil)
                        
                    }
                    else {
                        charmCell.remainingTimeLabel.text = "\(duration!) seconds remaining"
                    }
                }
                else {
                    charmCell.remainingTimeLabel.text = "Waiting for approval"
                }
            }
            else if actualSharer.status == "active" || actualSharer.status == "accepted" {
                charmCell.remainingTimeLabel.text = "Active"
            }
            else if actualSharer.status == "found"{
                charmCell.remainingTimeLabel.text = "Found"
                charmCell.userPictureImageView.layer.borderColor = mainRed.CGColor
                charmCell.nameLabel.textColor = mainRed

                //bgImageView.layer.borderColor = lightBlue.CGColor
            }
            else if actualSharer.status == "rejected"{
                charmCell.remainingTimeLabel.text = "Rejected"
                charmCell.nameLabel.textColor = UIColor.grayColor()
                charmCell.userPictureImageView.layer.borderColor = UIColor.grayColor().CGColor
               // bgImageView.layer.borderColor = UIColor.grayColor().CGColor
            }
            else {
                charmCell.remainingTimeLabel.text = "Expired"
                charmCell.userPictureImageView.layer.borderColor = UIColor.grayColor().CGColor
                charmCell.nameLabel.textColor = UIColor.grayColor()

                //bgImageView.layer.borderColor = UIColor.grayColor().CGColor
                
            }
           // charmCell.backgroundImage.addSubview(bgImageView)
            return charmCell
            
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        

        let cell = tableView.cellForRowAtIndexPath(indexPath)
                print(cell!.tag)
        if cell?.tag == 100 {
//            let groupName = DataManager.sharedInstance.allGroup[indexPath.row].name
//            let alert = UIAlertController(title: "Attention", message: "\(groupName) is expired.", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Delete Group", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
//                //DataManager.sharedInstance.destroyGroupWithNotification(DataManager.sharedInstance.allGroup[indexPath.row], view: self)
//                DataManager.sharedInstance.destroySharerWithNotification(DataManager.sharedInstance.allGroup[indexPath.row], view: self)
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
//            alert.addAction(UIAlertAction(title: "Change Duration", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
            self.reloadData()
        
        }
        else if cell?.tag == 200 {
            performSegueWithIdentifier("addGroup", sender: self)
        }
        else if cell?.tag == 2 {

                if shareTypeSegmentedControl.selectedSegmentIndex == 0 {
                   
                    DataManager.sharedInstance.activeUsers = DataManager.sharedInstance.allGroup[indexPath.row].users
                    DataManager.sharedInstance.selectedGroup = DataManager.sharedInstance.allGroup[indexPath.row]
                    
                    
                    DataManager.sharedInstance.selectedSharer = DataManager.sharedInstance.loadSharerInAGroupFromDocuments(DataManager.sharedInstance.allGroup[indexPath.row].id)
                    

                    
                    
//                    for sharersInMap in DataManager.sharedInstance.sharesInGroups {
//                        if sharersInMap[0].receiver == DataManager.sharedInstance.selectedGroup.id {
//                            DataManager.sharedInstance.selectedSharer = sharersInMap
//                            break
//                        }
//                    }
                    
                    if DataManager.sharedInstance.finishedAllRequest == true {
                        
                        performSegueWithIdentifier("showMap", sender: self)
                    }

                    
                }
                else {

                }
                
            
            
        }
        else if cell?.tag == 999 || cell?.tag == 998 {
            performSegueWithIdentifier("addGroup", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showMap") {
            if let viewController: MapGoogleViewController = segue.destinationViewController as? MapGoogleViewController {
                viewController.isCharm = DataManager.sharedInstance.isCharm
                viewController.enterInView = true
            }
        }
        if (segue.identifier == "addGroup") {
            if shareTypeSegmentedControl.selectedSegmentIndex == 1 {
                let viewController = segue.destinationViewController as! CreateGroupViewController
                viewController.isCharm = true
            }
        }
    }
    
    private func imageLayerForGradientBackground() -> UIImage {
        
        var updatedFrame = self.navigationController?.navigationBar.bounds
        updatedFrame!.size.height += 20
        let layer = CAGradientLayer.gradientLayerForBounds(updatedFrame!)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func navigationBarGradient () {
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let fontDictionary = [ NSForegroundColorAttributeName:UIColor.whiteColor() ]
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
//        self.navigationController?.navigationBar.layer.borderWidth = 4
//        self.navigationController?.navigationBar.layer.borderColor = UIColor.clearColor().CGColor
      // self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), forBarMetrics: UIBarMetrics.Default)
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.tag == 2 {
            return UITableViewCellEditingStyle.Delete
        } else if cell?.tag == 100 {
            return UITableViewCellEditingStyle.Delete
        }
        else {
            return UITableViewCellEditingStyle.None
        }
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if self.shareTypeSegmentedControl.selectedSegmentIndex == 0 {
                let id = DataManager.sharedInstance.allGroup[indexPath.row].id as String
                self.http.destroySharerWithSharerType(.userToGroup, ownerID: DataManager.sharedInstance.myUser.userID, receiverID: id, completion: { (result) -> Void in
                    self.reloadData()
                })
            }
            else {
//                let myId = DataManager.sharedInstance.myUser.userID
//                let friendId = DataManager.sharedInstance.myCharms[indexPath.row].friend.userID as String
//                self.http.destroySharerWithSharerType(.userToUser, ownerID: myId, receiverID: friendId, completion: { (result) -> Void in
//                    self.reloadData()
//                })
            }
            
        }
        //        else if editingStyle == .Insert {
        //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //       
    }
    

    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.tag == 2 {
        
        
            if self.shareTypeSegmentedControl.selectedSegmentIndex == 0 {
                
                let editGroup = UITableViewRowAction(style: .Normal, title: " Edit ", handler: {(rowAction:UITableViewRowAction, indexPath: NSIndexPath) -> Void in
                    
                    //Editar o grupo
                    DataManager.sharedInstance.activeUsers = DataManager.sharedInstance.allGroup[indexPath.row].users
                    DataManager.sharedInstance.selectedGroup = DataManager.sharedInstance.allGroup[indexPath.row]
                    
                    
                    DataManager.sharedInstance.selectedSharer = DataManager.sharedInstance.loadSharerInAGroupFromDocuments(DataManager.sharedInstance.allGroup[indexPath.row].id)
                    self.performSegueWithIdentifier("editGroupSegue", sender: self)
                    
                    
                })
                
                editGroup.backgroundColor = lightBlue
                
                let deleteGroup = UITableViewRowAction(style: .Destructive, title: "Delete", handler: { (rowAction:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
                    let groupName = DataManager.sharedInstance.allGroup[indexPath.row].name
                    let alert = UIAlertController(title: "Attention", message: "\(groupName) will be removed. Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Delete Group", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
                        //DataManager.sharedInstance.destroyGroupWithNotification(DataManager.sharedInstance.allGroup[indexPath.row], view: self)
                        DataManager.sharedInstance.destroySharerWithNotification(DataManager.sharedInstance.allGroup[indexPath.row], view: self)
                        DataManager.sharedInstance.allGroup.removeAtIndex(indexPath.row)
                        self.tableView.reloadData()
                        self.noGroups = true
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.reloadData()
                    
                    

                })
                

                deleteGroup.backgroundColor = mainRed
                
                return [editGroup,deleteGroup]
            }
//            else {
//                let charm = DataManager.sharedInstance.myCharms[indexPath.row]
//                if charm.sharer.status != "pending" {
//                    let deleteCharm = UITableViewRowAction(style: .Destructive, title: "Delete", handler: { (rowAction:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
//                        self.http.destroySharerWithSharerType(.userToUser, ownerID: charm.sharer.owner, receiverID: charm.sharer.receiver, completion: { (result) -> Void in
//                            self.reloadData()
//                            DataManager.sharedInstance.createSimpleUIAlert(self, title: "Removed", message: "The charm with \(charm.friend.name) has been removed successfully.", button1: "Ok")
//
//                        })
//                    })
//                
//                return [deleteCharm]
//                }
//
//            }

        }
        else if cell?.tag == 100 {
            let deleteGroup = UITableViewRowAction(style: .Destructive, title: "Delete", handler: {(rowAction:UITableViewRowAction, indexPath: NSIndexPath) -> Void in
                
                let groupName = DataManager.sharedInstance.allGroup[indexPath.row].name
                let alert = UIAlertController(title: "Attention", message: "\(groupName) will be removed. Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Delete Group", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
                    //DataManager.sharedInstance.destroyGroupWithNotification(DataManager.sharedInstance.allGroup[indexPath.row], view: self)
                    DataManager.sharedInstance.destroySharerWithNotification(DataManager.sharedInstance.allGroup[indexPath.row], view: self)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.reloadData()
                
                
            })
            deleteGroup.backgroundColor = mainRed
            
            return [deleteGroup]
        }
        
        return []
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if #available(iOS 9.0, *) {
            tableView.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
            tableView.separatorInset = UIEdgeInsetsZero
            tableView.preservesSuperviewLayoutMargins = false
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    

    
    @IBAction func segmentedControlDidChangeValue(sender: AnyObject) {
        if !DataManager.sharedInstance.isUpdating {
            self.refreshData()
            self.lastSelectedIndex = shareTypeSegmentedControl.selectedSegmentIndex
        }
        else {
            shareTypeSegmentedControl.selectedSegmentIndex = lastSelectedIndex
        }
    }
    
    func charmAccepted(notification: NSNotification) {
            if let info = notification.userInfo {
                if let charmIndex = info["charmIndex"] as? Int {
                    let charm = DataManager.sharedInstance.myCharms[charmIndex]
                    
                    let alert = UIAlertController(title: "Whistle", message: "\(charm.friend.name) accepted your whistle", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Go", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
                        DataManager.sharedInstance.selectedSharer = [charm.sharer]
                        DataManager.sharedInstance.activeUsers = [charm.friend]
                        
                        DataManager.sharedInstance.isCharm = true
                        
                        self.performSegueWithIdentifier("showMap", sender: self)
                    }))

                    self.presentViewController(alert, animated: true, completion: nil)

                    
                    
                }
                
            }
    
    }
    
    func charmReceived(notification: NSNotification) {

            if let info = notification.userInfo {
                if let charmIndex = info["charmIndex"] as? Int {
                    
                    let charm = DataManager.sharedInstance.myCharms[charmIndex]
                    
                    
                    let alert = UIAlertController(title: "Whistle", message: "You have received a whistle from \(charm.friend.name)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
                        
                        charm.sharer.status = "accepted"
                        DataManager.sharedInstance.myCharms[charmIndex] = charm
                        self.http.updateSharerWithID(charm.sharer.id, until: nil, status: "accepted", completion: { (result) -> Void in
                            DataManager.sharedInstance.selectedSharer = [charm.sharer]
                            DataManager.sharedInstance.activeUsers = [charm.friend]
                            
                            DataManager.sharedInstance.isCharm = true
                            
                            self.performSegueWithIdentifier("showMap", sender: self)
    
                        })
                        

                    }))
                    alert.addAction(UIAlertAction(title: "Reject", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
                        charm.sharer.status = "rejected"
                        
                        DataManager.sharedInstance.lastCharms[charmIndex] = charm
                        
                        self.http.updateSharerWithID(charm.sharer.id, until: nil, status: "rejected", completion: { (result) -> Void in
                            self.reloadData()
                        })
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    

                    
                }
                

        }
        else {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        
    }
    
    func charmRejected(notification: NSNotification) {
            if let info = notification.userInfo {
                if let charmIndex = info["charmIndex"] as? Int {
                    let charm = DataManager.sharedInstance.myCharms[charmIndex]

                    let alert = UIAlertController(title: "Whistle", message: "\(charm.friend.name) rejected your whistle", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
                        self.http.destroySharerWithSharerType(.userToUser, ownerID: charm.sharer.owner, receiverID: charm.sharer.receiver, completion: { (result) -> Void in
                            
                        })
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                    
                }
                
            }
        
    }
    
    func charmExpired(notification: NSNotification) {
        if let info = notification.userInfo {
            if let charmIndex = info["charmIndex"] as? Int {
                let charm = DataManager.sharedInstance.myCharms[charmIndex]
                
                let alert = UIAlertController(title: "Whistle", message: "The whistle you sent to \(charm.friend.name) has expired", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
                    self.http.destroySharerWithSharerType(.userToUser, ownerID: charm.sharer.owner, receiverID: charm.sharer.receiver, completion: { (result) -> Void in
                        
                    })
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
            }
            
        }
        
    }
    
    func charmFound(notification: NSNotification) {
        //if DataManager.sharedInstance.activeView == "circles" {
            if let info = notification.userInfo {
                if let charmIndex = info["charmIndex"] as? Int {
                    let charm = DataManager.sharedInstance.myCharms[charmIndex]
                    
                    let friendName = charm.friend.name
                    let alert = UIAlertController(title: "Found", message: "\(friendName) has found you", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
                        self.http.destroySharerWithSharerType(.userToUser, ownerID: charm.sharer.owner, receiverID: charm.sharer.receiver, completion: { (result) -> Void in
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        })
                        
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
        //}
        
    }
    
    func addFriendSelector() {
        self.performSegueWithIdentifier("addFriend", sender: self)
    }
    
}





extension CAGradientLayer {
    class func gradientLayerForBounds(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        let navigationBarRed1 = UIColor(red: 205.0/255.0, green: 16.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        let navigationBarRed2 = UIColor(red: 213.0/250.0, green: 9.0/255.0, blue: 43.0/255.0, alpha: 1.0)
        let mainRed: UIColor = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1)
        layer.colors = [mainRed.CGColor, mainRed.CGColor]
        return layer
    }
    
    
}


