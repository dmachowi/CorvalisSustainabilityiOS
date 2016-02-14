//
//  Business.swift
//  proj4
//
//  Created by DREWCIFER on 2/9/16.
//  Copyright © 2016 dmm. All rights reserved.
//

import Foundation
import MapKit

class Business: NSObject, MKAnnotation {
    let title: String?
    let address: String
    let city: String
    let id: Int
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let name: String
    let notes: String
    let phone: String
    let state: String
    let type: String
    let website: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, address: String, city: String, id: Int, latitude: CLLocationDegrees, longitude: CLLocationDegrees, name: String, notes: String, phone: String, state: String, type: String, website: String,  coordinate: CLLocationCoordinate2D) {
        self.title = name //title is required by mkannotation
        self.address = address
        self.city = city
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.notes = notes
        self.phone = phone
        self.state = state
        self.type = type
        self.website = website
        self.coordinate = coordinate
        
        super.init()
    }
    
    //subtitle required by mkannotation
    var subtitle: String? {
        return name
    }
}