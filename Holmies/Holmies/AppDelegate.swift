//
//  AppDelegate.swift
//  Holmies
//
//  Created by Leonardo Geus on 03/09/15.
//  Copyright (c) 2015 Leonardo Geus. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import Alamofire

import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let googleMapsApiKey = "AIzaSyAhjTqn1_2HX0FiQ0MW1_O7L1avjPIxP9g"
    let helper = HTTPHelper()

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch .
        GMSServices.provideAPIKey(googleMapsApiKey)
        //DataManager.sharedInstance.locationManager.delegate = self
        
        Parse.setApplicationId("52IjYIjvJ5BdIYDXr8SNqeVj5TZb15fnpaJkFDM2",
            clientKey: "ga7aF8AEO1vhF4x7KgTVcUsOk8uigdhXZZrCr5ez")
        
        application.registerUserNotificationSettings(UIUserNotificationSettings (forTypes: UIUserNotificationType.Alert, categories: nil))
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)

        print(DataManager.sharedInstance.findDocumentsDirectory())
        
        
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if application.respondsToSelector("registerUserNotificationSettings:") {
            //let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge,.Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            //let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
            application.registerForRemoteNotificationTypes([.Alert, .Badge,.Sound])
        }
        
        

        
        DataManager.sharedInstance.importID()
        let idUser = "\(DataManager.sharedInstance.myUser.userID)"
        let number = Int(idUser)

        
        if !(number > 0) {
            let storyboard = UIStoryboard(name: "Design", bundle: nil)
            //let dest = storyboard.instantiateViewControllerWithIdentifier("loginVC")
            let viewController = storyboard.instantiateViewControllerWithIdentifier("loginVC")
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        } else {
            let storyboard = UIStoryboard(name: "Design", bundle: nil)
            //let dest = storyboard.instantiateViewControllerWithIdentifier("loginVC")
            let viewController = storyboard.instantiateViewControllerWithIdentifier("inicial")
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            
            if (DataManager.sharedInstance.testIfFileExistInDocuments("/sharers.json")) {
                let dic = DataManager.sharedInstance.loadJsonFromDocuments("sharers")
                DataManager.sharedInstance.allSharers = DataManager.sharedInstance.convertJsonToSharer(dic)
            }
            if (DataManager.sharedInstance.testIfFileExistInDocuments("/groups.json")) {
                let dic = DataManager.sharedInstance.loadJsonFromDocuments("groups")
                DataManager.sharedInstance.allGroup = DataManager.sharedInstance.convertJsonToGroup(dic)
            }
            if (DataManager.sharedInstance.testIfFileExistInDocuments("/activeGroups.json")) {
                let dic = DataManager.sharedInstance.loadJsonFromDocuments("activeGroups")
                DataManager.sharedInstance.activeGroup = DataManager.sharedInstance.convertJsonToGroup(dic)
            }
            
            if (DataManager.sharedInstance.testIfFileExistInDocuments("/myInfo.json")) {
                DataManager.sharedInstance.loadMyInfo()
            }
            DataManager.sharedInstance.linkGroupAndUserToSharer({ (result) -> Void in
                print(result)
            })
//            DataManager.sharedInstance.requestGroups { (result) -> Void in
//                print(1)
//            }
        }
        


        
        
        
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    

    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        // fired when user quits the application
        
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 3
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 3
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.channels = ["global"]
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    
    
    
    
    //localizacao
    
    
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status ==  .AuthorizedWhenInUse || status == .AuthorizedAlways {    //se a autorizaçao do user estiver sendo pega pelo app
//            DataManager.sharedInstance.locationManager.startUpdatingLocation()   //inicia o locationmanager
//
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print(error)
//
//    }
//
//    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
//        if !(DataManager.sharedInstance.myUser.userID == nil) {
//
//        DataManager.sharedInstance.myUser.location.longitude = "\(newLocation.coordinate.longitude)"
//        DataManager.sharedInstance.myUser.location.latitude = "\(newLocation.coordinate.latitude)"
//        DataManager.sharedInstance.saveMyInfo()
//        if UIApplication.sharedApplication().applicationState == .Active {
//            print("Coord atualizada: \(newLocation.coordinate.longitude) \(newLocation.coordinate.latitude)")
//        }
//        else {
//            print("App em background. Coord: \(newLocation.coordinate.longitude) \(newLocation.coordinate.latitude)")
//            let userInfoCoordinate = ["local":newLocation]
//            DataManager.sharedInstance.createLocalNotification("oi", body: "\(newLocation.coordinate.latitude)", timeAfterClose: 10,userInfo:userInfoCoordinate)
//        }
//        
//        
//        let location = "\(newLocation.coordinate.latitude):\(newLocation.coordinate.longitude)"
//        
//        helper.updateUserWithID(DataManager.sharedInstance.myUser.userID, username: nil, location: location, altitude: nil, fbid: nil, photo: nil, name: nil, email: nil, password: nil) { (result) -> Void in
//            //oi
//        }
//        
//        
//        DataManager.sharedInstance.reverseGeocodeCoordinate(newLocation.coordinate) //transforma a coordenada em endereco
//        
//        if DataManager.sharedInstance.end != nil {
//            let actualLocation = Location()
//            actualLocation.location = newLocation
//            actualLocation.address = DataManager.sharedInstance.end
//            DataManager.sharedInstance.locationUserArray.append(actualLocation)
//        }
//        }
//    }
    


}

