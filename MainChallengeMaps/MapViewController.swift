//
//  MapViewController.swift
//  MainChallengeMaps
//
//  Created by Leonardo Koppe Malanski on 17/08/15.
//  Copyright (c) 2015 Leonardo Koppe Malanski. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var coreLocation = CLLocationManager()
    var locationAvailability = false
    var ip = "172.16.2.49"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.Standard
        mapView.delegate = self
        
        coreLocation.desiredAccuracy = kCLLocationAccuracyBest
        coreLocation.distanceFilter = 100
        coreLocation.startUpdatingLocation()
        coreLocation.delegate = self
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
//        
//        if (timer != nil) {
//         timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
//        
//        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func refreshButton(sender: AnyObject) {
        let userLocation = mapView.userLocation.coordinate
        let region = MKCoordinateRegionMakeWithDistance(userLocation, 1000, 1000)
        
        
        
        if locationAvailability {
            mapView.setRegion(region, animated: true)

        } else {
            let errorAlert = UIAlertView(title: "Erro", message: "Localização indisponível", delegate: nil, cancelButtonTitle: "OK")
            errorAlert.show()
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error.description)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        DataManager.sharedInstance.latitude = "\(coreLocation.location.coordinate.latitude)"
        DataManager.sharedInstance.longitude = "\(coreLocation.location.coordinate.longitude)"

    }
    
    
    func update() {
        var url = NSURL(string: "http://\(ip):8888/recebe.php")
        var data = NSData(contentsOfURL: url!)
        var json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
        checkLOCMAN()
    //  println("\(json)")
//        println("\n")
//        print(DataManager.sharedInstance.latitude)
//        print(DataManager.sharedInstance.longitude)
        
        
        for item in json {
            if !(item.key as! NSString == " " || item.key as! NSString == "") {
                var nome = item.key as! NSString
                var coordenadas: AnyObject = item.value
                var latitude = coordenadas["latitude"] as! NSString
                var longitude = coordenadas["longitude"] as! NSString
                println("\(nome) = \(latitude) e \(longitude)")
                var annotation = MKPointAnnotation()
                //annotation.title
                var latitudeConvertida = (latitude).doubleValue as CLLocationDegrees
                var longitudeConvertida = (longitude).doubleValue as CLLocationDegrees
                annotation.coordinate = CLLocationCoordinate2DMake(latitudeConvertida,longitudeConvertida)
                mapView.addAnnotation(annotation)
                
                
            }
            
            
            
        }
     
        if locationAvailability {
            var urlEnvio = NSURL(string: "http://\(ip):8888/recebe.php?id=\(DataManager.sharedInstance.nome)&lat=\(DataManager.sharedInstance.latitude)&long=\(DataManager.sharedInstance.longitude)")
            let request = NSURLRequest(URL: urlEnvio!)
            let response:NSURLResponse?
            let responseData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            //println("\(urlEnvio)")
            

            
            
        } else {
            println("Não deu certo")
        }
     
        
    }

    func checkLOCMAN() {
        if coreLocation.location != nil {
            println("locationManager.location is set, carrying on")
            locationAvailability = true
        } else {
            println("locationManager.location is nil, waiting 2000ms")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
