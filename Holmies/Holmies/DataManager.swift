//
//  DataManager.swift
//  Holmies
//
//  Created by Leonardo Geus on 14/09/15.
//  Copyright (c) 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class DataManager {
    var user:String!
    var idFB:String!
    var mail:String!
    var friendsArray:NSArray!
    var end:[String]!
    var locationUserArray = [Location]()
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
    

}