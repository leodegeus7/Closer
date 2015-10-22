//
//  DataManager.swift
//  Holmies
//
//  Created by Leonardo Geus on 14/09/15.
//  Copyright (c) 2015 Leonardo Geus. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import MapKit
import Alamofire



class DataManager {
    var idUser:String!
    var name:String!
    var user:String!
    var idFB:String!
    var email:String!
    var friendsArray:NSMutableArray!
    var end:[String]!
    var profilePictureOfFriendsArray:Array<UIImage>!
    var locationUserArray = [Location]()
    var allUser = [User]()
    var allGroup = [Group]()
    var friendsDictionaryFace:Dictionary<String,AnyObject>!
    var usersInGroups = [Dictionary<String,AnyObject>]()

    
    
    
    
    let http = HTTPHelper()
    
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestAlwaysAuthorization()
        manager.distanceFilter = 100
        return manager
        }()
    
    init() {
        user = ""
        email = ""
        idFB = ""
 
    }
    
    class var sharedInstance: DataManager {
        struct Static {
            static var instance: DataManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DataManager()
        }
        
        return Static.instance!
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {   //transforma coordenadas em endereço
        let geocoder = GMSGeocoder()
        var lines:[String]!
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                lines = address.lines as! [String]
                
                
                if lines != nil {
                    DataManager.sharedInstance.end = lines
                }
            }
        }
        
    }
    
    func createLocalNotification(title:String,body:String,timeAfterClose:NSTimeInterval,userInfo:NSDictionary) {
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = title
        localNotification.alertBody = body
        localNotification.fireDate = NSDate(timeIntervalSinceNow: timeAfterClose)
        //localNotification.userInfo = userInfo as [NSObject : AnyObject]
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func findDocumentsDirectory() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        return path
    }
    
    func readJsonFromBundle(nomeArquivo:String) -> NSDictionary {
        do {
            let path = NSBundle.mainBundle().pathForResource("\(nomeArquivo)", ofType: "json")
            let jsonData = NSData(contentsOfFile:path!)
            
            let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            return jsonResult
        }
        catch let error {
            print("\(error)")
            let dic = [ "nil":["nil"]] as NSDictionary
            return dic
        }
    }
    
    func readJsonFromDocuments(nomeArquivo:String) -> NSDictionary {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
            let jsonData = NSData(contentsOfFile:path)
            
            let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            return jsonResult
        }
        catch let error {
            print("\(error)")
            let dic = [ "nil":["nil"]] as NSDictionary
            return dic
        }
    }
    
    func testIfFileExistInDocuments (name:String) -> Bool{
        let docs = findDocumentsDirectory()
        let destinationPath = docs.stringByAppendingString("\(name)")
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(destinationPath) {
            return true
        }
        else {
            return false
        }
    }
    
    func moveJsonFromDocumentsToBundle(nomeArquivo:String) {
        do {
        let fileManager = NSFileManager.defaultManager()
            
        let documentsDirectory = findDocumentsDirectory()
        let destinationPath = documentsDirectory.stringByAppendingString("\(nomeArquivo).json")
        
        if fileManager.fileExistsAtPath(destinationPath) {
            return
        }
        let sourcePath = (NSBundle.mainBundle().resourcePath)?.stringByAppendingString("\(nomeArquivo).json")
            try fileManager.copyItemAtPath(sourcePath!, toPath: destinationPath) }
        catch let error {
            print("\(error)")
            
            return
        }
    }
    
    func actualTime() -> String{
        let currDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy  hh:mm"
        let dateString = dateFormatter.stringFromDate(currDate) as String
    
        return dateString
    
    
    }
   
    func requestFacebook(completion:(result:NSMutableArray)->Void) {
        let friendRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil)
        friendRequest.startWithCompletionHandler{ (connection: FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            if error == nil {
                self.friendsDictionaryFace = result as! Dictionary<String,AnyObject>
                DataManager.sharedInstance.friendsArray = (self.friendsDictionaryFace["data"]) as! NSMutableArray
                print("\(DataManager.sharedInstance.friendsArray)")
                completion(result: self.friendsArray)
                
            }
            else {
                print("\(error)")
            }
        }
        

    }
    
    

    
    func saveImage(image:UIImage?, id:String) -> String {
        if let _ = image {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let destinationPath = documentsPath.stringByAppendingString("/\(id).jpg")
            UIImageJPEGRepresentation(image!,1.0)!.writeToFile(destinationPath, atomically: true)
            
    
            return destinationPath }
        else {
            return ""
        }
    }
    
    func getProfPic(fid: String, serverId:String) -> UIImage? {
        let fileManager = NSFileManager.defaultManager()
        let documentsDirectory = findDocumentsDirectory()
        let destinationPath = documentsDirectory.stringByAppendingString("/\(serverId).jpg")
        var fbImage:UIImage!
        
        if !(fileManager.fileExistsAtPath(destinationPath)) {
            if (fid != "") {
                let imgURLString = "http://graph.facebook.com/" + fid + "/picture?type=large" //type=normal
                let imgURL = NSURL(string: imgURLString)
                let imageData = NSData(contentsOfURL: imgURL!)
                fbImage = UIImage(data: imageData!)
                
                return fbImage
            }
            
            return nil
        }
        return nil
    }
    
    func findImage(id:String) -> UIImage {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let destinationPath = documentsPath.stringByAppendingString("/\(id).jpg")

        let image = UIImage(contentsOfFile: destinationPath)
        return image!
        
    }
    
    func convertDicionaryToJson(dic:[Location],nomeArq:String) -> String {
        
        
        var array = Array<Dictionary<String,String>>()
        
        for var i = 0 ; i < (friendsArray.count-1) ; i++ {
            let time = DataManager.sharedInstance.locationUserArray[i].location.timestamp
            let coord = DataManager.sharedInstance.locationUserArray[i].location.coordinate
            let lat = coord.latitude
            let long = coord.longitude
            
            let address = DataManager.sharedInstance.locationUserArray[i].address
            
            
            let dicMod = ["tempo":"\(time)","lat":"\(lat)","long":"\(long)","address":"\(address)"]
            
            array.append(dicMod)
            
        
        }
        
        let documents = findDocumentsDirectory()
        let path = documents.stringByAppendingString("/\(nomeArq).json")
        
        let outputStream = NSOutputStream(toFileAtPath: path, append: true)
        outputStream?.open()
        NSJSONSerialization.writeJSONObject(array, toStream: outputStream!, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        outputStream?.close()
        
        
        return path
        
    }
    
    
    func createJsonFile(name:String,json:AnyObject) {
        let documents = DataManager.sharedInstance.findDocumentsDirectory()
        let path = documents.stringByAppendingString("/\(name).json")
        print(path)
        let outputStream = NSOutputStream(toFileAtPath: path, append: false)
        outputStream?.open()
        NSJSONSerialization.writeJSONObject(json, toStream: outputStream!, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        outputStream?.close()
    
    }
    
    func loadJsonFromDocuments(nomeArq:String) -> AnyObject {
        let documents = findDocumentsDirectory()
        let path = documents.stringByAppendingString("/\(nomeArq).json")
        print(path)
        do {
            let data = try NSData(contentsOfFile: path, options: .DataReadingUncached)
            
            do {
                let parse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) 
                return parse
                
                
            }
            catch let error {
                print(error)
                
            }
            
            
            
            
        }
        catch _ {
        }
        return []

    }
    
    func convertJsonToUser(json:AnyObject) -> [User] {
        var userArray = [User]()
        if let dic = json as? [NSDictionary] {
            for user in dic {
                let newUser = User()
            newUser.altitude = user["altitude"] as? String
            newUser.createdAt = user["created_at"] as? String
            newUser.email = user["email"] as? String
            newUser.facebookID = user["fbid"] as? String
            newUser.userID = user["id"] as? Int
            if let locationString = user["location"] as? String {
                if locationString.containsString(":") {
                    let locationArray = locationString.componentsSeparatedByString(":") as [String]
                    newUser.location.latitude = locationArray[0]
                    newUser.location.longitude = locationArray[1]
                }
            }
            
            
            newUser.name = user["name"] as? String
            newUser.password = user["password"] as? String
            newUser.photo = user["photo"] as? String
            newUser.updatedAt = user["updated_at"] as? String
            newUser.username = user["username"] as? String
            userArray.append(newUser)
            }

        }
        
        return userArray
    }
    
    func convertJsonToGroup(json:AnyObject) {
        if let dic = json as? [NSDictionary] {
            allGroup.removeAll()
            for group in dic {
                let newGroup = Group()
                newGroup.createdAt = group["created_at"] as? String
                let id = group["id"]
                newGroup.id = "\(id!)"
                newGroup.name = group["name"] as? String
                newGroup.photo = group["photo"] as? String
                newGroup.updateAt = group["updateAt"] as? String
                
                
                allGroup.append(newGroup)
            }
            
        }
        
    }
    
    func importID()
    {
        let file = "/id.txt"
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [String]
        
        if (dirs != nil)
        {
            let directories:[String] = dirs!
            let dirs = directories[0]; //documents directory
            let path = dirs.stringByAppendingString(file)
            
            var text:String!
            do{
                let text2 = try String(contentsOfFile: path, encoding:NSUTF8StringEncoding)
                if text2 == "nil" {
                    //saveID()
                }
                else {
                    text = text2
                    DataManager.sharedInstance.idUser = text!
                }
            }
            catch let error {
                if !(text == nil) {
                    saveID()}
                print(error)
            }
            
            
        }
    }
    
    func saveID ()
    {
        let file = "/id.txt"
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [String]
        
        if (dirs != nil)
        {
            let directories:[String] = dirs!
            let dirs = directories[0]; //documents directory
            let path = dirs.stringByAppendingString(file)
            let text = "\(DataManager.sharedInstance.idUser)"
            
            //writing
            do {
                try text.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding) }
            catch _ {}
        }
    }

    func updateLocationUsers(mapView:GMSMapView) {
        mapView.clear()
        for user in allUser {
            let name = user.name
            let lat = user.location.latitude
            let long = user.location.longitude
            let date = user.updatedAt
            
            
            
            
            let latitudeConvertida = (lat as NSString).doubleValue as CLLocationDegrees
            let longitudeConvertida = (long as NSString).doubleValue as CLLocationDegrees
            let position = CLLocationCoordinate2D(latitude: latitudeConvertida, longitude: longitudeConvertida)
            let marker = GMSMarker(position: position)
            marker.title = name
            marker.snippet = date
            marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
            marker.infoWindowAnchor = CGPointMake(0.5, 0.5)
            marker.map = mapView
            
        
        }
    }
    
    func requestGroups (completion:(result:NSDictionary)->Void) {
        http.getInfoFromID(DataManager.sharedInstance.idUser, desiredInfo: .userReceiverGroups) { (result) -> Void in
            let JSON = result
            self.usersInGroups.removeAll()
            DataManager.sharedInstance.createJsonFile("groups", json: JSON)
            DataManager.sharedInstance.convertJsonToGroup(JSON)
            for index in DataManager.sharedInstance.allGroup {
                let id = index.id
                self.requestUsersInGroupId(id)
            }
            print(JSON)
//            } else {
//                let dic = DataManager.sharedInstance.loadJsonFromDocuments("groups")
//                DataManager.sharedInstance.convertJsonToGroup(dic)
//            }

        }
        
        
//        
//        Alamofire.request(.GET, "https://tranquil-coast-5554.herokuapp.com/users/\(DataManager.sharedInstance.idUser)/get_user_receiver_groups").responseJSON { response in
//            if let JSON = response.result.value {
//                self.usersInGroups.removeAll()
//                DataManager.sharedInstance.createJsonFile("groups", json: JSON)
//                DataManager.sharedInstance.convertJsonToGroup(JSON)
//                for index in DataManager.sharedInstance.allGroup {
//                    let id = index.id
//                    self.requestUsersInGroupId(id)
//                }
//                print(self.usersInGroups)
//            } else {
//                let dic = DataManager.sharedInstance.loadJsonFromDocuments("groups")
//                DataManager.sharedInstance.convertJsonToGroup(dic)
//            }
//        }
    }
    
    func requestUsersInGroupId(groupId:String) {
        http.getInfoFromID(groupId, desiredInfo: .groupSenderUsers) { (result) -> Void in
            DataManager.sharedInstance.createJsonFile("users\(groupId)", json: result)
            let users = DataManager.sharedInstance.convertJsonToUser(result)
            print(users)
            var group = Dictionary<String,AnyObject>()
            group["groupId"] = groupId
            group["users"] = users
            self.usersInGroups.append(group)

        }
    }
    
    func createSimpleUIAlert (view:UIViewController,title:String,message:String,button1:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: button1, style: UIAlertActionStyle.Default, handler: nil))
        view.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func shakeTextField (textField:UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(textField.center.x - 10, textField.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(textField.center.x + 10, textField.center.y))
        textField.layer.addAnimation(animation, forKey: "position")
    }
    
    func funcaosemsentidoquenaofaznadamasocupaespaco() {
        let leoPassouPoraqui = "leoGeusPassouPoraqui"
        print(leoPassouPoraqui)
    }
}