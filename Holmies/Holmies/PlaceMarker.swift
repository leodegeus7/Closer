//
//  AppDelegate.swift
//  Holmies
//
//  Created by Leonardo Geus on 03/09/15.
//  Copyright (c) 2015 Leonardo Geus. All rights reserved.
//

import Foundation

class PlaceMarker: GMSMarker {      // é uma classe de  annotacion do google
    let place: GooglePlace
    init(place: GooglePlace) {
        self.place = place
        super.init()
        
        position = place.coordinate
        icon = UIImage(named: place.placeType+"_pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = kGMSMarkerAnimationPop
    }
}