//
//  HTTPHelper.swift
//  Holmies Login
//
//  Created by Ramon Martinez on 14/10/15.
//  Copyright © 2015 BEPiD PUCPR. All rights reserved.
//

import UIKit
import Alamofire

class HTTPHelper: NSObject {
    
    let API_AUTH_NAME = "holmiesMaster"
    let API_AUTH_PASSWORD = "kD4g0gUy3PDhXS1WJIt24GDgyh66Npz75HV8lF123L8d58EN667YFQ56PqdATpPb"
    let API_DECRYPT_PW = "LB8ZZB9FLAZ9zMj8fNmL0y1164VlrTKv29B6dZ6vQAADKacTR8EeR4u6Um4DXqx0"
    
    let baseURL = "https://tranquil-coast-5554.herokuapp.com/api" //URL do servidor no HEROKU
//    let baseURL = "http://localhost:3000/api" //URL do servidor de Teste
    
    internal enum DesiredInfo {
        case userReceiverUsers
        case userSenderUsers
        case userReceiverGroups
        case userSenderGroups
        case groupReceiverUsers
        case groupSenderUsers
        case userSenderSharers
        case userReceiverSharers
        case groupReceiverSharers
    }
    
    internal enum SharerType {
        case userToUser, userToGroup
    }
    
    func signInWithUsername(username:String, password:String,completion:(result:Dictionary<String,AnyObject>)->Void) {
        
        let encryptedPassword = AESCrypt.encrypt(password, password: API_DECRYPT_PW)
        
        let parameters = [
            "username": username,
            "password": encryptedPassword
        ]
        
        let url = "\(baseURL)/signin"
        
        makeHttpPostRequestWithParameters(parameters, url: url) { (httpResult) -> Void in
            let formattedResult = httpResult as! Dictionary<String,AnyObject>
            completion(result: formattedResult)
        }
        
    }
    
    func signInWithFacebookID(fbid:String ,completion:(result:Dictionary<String,AnyObject>)->Void) {
        
        let parameters = [
            "fbid": fbid
        ]
        
        let url = "\(baseURL)/signin_fb"
        
        makeHttpPostRequestWithParameters(parameters, url: url) { (httpResult) -> Void in
            let formattedResult = httpResult as! Dictionary<String,AnyObject>
            completion(result: formattedResult)
        }
        
    }
    
    func signUpWithName(name:String,username:String,email:String,password:String,completion:(result:Dictionary<String,AnyObject>)->Void) {
        let encryptedPassword = AESCrypt.encrypt(password, password: API_DECRYPT_PW)
        let parameters = [
            "username": username,
            "name": name,
            "email": email,
            "password": encryptedPassword
        ]
        
        let url = "\(baseURL)/signup"
        
        makeHttpPostRequestWithParameters(parameters, url: url) { (httpResult) -> Void in
            let formattedResult = httpResult as! Dictionary<String,AnyObject>
            completion(result: formattedResult)
        }
        
    }
    
    func uploadUserPhotoWithID(id:String, photo:UIImage, completion:(result:Dictionary<String,AnyObject>)->Void) {
        let image = resizeImage(photo, newWidth: 512)
        let imageData = UIImagePNGRepresentation(image)!
        let base64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        let parameters = [
            "id":id,
            "image":base64String
        ]
        
        let url = "\(baseURL)/user_photo_upload"
        
        makeHttpPostRequestWithParameters(parameters, url: url) { (httpResult) -> Void in
            let formattedResult = httpResult as! Dictionary<String,AnyObject>
            completion(result: formattedResult)
        }
        
    }
    
    func downloadPhotoFromUserWithID(id:String, completion:(resultImage:UIImage)->Void) {
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        
        print(destination)
        
        let parameters = [
            "id":id
        ]
        
        let url = "\(baseURL)/user_photo_download"
        
        Alamofire.request(.GET, url, parameters: parameters).authenticate(user: API_AUTH_NAME, password: API_AUTH_PASSWORD).responseData { response in
            
            print(response.result.value)
            let data = response.result.value!
            let image = UIImage(data: data)
            completion(resultImage: image!)
            
        }
        
    }
    
    func findFriendWithUsername(username:String, completion:(result:Dictionary<String,AnyObject>)->Void) {
        let parameters = [
            "username":username
        ]
        
        let url = "\(baseURL)/find_friend"
        
        makeHttpPostRequestWithParameters(parameters, url: url) { (httpResult) -> Void in
            let formattedResult = httpResult as! Dictionary<String,AnyObject>
            completion(result: formattedResult)
        }
    }
    
    func updateUserWithID(userID:String, username:String?, location: String?, altitude: String?,
        fbid: String?, photo: String?, name: String?, email: String?, password: String?, completion:(result:Dictionary<String,AnyObject>)->Void) {
            
            var parameters = Dictionary<String,AnyObject>()
            
            parameters["id"] = userID
            
            var encryptedPw = String?()
            if let pw = password {
                encryptedPw = AESCrypt.encrypt(pw, password: API_DECRYPT_PW)
                parameters["password"] = encryptedPw
            }
            
            if let user = username {
                parameters["username"] = user
            }
            
            if let local = location {
                parameters["location"] = local
            }
            
            if let alt = altitude {
                parameters["altitude"] = alt
            }
            
            if let fb = fbid {
                parameters["fbid"] = fb
            }
            
            if let pic = photo {
                parameters["photo"] = pic
            }
            
            if let realName = name {
                parameters["name"] = realName
            }
            
            if let userEmail = email {
                parameters["email"] = userEmail
            }
            
            let url = "\(baseURL)/update_user_info"
            
            makeHttpPostRequestWithParameters(parameters, url: url) { (httpResult) -> Void in
                let formattedResult = httpResult as! Dictionary<String,AnyObject>
                completion(result: formattedResult)
            }
            
            
    }
    
    func getInfoFromID(ID:String, desiredInfo:DesiredInfo, completion:(result:[Dictionary<String,AnyObject>])->Void) {
        let parameters = [
            "id": ID
        ]
        var url = String()
        
        switch desiredInfo {
        case .groupReceiverUsers:
            url = "\(baseURL)/get_group_receiver_users"
        case .groupSenderUsers:
            url = "\(baseURL)/get_group_sender_users"
        case.userReceiverGroups:
            url = "\(baseURL)/get_user_receiver_groups"
        case .userReceiverUsers:
            url = "\(baseURL)/get_user_receiver_users"
        case .userSenderGroups:
            url = "\(baseURL)/get_user_sender_groups"
        case .userSenderUsers:
            url = "\(baseURL)/get_user_sender_users"
        case .userSenderSharers:
            url = "\(baseURL)/get_user_sender_sharers"
        case .userReceiverSharers:
            url = "\(baseURL)/get_user_receiver_sharers"
        case .groupReceiverSharers:
            url = "\(baseURL)/get_group_receiver_sharers"
        }
        
        makeHttpPostRequestWithParameters(parameters, url: url) { (httpResult) -> Void in
            let formattedResult = httpResult as! [Dictionary<String,AnyObject>]
            completion(result: formattedResult)
        }
    }
    
    func createNewSharerWithType(sharerType:SharerType, ownerID:String, receiverID:String, until:String, completion:(result:Dictionary<String,AnyObject>)->Void) {
        
        var parameters = [
            "owner_user":ownerID,
            "until":until
        ]
        
        switch sharerType {
        case .userToGroup:
            parameters["receiver_group"] = receiverID
            break
        case .userToUser:
            parameters["receiver_user"] = receiverID
            break
        }
        
        let url = "\(baseURL)/new_sharer"
        
        makeHttpPostRequestWithParameters(parameters, url: url) { (httpResult) -> Void in
            let formattedResult = httpResult as! Dictionary<String, AnyObject>
            completion(result: formattedResult)
        }
        
    }
    
    func createNewGroupWithName(name:String, completion:(result:Dictionary<String,AnyObject>)->Void) {
        let parameters = [
            "name":name
        ]
        
        let url = "\(baseURL)/new_group"
        
        makeHttpPostRequestWithParameters(parameters, url: url) { (httpResult) -> Void in
            let formattedResult = httpResult as! Dictionary<String, AnyObject>
            completion(result: formattedResult)
        }
    }
    
    func updateSharerWithID(id:String, until:String, completion:(result:Dictionary<String,AnyObject>)->Void) {
        let parameters = [
            "id":id,
            "until":until
        ]
        
        let url = "\(baseURL)/update_sharer"
        
        makeHttpPostRequestWithParameters(parameters, url: url) { (httpResult) -> Void in
            let formattedResult = httpResult as! Dictionary<String, AnyObject>
            completion(result: formattedResult)
        }
        
    }
    
    func destroySharerWithSharerType(sharerType:SharerType, ownerID:String, receiverID:String, completion:(result:Dictionary<String,AnyObject>)->Void) {
        var parameters = [
            "owner_user_id":ownerID
        ]
        switch sharerType {
        case .userToGroup:
            parameters["receiver_group_id"] = receiverID
            break
        case .userToUser:
            parameters["receiver_user_id"] = receiverID
            break
        }
        
        let url = "\(baseURL)/destroy_sharer"
        
        makeHttpPostRequestWithParameters(parameters, url: url) { (httpResult) -> Void in
            let formattedResult = httpResult as! Dictionary<String, AnyObject>
            completion(result: formattedResult)
        }
    }
    
    func updateGroupWithID(id:String, name:String?, photo:String?, completion:(result:Dictionary<String,AnyObject>)->Void) {
        var parameters = [
            "id":id
        ]
        
        if let groupName = name {
            parameters["name"] = groupName
        }
        
        if let groupPhoto = photo {
            parameters["photo"] = groupPhoto
        }
        
        let url = "\(baseURL)/update_group"
        
        makeHttpPostRequestWithParameters(parameters, url: url) { (httpResult) -> Void in
            let formattedResult = httpResult as! Dictionary<String, AnyObject>
            completion(result: formattedResult)
        }
        
    }
    
    func destroyGroupWithID(id:String, completion:(result:Dictionary<String,AnyObject>)->Void) {
        let parameters = [
            "id":id
        ]
        
        let url = "\(baseURL)/destroy_group"
        
        makeHttpPostRequestWithParameters(parameters, url: url) { (httpResult) -> Void in
            let formattedResult = httpResult as! Dictionary<String, AnyObject>
            completion(result: formattedResult)
        }
        
    }
    
    
    func makeHttpPostRequestWithParameters(parameters: Dictionary<String,AnyObject>, url: String, completion:(httpResult:AnyObject?)->Void) {
        Alamofire.request(.POST, url, parameters: parameters).authenticate(user: API_AUTH_NAME, password: API_AUTH_PASSWORD).responseJSON { response in
//            print(response)
            completion(httpResult: response.result.value)
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
