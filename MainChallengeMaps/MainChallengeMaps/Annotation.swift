//
//  Annotation.swift
//  mapKit
//
//  Created by Leonardo Geus on 13/05/15.
//  Copyright (c) 2015 Leonardo Geus. All rights reserved.
//

import UIKit
import MapKit

enum AttractionType: Int {
  case AttractionDefault = 0
  case AttractionRide
  case AttractionFood
  case AttractionFirstAid
}

class Annotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String
  var subtitle: String
  var image:String
  
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, imagem: String) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
    self.image = imagem
  }
}