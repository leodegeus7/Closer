//
//  MapGoogleViewController.swift
//  Holmies
//
//  Created by Leonardo Geus on 07/09/15.      <------------------------------------------------------------
//  Copyright (c) 2015 Leonardo Geus. All rights reserved.                                                  I
//                                                                                                          I
//                                                                                                          I
//  O google maps consegue se redimensionar se algum elemento da UI for adicionado. Pegar códigos comigooo  I

import UIKit
import MapKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import QuartzCore

class MapGoogleViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var controlNet: UILabel!
    @IBOutlet weak var mapView: GMSMapView!    //outlet do mapa como um mapa do google
    @IBOutlet weak var mapCenterPinImage: UIImageView!
    @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var compassView: UIView!
    var gradient:UIImage!
    var actualPhoneAngularPosition = Double()
    var selectedFriend = User?()
    
    let mainRed: UIColor = UIColor(red: 220.0/255.0, green: 32.0/255.0, blue: 63.0/255.0, alpha: 1)


    var isCharm = DataManager.sharedInstance.isCharm
    
    
    //background whetever
    var updateTimer: NSTimer?
    var updateFriendsTimer: NSTimer?
    //var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var numero = 0
    var friendsDictionary:Dictionary<String,AnyObject>!
    var enterInView = true
    
    //var locationFirst:CLLocation!
    let dataProvider = GoogleDataProvider()
    let helper = HTTPHelper()
    //var actualLocation:CLLocation!
    @IBOutlet weak var arrowCompass: UIImageView!
    @IBOutlet weak var friendPhoto: UIImageView!
    @IBOutlet weak var friendDistance: UILabel!
    
    var timer = NSTimer()
    @IBOutlet weak var compassViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var compassViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var compassViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var compassViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var arrowCompassRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowCompassLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowCompassTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowCompassBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var northLine: UIImageView!
    
    
    var mapRadius: Double {
        get {
            let region = mapView.projection.visibleRegion()
            let verticalDistance = GMSGeometryDistance(region.farLeft, region.nearLeft)
            let horizontalDistance = GMSGeometryDistance(region.farLeft, region.farRight)
            return max(horizontalDistance, verticalDistance)*0.5
        }
    }
    var randomLineColor: UIColor {
        get {
            let randomRed = CGFloat(drand48())
            let randomGreen = CGFloat(drand48())
            let randomBlue = CGFloat(drand48())
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "charmFound:", name: "charmFound", object: nil)
        
        DataManager.sharedInstance.activeView = "map"
        DataManager.sharedInstance.updateLocationUsers(mapView)
        
        mapView.delegate = self   //delegate das funçoes do google maps
        mapView.mapType = kGMSTypeNormal
        self.setUpBackgrounGradient()
        
        NSNotificationCenter.defaultCenter().postNotificationName("delegateUpdate", object: nil)

        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "NexaRustScriptL-0", size: 30)!]
        DataManager.sharedInstance.activeMap = self.mapView
//        var swipeDown = UISwipeGestureRecognizer(target: self, action: "draggedViewDown:")
//        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
//        compassView.addGestureRecognizer(swipeDown)
//        
//        var swipeUp = UISwipeGestureRecognizer(target: self, action: "draggedViewUp:")
//        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
//        arrowCompass.addGestureRecognizer(swipeUp)
        
        
        

        
        self.compassView.hidden = true
        mapView.settings.compassButton = true

        DataManager.sharedInstance.locationManager.startUpdatingHeading()
        
        friendDistance.font = UIFont(name:"SFUIText-Regular", size: 15)
        
//        swipeRec.addTarget(self, action: "draggedView:")
//        compassView.addGestureRecognizer(swipeRec)
//        compassView.userInteractionEnabled = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        
        if !isCharm {
            var existUserInGroup = false
            let titleGroup = DataManager.sharedInstance.selectedGroup.name
            self.navigationItem.title = titleGroup
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "NexaRustScriptL-0", size: 30)!]
            for sharer in DataManager.sharedInstance.selectedSharer {
                if sharer.status == "accepted" && sharer.owner != DataManager.sharedInstance.myUser.userID {
                    existUserInGroup = true
                    break
                }
            }
            
            if !existUserInGroup {
                //DataManager.sharedInstance.createSimpleUIAlert(self, title: "Atenção", message: "Nenhum membro neste grupo aceitou o grupo", button1: "Ok")
                
                
                let groupName = DataManager.sharedInstance.selectedGroup.name
                let alert = UIAlertController(title: "Attention", message: "Nao há ninguem aceito no grupo: \(groupName). Peça a alguns de seus amigos para aceitarem em seus dispositivos", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
                    self.performSegueWithIdentifier("editGroup", sender: self)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
                
            }
        }
        else {
            navigationItem.rightBarButtonItem = UIBarButtonItem()
            let titleName = DataManager.sharedInstance.activeUsers[0].name
            self.navigationItem.title = titleName
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "NexaRustScriptL-0", size: 30)!]
            
            
            
        }
        
        
        
        
        
        
        

        /*
        //background
        
        NSNotificationCenter.defaultCent er().addObserver(self, selector: Selector("reinstateBackgroundTask"), name: UIApplicationDidBecomeActiveNotification, object: nil)
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self,selector: "backgroundCode", userInfo: nil, repeats: true)
        registerBackgroundTask()
        */
    }
    
    override func viewDidAppear(animated: Bool) {

        
        DataManager.sharedInstance.activeView = "map"
        DataManager.sharedInstance.locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status ==  .AuthorizedWhenInUse || status == .AuthorizedAlways {
            DataManager.sharedInstance.locationManager.startUpdatingLocation()   //inicia o locationmanager
            mapView.myLocationEnabled = true   //coloca a localizaçao do user no mapa com uma bolinha
            mapView.settings.myLocationButton = true    //coloca o botão de localizar user
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToSelectedFriend:", name: "goToUser", object: nil)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("updateLocationInMap"), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: "goToUser", object: nil)
        DataManager.sharedInstance.locationManager.delegate = nil
        DataManager.sharedInstance.activeView = "circles"
        timer.invalidate()

    }
    
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status ==  .AuthorizedWhenInUse || status == .AuthorizedAlways {    //se a autorizaçao do user estiver sendo pega pelo app
            DataManager.sharedInstance.locationManager.startUpdatingLocation()   //inicia o locationmanager
            mapView.myLocationEnabled = true   //coloca a localizaçao do user no mapa com uma bolinha
            mapView.settings.myLocationButton = true    //coloca o botão de localizar user
            

        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        self.controlNet.alpha = 1
        self.controlNet.enabled = true
        self.controlNet.text = "SEM LOCALIZAÇÃO"
    }


    func goBack () {
        if self.isCharm {
            let alert = UIAlertController(title: "Whistle", message: "Did you find \(DataManager.sharedInstance.activeUsers[0].name)?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
                
            }))
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
                
                var charm = Charm()
                var charmIndex = 0
                var index = 0
                for testCharm in DataManager.sharedInstance.myCharms {
                    if testCharm.sharer.id == DataManager.sharedInstance.selectedSharer[0].id {
                        charm = testCharm
                        charmIndex = index
                    }
                    index++
                }
                
                
                charm.sharer.status = "found"
                DataManager.sharedInstance.myCharms[charmIndex] = charm
                self.helper.updateSharerWithID(charm.sharer.id, until: nil, status: "found", completion: { (result) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                    DataManager.sharedInstance.isCharm = false
//                    if DataManager.sharedInstance.lastCharms.count != 0 {
//                        DataManager.sharedInstance.lastCharms[charmIndex] = charm
//                    }
                })
                
                
            }))

            self.presentViewController(alert, animated: true, completion: nil)

        }
        else {
            navigationController?.popViewControllerAnimated(true)
        }
    }

    
    
// MARK: entra nesse delegate quando recebe novas coordenadas do user
    
    

    

//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {    SE USAR ESSA FUNCAO NAO PODE USAR A didUpdateToLocation newLocation

    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if enterInView {mapView.camera = GMSCameraPosition(target: newLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0);enterInView = false}
        DataManager.sharedInstance.myUser.location.longitude = "\(newLocation.coordinate.longitude)"
        DataManager.sharedInstance.myUser.location.latitude = "\(newLocation.coordinate.latitude)"
        DataManager.sharedInstance.saveMyInfo()
        
        if UIApplication.sharedApplication().applicationState == .Active {
            print("Coord atualizada: \(newLocation.coordinate.longitude) \(newLocation.coordinate.latitude)")
            let location = "\(newLocation.coordinate.latitude):\(newLocation.coordinate.longitude)"
            if newLocation.horizontalAccuracy < 100 {
                helper.updateUserWithID(DataManager.sharedInstance.myUser.userID, username: nil, location: location, altitude: nil, fbid: nil, photo: nil, name: nil, email: nil, password: nil) { (result) -> Void in
                }
            }
        }
        else {
            print("App em background. Coord: \(newLocation.coordinate.longitude) \(newLocation.coordinate.latitude)")
            print(newLocation.horizontalAccuracy)
            if newLocation.horizontalAccuracy < 100 {
                let location = "\(newLocation.coordinate.latitude):\(newLocation.coordinate.longitude)"
                helper.updateUserWithID(DataManager.sharedInstance.myUser.userID, username: nil, location: location, altitude: nil, fbid: nil, photo: nil, name: nil, email: nil, password: nil) { (result) -> Void in
                    
                }
            }
            
            
            //DataManager.sharedInstance.createLocalNotification("oi", body: "\(newLocation.coordinate.latitude)", timeAfterClose: 10,userInfo:userInfoCoordinate)
        }

        
        
//        DataManager.sharedInstance.reverseGeocodeCoordinate(newLocation.coordinate) //transforma a coordenada em endereco
//        
//        if DataManager.sharedInstance.end != nil {
//            let actualLocation = Location()
//            actualLocation.location = newLocation
//            actualLocation.address = DataManager.sharedInstance.end
//            DataManager.sharedInstance.locationUserArray.append(actualLocation)
//        }
    }
    
    
    // MARK: - Types Controller Delegate

    
    func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
        if (gesture) {
            mapCenterPinImage.fadeIn(0.25)
            mapView.selectedMarker = nil
        }
    }
    
    @IBAction func mapTypeSegmentPressed(sender: AnyObject) {       //segment control para mudar o tipo de mapa
        let segmentedControl = sender as! UISegmentedControl
        segmentedControl.hidden = true
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = kGMSTypeNormal  //mapa normal
        case 1:
            mapView.mapType = kGMSTypeSatellite  //mapa satelite
        case 2:
            mapView.mapType = kGMSTypeHybrid    //mapa satelite com demarcaçoes de territorio
        default:
            mapView.mapType = mapView.mapType
        }
    }

    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {  //pega as coordenadas do centro da tela
        //reverseGeocodeCoordinate(position.target)
    }
    
    func goToSelectedFriend(notification: NSNotification) {
        if let info = notification.userInfo {
            if let user = info["user"] as? User {
                let lat = user.location.latitude as String
                let long = user.location.longitude as String
                
                let latitudeConvertida = (lat as NSString).doubleValue as CLLocationDegrees
                let longitudeConvertida = (long as NSString).doubleValue as CLLocationDegrees
                
                let userLocation = GMSCameraPosition.cameraWithLatitude(latitudeConvertida,longitude: longitudeConvertida, zoom: 15)
                mapView.camera = userLocation
            }
            
        }
        
    }
    
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {   //transforma coordenadas em endereço
        let geocoder = GMSGeocoder()
        var lines:[String]!
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                lines = address.lines as! [String]
                
                
                if lines != nil {
                    DataManager.sharedInstance.end = lines}
            }
        }
        
    }

    @IBAction func xButton(sender: AnyObject) {
        compassView.fadeOut(0.5)
        compassView.hidden = true
        navigationController?.navigationBar.hidden = false

    }
    
    @IBAction func ListaLocal(sender: AnyObject) {
        performSegueWithIdentifier("locationList", sender: nil)
    }

    
    
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        let clickedUser = marker.userData as! User
        print("clicouaquiiiiiiiiiiiii \(clickedUser.name)")
        return false
    }
    
    
    
    
    
    
// MARK: CODIGO PARA BACKGROUND
    
//    func endBackgroundTask() {
//        NSLog("Background codigos encerrou")
//        UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
//        backgroundTask = UIBackgroundTaskInvalid
//        
//    }
//    
//    
//    func registerBackgroundTask() {
//        backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
//            [unowned self] in
//            self.endBackgroundTask()
//        }
//        assert(backgroundTask != UIBackgroundTaskInvalid)
//    }
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
//    
//    
//    
//    func reinstateBackgroundTask() {
//        if updateTimer != nil && (backgroundTask == UIBackgroundTaskInvalid) {
//            registerBackgroundTask()
//        }
//    }
    
// MARK: CODIGO PARA BACKGROUND ATE AQUI
    
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            let userInMarker = marker.userData as! User
            
            let updateHour = userInMarker.updatedAt
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            
            let date = dateFormatter.dateFromString(updateHour)

            var shortDate: String {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy HH::mm:ss"
                return dateFormatter.stringFromDate(date!)
            }
            
            infoView.nameLabel.text = "\(userInMarker.name)\nLast update:\n\(shortDate)"
            infoView.nameLabel.font = UIFont(name: "SFUIDisplay-Light", size: 22)
            infoView.userPhoto.image = DataManager.sharedInstance.findImage("\(userInMarker.userID)")
            infoView.userPhoto.clipsToBounds = true
//            let ok = infoView.userPhoto.frame.height
//            let ok2 = infoView.userPhoto.frame.size.height
//            infoView.userPhoto.layer.cornerRadius = 30 //* 320 / self.view.frame.size.width
//            
//            infoView.layer.cornerRadius = infoView.frame.size.width / 4
//            infoView.layer.borderColor = mainRed.CGColor
//            infoView.layer.borderWidth = 2
//            infoView.clipsToBounds = true

            
            return infoView
        } else {
            
            marker.icon = UIImage(named: "compass.png")
            return nil
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("oi")
    }



    
    override func viewWillAppear(animated: Bool) {
            self.navigationController?.navigationBar.translucent = false
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            let fontDictionary = [ NSForegroundColorAttributeName:UIColor.whiteColor() ]
            self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
            self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), forBarMetrics: UIBarMetrics.Default)
    
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
    
    func setUpBackgrounGradient () {
        //navigationController?.navigationBar.hidden = true
        let red1 = UIColor(red: 213/255, green: 45/255, blue: 73/255, alpha: 1)
        let red2 = UIColor(red: 215/255, green: 35/255, blue: 65/255, alpha: 0.8)
        
        let gradientColors: [CGColor] = [red1.CGColor, red2.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations

        
        gradientLayer.frame = CGRectMake(0.0, 0.0, compassView.frame.size.width, compassView.frame.size.height*5/4)
        compassView.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        friendPhoto.layer.cornerRadius = 3
        friendPhoto.layer.borderWidth = 2
        friendPhoto.layer.borderColor = UIColor.whiteColor().CGColor
        


      
        
    }

    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        if navigationController?.navigationBar.hidden == false {
            self.compassView.hidden = false
            compassView.fadeIn(0.5)
            friendDistance.hidden = true
            friendPhoto.hidden = true
            navigationController?.navigationBar.hidden = true
            let friend = marker.userData as! User
            self.selectedFriend = friend
            let locationFriend = CLLocation(latitude: Double(friend.location.latitude)!, longitude: Double(friend.location.longitude)!)
            print("-1")
            let myCoordinate = CLLocation(latitude: Double(DataManager.sharedInstance.myUser.location.latitude)!, longitude: Double(DataManager.sharedInstance.myUser.location.longitude)!)
            print("0")
            let id = friend.userID
            friendPhoto.image = DataManager.sharedInstance.findImage(friend.userID)
            print("1")
            updateCompassPosition(myCoordinate, location: locationFriend)
        }
    }
    
    func updateCompassPosition(myLocation:CLLocation,location:CLLocation) {
        let dx = location.coordinate.longitude - myLocation.coordinate.longitude
        let dy = location.coordinate.latitude - myLocation.coordinate.latitude
        let rotationAngle = CGFloat(atan2(dy, dx))
        let balancedAngle = rotationAngle + CGFloat(actualPhoneAngularPosition * M_PI / 180 - M_PI_2)
        
        
        arrowCompass.transform = CGAffineTransformMakeRotation(-balancedAngle)
        let distance = myLocation.distanceFromLocation(location)
        //let distance = Int(sqrt(pow(dx, 2) + pow(dy, 2))*1000)
        self.friendDistance.text = "\(distance) meters"

    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.actualPhoneAngularPosition = newHeading.magneticHeading
        let myCoordinate = CLLocation(latitude: Double(DataManager.sharedInstance.myUser.location.latitude)!, longitude: Double(DataManager.sharedInstance.myUser.location.longitude)!)
        
        if let friend = self.selectedFriend {
            let locationFriend = CLLocation(latitude: Double(friend.location.latitude)!, longitude: Double(friend.location.longitude)!)
            updateCompassPosition(myCoordinate, location: locationFriend)
        }

        
    }
    func charmAccepted(notification: NSNotification) {
//        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func draggedViewDown(sender:UISwipeGestureRecognizer) {
        print("swipe down")
        compassViewTopConstraint.constant = self.view.frame.height - arrowCompass.frame.height
        compassViewLeftConstraint.constant = self.view.frame.width - (arrowCompass.frame.width / 2)
        compassViewRightConstraint.constant = self.view.frame.width - (arrowCompass.frame.width / 2)
        
        arrowCompassTopConstraint.constant = self.view.frame.height * 0.6
        arrowCompassLeftConstraint.constant = self.view.frame.width * 0.25
        arrowCompassRightConstraint.constant = self.view.frame.width * 0.25
        
    func charmReceived(notification: NSNotification) {
//        self.navigationController?.popToRootViewControllerAnimated(true)

    }
    
//    func charmFound(notification: NSNotification) {
//        if DataManager.sharedInstance.activeView == "map" {
//            if let info = notification.userInfo {
//                if let charmIndex = info["charmIndex"] as? Int {
//                    let charm = DataManager.sharedInstance.myCharms[charmIndex]
//            
//                    let friendName = DataManager.sharedInstance.activeUsers[0].name
//                    let alert = UIAlertController(title: "Found", message: "\(friendName) has found you", preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:  { (action: UIAlertAction!) in
//                        self.helper.destroySharerWithSharerType(.userToUser, ownerID: charm.sharer.owner, receiverID: charm.sharer.receiver, completion: { (result) -> Void in
//                            self.navigationController?.popToRootViewControllerAnimated(true)
//                        })
//
//                    }))
//                    self.presentViewController(alert, animated: true, completion: nil)
//                            
//                }
//            }
//        }
//
//    }
    
//    func draggedView (sender:UIPanGestureRecognizer) {
//        
//        for view in compassView.subviews {
//            view.hidden = true
//        }
        
        northLine.hidden = true
        friendPhoto.hidden = true
        friendDistance.hidden = true
        
    
    }
    

    
    func draggedViewUp(sender:UIGestureRecognizer) {
        print("swipe up")
        
        compassViewTopConstraint.constant = -20
        compassViewLeftConstraint.constant = -20
        arrowCompassTopConstraint.constant = 30
        arrowCompassLeftConstraint.constant = 40
        arrowCompassRightConstraint.constant = 40
        
    
        
        }
        
        
        
        //
//        self.view.bringSubviewToFront(sender.view!)
//        var translation = sender.translationInView(self.view)
//        sender.view?.center = CGPointMake((sender.view?.center.x)! + translation.x, (sender.view?.center.y)! + translation.y)
//        
//    }
    
//  
    
    func updateLocationInMap() {
         DataManager.sharedInstance.updateLocationUsers(mapView)
    }
    

}





