//
//  DataManager.swift
//  MainChallengeMaps
//
//  Created by Leonardo Koppe Malanski on 17/08/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    var nome: NSString!
    var latitude: NSString!
    var longitude: NSString!
    
    override init() {
        self.nome = ""
        self.latitude = ""
        self.longitude = ""  //54.68.89.24:80/
    }
   
    class var sharedInstance:DataManager {
        struct Static {
            static var instance: DataManager?
            static var token: dispatch_once_t = 0
            
        }
        dispatch_once(&Static.token) {
            Static.instance = DataManager()
        
        }
        
        return Static.instance!
    }
    
    func imagemTamanho(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        [image .drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))]
        var newImage:UIImage
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return newImage
    }
    
    func importData ()
    {
        let file = "user.txt"
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        if (dirs != nil)
        {
            let directories:[String] = dirs!
            let dirs = directories[0]; //documents directory
            let path = dirs.stringByAppendingPathComponent(file);
            println("Nome  = \(DataManager.sharedInstance.nome)")
            //reading
            var error:NSError?
            let text2 = String(contentsOfFile: path, encoding:NSUTF8StringEncoding, error: &error)
            if text2 == "" {
                saveData()
            }
            if let theError = error {
                saveData()
            }
            else if error == nil{
                DataManager.sharedInstance.nome = text2!}
            
        }
    }
    //
    func saveData ()
    {
        let file = "user.txt"
        
        let dirs: [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        
        if (dirs != nil)
        {
            let directories:[String] = dirs!
            let dirs = directories[0]; //documents directory
            let path = dirs.stringByAppendingPathComponent(file);
            let text = "\(DataManager.sharedInstance.nome)"
            
            //writing
            text.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: nil);
        }
    }

    
}
