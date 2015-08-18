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
        self.longitude = ""
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

    
}
