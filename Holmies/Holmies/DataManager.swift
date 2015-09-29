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

class DataManager {
    var idUser:String!
    var user:String!
    var idFB:String!
    var mail:String!
    var friendsArray:NSMutableArray!
    var end:[String]!
    var profilePictureOfFriendsArray:Array<UIImage>!
    var locationUserArray = [Location]()
    var allUser = [User]()
    var friendsDictionary:Dictionary<String,AnyObject>!
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestAlwaysAuthorization()
        manager.distanceFilter = 100
        return manager
        }()
    
    init() {
        user = ""
        idFB = ""
        mail = ""
        
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
        localNotification.userInfo = userInfo as [NSObject : AnyObject]
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
                self.friendsDictionary = result as! Dictionary<String,AnyObject>
                DataManager.sharedInstance.friendsArray = (self.friendsDictionary["data"]) as! NSMutableArray
                print("\(DataManager.sharedInstance.friendsArray)")
                completion(result: self.friendsArray)
                
            }
            else {
                print("\(error)")
            }
        }
        

    }
    
    
    func getProfPic(fid: String) -> UIImage? {
        let fileManager = NSFileManager.defaultManager()
        let documentsDirectory = findDocumentsDirectory()
        let destinationPath = documentsDirectory.stringByAppendingString("/\(fid).jpg")
        var fbImage:UIImage!

        if !(fileManager.fileExistsAtPath(destinationPath)) {
            if (fid != "") {
                let imgURLString = "http://graph.facebook.com/" + fid + "/picture?type=large" //type=normal
                let imgURL = NSURL(string: imgURLString)
                let imageData = NSData(contentsOfURL: imgURL!)
                fbImage = UIImage(data: imageData!)
                print("entrou aqui2")
                return fbImage
            }
            print("entrou aqui3")
            return nil
        }
        return nil
    }
    
    func saveImage(image:UIImage?, id:String) -> String {
        if let _ = image {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let destinationPath = documentsPath.stringByAppendingString("/\(id).jpg")
            UIImageJPEGRepresentation(image!,1.0)!.writeToFile(destinationPath, atomically: true)
            
    
            print(destinationPath)
            return destinationPath }
        else {
            return ""
        }
    }
    
    func findImage(id:String) -> UIImage {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let destinationPath = documentsPath.stringByAppendingString("/\(id).jpg")
        print(destinationPath)
        let image = UIImage(contentsOfFile: destinationPath)
        return image!
        
    }
    
    func convertDicionaryToJson(dic:[Location],nomeArq:String) -> String {
        print(locationUserArray)
        
        
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
        
        let outputStream = NSOutputStream(toFileAtPath: path, append: false)
        outputStream?.open()
        NSJSONSerialization.writeJSONObject(json, toStream: outputStream!, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        outputStream?.close()
    
    }
    
    func loadJsonFromDocuments(nomeArq:String) {
        let documents = findDocumentsDirectory()
        let path = documents.stringByAppendingString("/\(nomeArq).json")
        print(path)
        do {
            let data = try NSData(contentsOfFile: path, options: .DataReadingUncached)
            
            do {
                let parse = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) 
                print(parse)
            }
            catch let error {
                print(error)
                
            }
            
            
            
            
        }
        catch _ {
        }

    }
    
    func convertJsonToUser(json:AnyObject) {
        let dic = json as! [NSDictionary]
        allUser.removeAll()
        for user in dic {
            let newUser = User()
            newUser.altitude = user["altitude"] as? String
            newUser.createdAt = user["created_at"] as? String
            newUser.email = user["email"] as? String
            newUser.facebookID = user["fbid"] as? String
            newUser.userID = user["id"] as? Int
            newUser.location = user["location"] as? String
            newUser.name = user["name"] as? String
            newUser.password = user["password"] as? String
            newUser.photo = user["photo"] as? String
            newUser.updatedAt = user["updated_at"] as? String
            newUser.username = user["username"] as? String
            allUser.append(newUser)
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
                    saveID()
                }
                text = text2
                DataManager.sharedInstance.idUser = text!
            }
            catch let error {
                saveID()
                print(error)
            }
            
            
        }
    }
    //
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

    
    

    

}