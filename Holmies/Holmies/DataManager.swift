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
    var user:String!
    var idFB:String!
    var mail:String!
    var friendsArray:NSMutableArray!
    var end:[String]!
    var profilePictureOfFriendsArray:Array<UIImage>!
    var locationUserArray = [Location]()
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
    
    func loadJsonFromDocuments(nomeArq:String) {
        let documents = findDocumentsDirectory()
        let path = documents.stringByAppendingString("/\(nomeArq).json")
        let data = NSData(contentsOfFile: path)
        let dic = NSKeyedUnarchiver.unarchiveObjectWithData(data!)
        print(dic)
        
        
    }
    
    

    

}