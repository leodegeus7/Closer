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

class MapGoogleViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var controlNet: UILabel!
    @IBOutlet weak var mapView: GMSMapView!    //outlet do mapa como um mapa do google
    @IBOutlet weak var mapCenterPinImage: UIImageView!
    @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var compassView: UIView!
    var gradient:UIImage!
    
    

    
    
    //background whetever
    var updateTimer: NSTimer?
    var updateFriendsTimer: NSTimer?
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
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
        mapView.delegate = self   //delegate das funçoes do google maps
        mapView.mapType = kGMSTypeNormal
        self.setUpBackgrounGradient()
        DataManager.sharedInstance.updateLocationUsers(mapView)
        mapView.settings.compassButton = true
        self.compassView.hidden = true
        friendDistance.font = UIFont(name:"SFUIText-Regular", size: 15)
        
        
        

        /*
        //background
        
        NSNotificationCenter.defaultCent er().addObserver(self, selector: Selector("reinstateBackgroundTask"), name: UIApplicationDidBecomeActiveNotification, object: nil)
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self,selector: "backgroundCode", userInfo: nil, repeats: true)
        registerBackgroundTask()
        */
    }
    
    override func viewDidAppear(animated: Bool) {
        DataManager.sharedInstance.locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status ==  .AuthorizedWhenInUse || status == .AuthorizedAlways {
            DataManager.sharedInstance.locationManager.startUpdatingLocation()   //inicia o locationmanager
            mapView.myLocationEnabled = true   //coloca a localizaçao do user no mapa com uma bolinha
            mapView.settings.myLocationButton = true    //coloca o botão de localizar user
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToSelectedFriend:", name: "goToUser", object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: "goToUser", object: nil)
        DataManager.sharedInstance.locationManager.delegate = nil

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



    
    
    
// MARK: entra nesse delegate quando recebe novas coordenadas do user
    
    

    

//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {    SE USAR ESSA FUNCAO NAO PODE USAR A didUpdateToLocation newLocation

    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if enterInView {mapView.camera = GMSCameraPosition(target: newLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0);enterInView = false}
        DataManager.sharedInstance.myUser.location.longitude = "\(newLocation.coordinate.longitude)"
        DataManager.sharedInstance.myUser.location.latitude = "\(newLocation.coordinate.latitude)"
        DataManager.sharedInstance.saveMyInfo()
        
        if UIApplication.sharedApplication().applicationState == .Active {
            print("Coord atualizada: \(newLocation.coordinate.longitude) \(newLocation.coordinate.latitude)")
        }
        else {
            print("App em background. Coord: \(newLocation.coordinate.longitude) \(newLocation.coordinate.latitude)")
            let marker = GMSMarker(position: CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude))
            marker.title = "\(newLocation.coordinate.latitude) e \(newLocation.coordinate.longitude)"
            marker.map = mapView
            let userInfoCoordinate = ["local":newLocation]
            DataManager.sharedInstance.createLocalNotification("oi", body: "\(newLocation.coordinate.latitude)", timeAfterClose: 10,userInfo:userInfoCoordinate)
        }


        let location = "\(newLocation.coordinate.latitude):\(newLocation.coordinate.longitude)"
        
        helper.updateUserWithID(DataManager.sharedInstance.myUser.userID, username: nil, location: location, altitude: nil, fbid: nil, photo: nil, name: nil, email: nil, password: nil) { (result) -> Void in
            //oi
        }
        
        
        DataManager.sharedInstance.reverseGeocodeCoordinate(newLocation.coordinate) //transforma a coordenada em endereco
        
        if DataManager.sharedInstance.end != nil {
            let actualLocation = Location()
            actualLocation.location = newLocation
            actualLocation.address = DataManager.sharedInstance.end
            DataManager.sharedInstance.locationUserArray.append(actualLocation)
        }
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
    
    func endBackgroundTask() {
        NSLog("Background codigos encerrou")
        UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
        
    }
    
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
            [unowned self] in
            self.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    func reinstateBackgroundTask() {
        if updateTimer != nil && (backgroundTask == UIBackgroundTaskInvalid) {
            registerBackgroundTask()
        }
    }
    
// MARK: CODIGO PARA BACKGROUND ATE AQUI
    
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            let userInMarker = marker.userData as! User
            infoView.nameLabel.text = userInMarker.name
            infoView.userPhoto.image = DataManager.sharedInstance.findImage("\(userInMarker.userID)")
            return infoView
        } else {
            return nil
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("oi")
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
        self.compassView.hidden = false
        navigationController?.navigationBar.hidden = true
        let friend = marker.userData as! User
        let locationFriend = CLLocation(latitude: Double(friend.location.latitude)!, longitude: Double(friend.location.longitude)!)
        print("-1")
        let myCoordinate = CLLocation(latitude: Double(DataManager.sharedInstance.myUser.location.latitude)!, longitude: Double(DataManager.sharedInstance.myUser.location.longitude)!)
        print("0")
        let id = friend.userID
        friendPhoto.image = DataManager.sharedInstance.findImage(friend.userID)
        print("1")
        updateCompassPosition(myCoordinate, location: locationFriend)
    }
    
    func updateCompassPosition(myLocation:CLLocation,location:CLLocation) {
        let dx = location.coordinate.longitude - myLocation.coordinate.longitude
        let dy = location.coordinate.latitude - myLocation.coordinate.latitude
        let rotationAngle = CGFloat(atan2(-dy, dx))
        arrowCompass.transform = CGAffineTransformMakeRotation(rotationAngle)
        let distance = myLocation.distanceFromLocation(location)
        //let distance = Int(sqrt(pow(dx, 2) + pow(dy, 2))*1000)
        self.friendDistance.text = "\(distance) meters"

    }

}



