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
    var friendsArray:NSMutableArray!
    var end:[String]!
    var profilePictureOfFriendsArray:Array<UIImage>!
    var locationUserArray = [Location]()
    var allUser = [User]()
    var allGroup = [Group]()
    var activeGroup = [Group]()
    var friendsDictionaryFace:Dictionary<String,AnyObject>!
    var usersInGroups = [Dictionary<String,AnyObject>]()
    var activeUsers = [User]()
    var allFriends = [User]()
    var selectedFriends = [User]()
    var allSharers = [Sharer]()
    var myUser = User()
    let http = HTTPHelper()
    var actualCell = 0
    var selectedGroup = Group()
    
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestAlwaysAuthorization()
        manager.distanceFilter = 0.5
        return manager
    }()
    

    
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
                let imgURLString:String!
                if (fid == myUser.facebookID) {
                    imgURLString = "http://graph.facebook.com/" + fid + "/picture?height=960" //type=normal

                }else{
                    imgURLString = "http://graph.facebook.com/" + fid + "/picture?type=large" //type=normal
                }
                    
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
        if testIfFileExistInDocuments("/\(id).jpg") == true {
            let image = UIImage(contentsOfFile: destinationPath)
            return image!
        }
        else {
            return UIImage(named: "ovalVermelho.png")!
        }

        
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

        print("inicio\(name)")
        let documents = DataManager.sharedInstance.findDocumentsDirectory()
        let path = documents.stringByAppendingString("/\(name).json")
        
        if name == "myInfo" {
            let pathAppend = documents.stringByAppendingString("/\(name)log.json")
            print("Arquivo com suas informacoes criado ou atualizado - pode ser atualizacao de coordenadas")
            let outputStream = NSOutputStream(toFileAtPath: pathAppend, append: true)
            outputStream?.open()
            NSJSONSerialization.writeJSONObject(json, toStream: outputStream!, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
            outputStream?.close()
        
        } else {
            print("Arquivo com nome: \(name) criado")
        }
        
        let outputStream = NSOutputStream(toFileAtPath: path, append: false)
        outputStream?.open()
        NSJSONSerialization.writeJSONObject(json, toStream: outputStream!, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        outputStream?.close()
        print("fim\(name)")
    }
    
    func loadJsonFromDocuments(nomeArq:String) -> AnyObject {
        let documents = findDocumentsDirectory()
        let path = documents.stringByAppendingString("/\(nomeArq).json")
        print("Arquivo \(nomeArq) carregado do Docs")
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
            let id = user["id"]
            newUser.userID = "\(id!)"
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
    

    
    func convertJsonToGroup(json:AnyObject) -> [Group] {
        var groupDic = [Group]()
        if let dic = json as? [NSDictionary] {
            for group in dic {
                let newGroup = Group()
                newGroup.createdAt = group["created_at"] as? String
                let id = group["id"]
                newGroup.id = "\(id!)"
                newGroup.name = group["name"] as? String
                newGroup.photo = group["photo"] as? String
                newGroup.updateAt = group["updateAt"] as? String
                
                
                groupDic.append(newGroup)
            }
            
        }
        return groupDic
        
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
                    DataManager.sharedInstance.myUser.userID = text!
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
            let text = DataManager.sharedInstance.myUser.userID
            
            //writing
            do {
                try text.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding) }
            catch _ {}
        }
    }

    func updateLocationUsers(mapView:GMSMapView) {
        mapView.clear()
        for user in activeUsers {
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
            marker.userData = user
            
            
            let topImage = findImage(user.userID)
            //let bottomImageView = UIImageView()
            let bottomImage = UIImage(named: "pin2.png")
            

            let newSize = CGSizeMake((topImage.size.width), (topImage.size.height))
            UIGraphicsBeginImageContext(newSize)
            bottomImage!.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
            topImage.drawInRect(CGRectMake((bottomImage?.size.width)!/2, (bottomImage?.size.width)!/2, 100, 100), blendMode: CGBlendMode.Normal, alpha: 1.0)
            let newimage = UIGraphicsGetImageFromCurrentImageContext()
            
            
//            bottomImageView.image = bottomImage
//            bottomImageView.layer.cornerRadius = 100
            
//            
//            let size = CGSize(width: 300, height: 300)
//            UIGraphicsBeginImageContext(size)
//            
//            let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//            
//            
//            bottomImageView.image!.drawInRect(areaSize)
//            
//            
//            topImage!.drawInRect(areaSize, blendMode: CGBlendMode.Normal, alpha: 1)
//            let newPin:UIImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
            
            
            marker.icon = newimage
        
            
            
        
        }
    }
    
    
    
    func requestGroups (completion:(result:[NSDictionary])->Void) {
        http.getInfoFromID(DataManager.sharedInstance.myUser.userID, desiredInfo: .userReceiverGroups) { (result) -> Void in
            let JSON = result
            self.usersInGroups.removeAll()
            DataManager.sharedInstance.createJsonFile("groups", json: JSON)
            DataManager.sharedInstance.convertJsonToGroup(JSON)
            for group in DataManager.sharedInstance.allGroup {
                let id = group.id
                self.requestUsersInGroupId(id, completion: { (users) -> Void in
                    group.users = users
                })
            }
            completion(result: JSON)
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
    
    func requestUsersInGroupId(groupId:String,completion:(users:[User]) -> Void) {
        http.getInfoFromID(groupId, desiredInfo: .groupSenderUsers) { (result) -> Void in
            
            
            
            
            
            
            
            
            
            
            //DataManager.sharedInstance.createJsonFile("users\(groupId)", json: result)
            var users = DataManager.sharedInstance.convertJsonToUser(result)
            let usersDic = DataManager.sharedInstance.convertUserToNSDic(users)
            
            DataManager.sharedInstance.createJsonFile("users\(groupId)", json: usersDic)
            var num = 0
            for group in DataManager.sharedInstance.allGroup {
                if group.id == groupId {
                    
                    
                    
                    //retira eu da lista de users dos grupos
                    var i = 0
                    for user in users {
                        if user.userID == DataManager.sharedInstance.myUser.userID {
                            users.removeAtIndex(i)
                            break
                        }
                        i++
                    }
               
                    
                    DataManager.sharedInstance.allGroup[num].users = users
                    if DataManager.sharedInstance.allGroup[num].users.count < 1 {
                        self.destroyGroupWithGroup(DataManager.sharedInstance.allGroup[num])
                    }
                }
                num++
            }
            
            

//            self.testIfGroupIsEmpty({ (result) -> Void in
//                //completion do grupo apagado
            var userForTest = [User()]
            let user1 = User()
            
            user1.name = "Test"
            userForTest.append(user1)
            completion(users: userForTest)
//            })
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
    

    func removeUserFromGroupInBackEnd(groupId:String,completion:(result:String) -> Void) {
        print("fazer aqui o delete do user em servidor")
        requestGroups { (result) -> Void in
            print("fez request do grupos após remover user")
            completion(result: "terminou")
        }
    }
    
    func convertGroupToNSDic (groupClass:[Group]) -> [Dictionary<String,AnyObject>] {
        var groupDic = [Dictionary<String,AnyObject>]()
        for oneGroup in groupClass {
            var circle = Dictionary<String,AnyObject>()
            circle["id"] = oneGroup.id
            circle["name"] = oneGroup.name
            circle["updated_at"] = oneGroup.updateAt
            circle["created_at"] = oneGroup.createdAt
            circle["photo"] = oneGroup.photo
            groupDic.append(circle)
        }
        return groupDic
    }
    
    func convertUserToNSDic (userClass:[User]) -> [Dictionary<String,AnyObject>] {
        var userDic = [Dictionary<String,AnyObject>]()
        for user in userClass {
            var people = Dictionary<String,AnyObject>()
            people["altitude"] = user.altitude
            people["createdAt"] = user.createdAt
            people["email"] = user.email
            people["fbid"] = user.facebookID
            people["id"] = user.userID
            
            people["name"] = user.name
            people["photo"] = user.photo
            people["updatedAt"] = user.updatedAt
            people["username"] = user.username
            userDic.append(people)
        }
        return userDic
    }
    
    func testIfGroupIsEmpty(completion:(result:String)->Void) {
        for group in DataManager.sharedInstance.allGroup {
//            let groupq = group
//            let usersInGroups = (group["users"] as! NSArray).count
        
            let users = group.users
            let id = group.id
            
            if users.count < 1 {
                destroyGroupWithGroup(group)
                completion(result: "\(id)")
            }
        }
    }
    
    func destroyGroupWithNotification(groupObject:Group,view:UIViewController) {
        let idGroup = groupObject.id
        createSimpleUIAlert(view, title: "Deletado", message: "O grupo \(groupObject.name) será deletado pois todos os usuarios sairam", button1: "Ok")
        http.destroyGroupWithID(idGroup) { (result) -> Void in
            print("apagado grupo \(idGroup)")
        }
    }
    
    func destroyGroupWithGroup(groupObject:Group) {
        let idGroup = groupObject.id
        
        http.destroyGroupWithID(idGroup) { (result) -> Void in
            print("apagado grupo \(idGroup)")
        }
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    func requestSharers(completion:(result:String)->Void){
        let id = DataManager.sharedInstance.myUser.userID
        http.getInfoFromID(id, desiredInfo: .userSenderSharers) { (result) -> Void in
            let json = result
            DataManager.sharedInstance.createJsonFile("sharers", json: json)
            
            DataManager.sharedInstance.allSharers = self.convertJsonToSharer(json)
            completion(result: "DEU")
        }
    }
    
    func convertJsonToSharer(json:AnyObject) -> [Sharer] {
        var sharers = [Sharer]()
        if let dic = json as? [NSDictionary] {
            for sharer in dic {
                let newSharer = Sharer()
                newSharer.createdAt = sharer["created_at"] as? String
                let id = sharer["id"] as! Int
                
                newSharer.id = "\(id)"
                newSharer.until = sharer["until"] as? String
                if sharer["relation"] as? String == "u2u" {
                    newSharer.relation = .userToUser
                }
                else if sharer["relation"] as? String == "u2g" {
                    newSharer.relation = .userToGroup
                }
                
                newSharer.updatedAt = sharer["updated_at"] as? String
                
                // newSharer.owner = //
                let receiverId = sharer["receiver_group_id"]
                let receiverIdFormat = "\(receiverId!)"
                newSharer.receiver = receiverIdFormat
                sharers.append(newSharer)
            }
            
        }
        return sharers
    }
    
//    func findUntilBETA () {
//        for sharer in DataManager.sharedInstance.allSharers {
//            for group in DataManager.sharedInstance.allGroup {
//                if sharer.receiver == group.id {
//                    group.until = sharer.until
//                    group.createdAt = sharer.createdAt
//                }
//            }
//        }
//    }
    
    
//    func linkSharerToGroup () {
//        for sharer in DataManager.sharedInstance.allSharers {
//            if sharer.relation == SharerType.userToGroup {
//                for group in DataManager.sharedInstance.allGroup {
//                    if sharer.receiver == group.id {
//                        group.share = sharer
//                        group.createdAt = sharer.createdAt
//                    }
//                }
//            }
//        }
//    }
    
    func linkGroupAndUserToSharer (completion:(result:String)->Void) {
        for sharer in DataManager.sharedInstance.allSharers {
            if sharer.relation == SharerType.userToGroup {
                for group in DataManager.sharedInstance.allGroup {
                        if sharer.receiver == group.id {
                            sharer.receiverObject = group
                            group.share = sharer
                            
                            let fileManager = NSFileManager.defaultManager()
                            
                            let documentsDirectory = findDocumentsDirectory()
                            let destinationPath = documentsDirectory.stringByAppendingString("/users\(group.id).json")
                            
                            if fileManager.fileExistsAtPath(destinationPath) {
                                
                                let userInGroup = loadJsonFromDocuments("users\(group.id)")
                                var userInGroupUSER = convertJsonToUser(userInGroup)
                                var i = 0
                                for user in userInGroupUSER {
                                    if user.userID == DataManager.sharedInstance.myUser.userID {
                                        userInGroupUSER.removeAtIndex(i)
                                        break
                                    }
                                    i++
                                }
                                group.users = userInGroupUSER
                                
                                
                            }
                            
                            
                            
                            
                        }
                }
            }
            else if sharer.relation == SharerType.userToUser {
                //ainda nao tem
            }
            
        }
        completion(result: "Linkou tudo")
    }
    

    
    func saveMyInfo () {
        let myInfo = DataManager.sharedInstance.myUser
        var people = Dictionary<String,AnyObject>()
        people["altitude"] = myInfo.altitude
        people["createdAt"] = myInfo.createdAt
        people["email"] = myInfo.email
        people["fbid"] = myInfo.facebookID
        people["userID"] = myInfo.userID
        people["name"] = myInfo.name
        people["photo"] = myInfo.photo
        people["updatedAt"] = myInfo.updatedAt
        people["username"] = myInfo.username
        people["latitude"] = myInfo.location.latitude
        people["longitude"] = myInfo.location.longitude
        createJsonFile("myInfo", json: people)
    }
    
    func loadMyInfo () {
        let json = loadJsonFromDocuments("myInfo")
        if let dic = json as? NSDictionary {
            let myInfo = User()
            myInfo.altitude = dic["altitude"] as? String
            myInfo.createdAt = dic["createdAt"] as? String
            myInfo.email = dic["email"] as? String
            myInfo.facebookID = dic["fbid"] as? String
            myInfo.userID = dic["userID"] as? String
            myInfo.name = dic["name"] as? String
            myInfo.photo = dic["photo"] as? String
            myInfo.updatedAt = dic["updatedAt"] as? String
            myInfo.username = dic["username"] as? String
            let lat = dic["latitude"] as? String
            let long = dic["longitude"] as? String
            myInfo.location.latitude = "\(lat)"
            myInfo.location.longitude = "\(long)"
            DataManager.sharedInstance.myUser = myInfo
        }
    }
    
    //    func updateFriends () {
    //        Alamofire.request(.GET, "https://tranquil-coast-5554.herokuapp.com/users/lista").responseJSON { response in
    //            if let JSON = response.result.value {
    //                DataManager.sharedInstance.createJsonFile("users", json: JSON)
    //                DataManager.sharedInstance.allUser = DataManager.sharedInstance.convertJsonToUser(JSON)
    //                for index in DataManager.sharedInstance.allUser {
    //                    let faceId = index.facebookID
    //                    let id = "\(index.userID!)"
    //                    if !(faceId == nil) {
    //                        let image = DataManager.sharedInstance.getProfPic(faceId, serverId: id)
    //                        DataManager.sharedInstance.saveImage(image, id: id)
    //                    }
    //                }
    //                DataManager.sharedInstance.updateLocationUsers(self.mapView)
    //                self.controlNet.alpha = 0
    //                self.controlNet.enabled = false
    //            } else {
    //                let dic = DataManager.sharedInstance.loadJsonFromDocuments("users")
    //                DataManager.sharedInstance.allUser = DataManager.sharedInstance.convertJsonToUser(dic)
    //                DataManager.sharedInstance.updateLocationUsers(self.mapView)
    //                self.controlNet.alpha = 1
    //                self.controlNet.enabled = true
    //
    //            }
    //        }
    //        //DataManager.sharedInstance.requestGroups()
    //    }
    

    

}