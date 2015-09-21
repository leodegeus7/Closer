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

class MapGoogleViewController: UIViewController, TypesTableViewControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!    //outlet do mapa como um mapa do google
    @IBOutlet weak var mapCenterPinImage: UIImageView!
    @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
    
    var searchedTypes = ["bakery", "bar", "cafe", "grocery", "restaurant"]
    var locationFirst:CLLocation!
    let dataProvider = GoogleDataProvider()
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
        DataManager.sharedInstance.locationManager.delegate = self
        mapView.delegate = self   //delegate das funçoes do google maps
        mapView.mapType = kGMSTypeNormal
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    
    
// MARK: entra nesse delegate quando recebe novas coordenadas do user
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status ==  .AuthorizedWhenInUse || status == .AuthorizedAlways {    //se a autorizaçao do user estiver sendo pega pelo app
            DataManager.sharedInstance.locationManager.startUpdatingLocation()   //inicia o locationmanager
            mapView.myLocationEnabled = true   //coloca a localizaçao do user no mapa com uma bolinha
            mapView.settings.myLocationButton = true    //coloca o botão de localizar user
        }
    }
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {    SE USAR ESSA FUNCAO NAO PODE USAR A didUpdateToLocation newLocation

    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if locationFirst == nil {
            locationFirst = newLocation
            mapView.camera = GMSCameraPosition(target: newLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)  //posiciona a camera do maps
        }
        else {
            if UIApplication.sharedApplication().applicationState == .Active {
                print("app aberto. Coord: \(newLocation.coordinate.longitude) \(newLocation.coordinate.latitude)")
                let marker = GMSMarker(position: CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude))
                marker.title = "\(newLocation.coordinate.latitude) e \(newLocation.coordinate.longitude)"
                marker.map = mapView}
            else {
                print("App em background. Coord: \(newLocation.coordinate.longitude) \(newLocation.coordinate.latitude)")
                let marker = GMSMarker(position: CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude))
                marker.title = "\(newLocation.coordinate.latitude) e \(newLocation.coordinate.longitude)"
                marker.map = mapView }

        }
       
        
        DataManager.sharedInstance.reverseGeocodeCoordinate(newLocation.coordinate) //transforma a coordenada em endereco
        if DataManager.sharedInstance.end != nil {
            let actualLocation = Location()
            actualLocation.location = newLocation
            actualLocation.address = DataManager.sharedInstance.end
            DataManager.sharedInstance.locationUserArray.append(actualLocation)}
        else {
            _ = "Nao funfa"
            //actualLocation.address.append(msg)
        }
        
        


    }
    


    
    
    
    // MARK: - Types Controller Delegate
    func typesController(controller: TypesTableViewController, didSelectTypes types: [String]) {
        searchedTypes = controller.selectedTypes.sort()
        dismissViewControllerAnimated(true, completion: nil)
        fetchNearbyPlaces(mapView.camera.target)
    }
    
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
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        mapCenterPinImage.fadeOut(0.25)
        return false
    }
    
    func didTapMyLocationButtonForMapView(mapView: GMSMapView!) -> Bool {
        mapCenterPinImage.fadeIn(0.25)
        mapView.selectedMarker = nil
        return false
    }
    
    
    @IBAction func refreshButton(sender: AnyObject) {
        fetchNearbyPlaces(mapView.camera.target)
    }
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {  //pega as coordenadas do centro da tela
        //reverseGeocodeCoordinate(position.target)
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
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:mapRadius, types: searchedTypes) { places in
            for place: GooglePlace in places {
                let marker = PlaceMarker(place: place)
                marker.map = self.mapView
            }
        }
    }
    
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        
        let placeMarker = marker as! PlaceMarker
        
        
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
        
            infoView.nameLabel.text = placeMarker.place.name
            
                if let photo = placeMarker.place.photo {
                infoView.placePhoto.image = photo
            } else {
                infoView.placePhoto.image = UIImage(named: "generic")
            }
            
            return infoView
        } else {
            return nil
        }
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
       
        let googleMarker = mapView.selectedMarker as! PlaceMarker
       
        dataProvider.fetchDirectionsFrom(mapView.myLocation.coordinate, to: googleMarker.place.coordinate) {optionalRoute in
            if let encodedRoute = optionalRoute {
           
                let path = GMSPath(fromEncodedPath: encodedRoute)
                let line = GMSPolyline(path: path)
                
            
                line.strokeWidth = 4.0
                line.tappable = true
                line.map = self.mapView
                line.strokeColor = self.randomLineColor
                
      
                mapView.selectedMarker = nil
            }
        }
        
    }
    
    
    @IBAction func ListaLocal(sender: AnyObject) {
        performSegueWithIdentifier("locationList", sender: nil)
    }

    
    
    
    
}

