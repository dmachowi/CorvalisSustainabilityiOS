//
//  MapsViewController.swift
//  proj4
//
//  Created by DREWCIFER on 2/8/16.
//  Copyright © 2016 dmm. All rights reserved.
//http://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial
//color code pins basedvar category


import UIKit
import MapKit
import Alamofire
//import SwiftyJSON

class MapsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var businessArray=[Business]()
    var jsonArray = [JSON] ()
    var url = "http://localhost:8888/sustain/app/api/businesses.php"
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnScreen(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2.0, regionRadius*2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var thisTitle = ""
        var thisAddress = ""
        var thisCity = ""
        var thisId = 0
        var thisLatitude = 0.0
        var thisLongitude = 0.0
        var thisName = ""
        var thisNotes = ""
        var thisPhone = ""
        var thisState = ""
        var thisType = ""
        var thisWebsite = ""
        
        
        //center of corvallis, later change to get location from gps on phone
        let intialLocation = CLLocation(latitude: 44.564566, longitude: -123.262044)
        centerMapOnScreen(intialLocation)
        
        //hardcode a business for now
        //later get from DB and store to array
        mapView.delegate = self
//        let business = Business(title: "test title", address: "address", city: "city", id: 34, latitude: 12, longitude: 12, name: "name", notes: "notes", phone: "1212", state: "OR", type: "type", website: "website.com", coordinate: CLLocationCoordinate2D(latitude: 44.577977, longitude: -123.261567))
        
        
        
        
        Alamofire.request(.GET, url).responseJSON{
            response in switch response.result{
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    //print("JSON: \(json)")
                    
                    //var thisAddress = json[0]["address"]
                    //let addyString = thisAddress.string!
                    //print("THIS IS ADDRESSSSSS: \(addyString)")
                
                
                    for(key, subJson):(String, JSON) in json {
                        print("this is key: \(key) and this is \(subJson)")
                        self.jsonArray.append(subJson)
                        thisAddress = subJson["address"].stringValue
                        thisCity = subJson["city"].stringValue
                        thisId = subJson["id"].int!
                        thisLatitude = subJson["latitude"].double!
                        thisLongitude = subJson["longitude"].double!
                        thisName = subJson["name"].stringValue
                        thisNotes = subJson["notes"].stringValue
                        thisPhone = subJson["phone"].stringValue //int or string? show number to dial
                        thisWebsite = subJson["website"].stringValue
                        thisState = subJson["state"].stringValue
                        thisType = subJson["type"].stringValue
                        thisTitle = subJson["name"].stringValue   //title required for object
                        
                        let business = Business(title: thisTitle, address: thisAddress, city: thisCity, id: thisId , latitude: thisLatitude, longitude: thisLongitude, name: thisName, notes: thisNotes, phone: thisPhone, state: thisState, type: thisType, website: thisWebsite, coordinate: CLLocationCoordinate2D(latitude: thisLatitude, longitude: thisLongitude))
                        
                        self.mapView.addAnnotation(business)
                    }
                
                }
            case .Failure(let Error):
                print("There was an error \(Error)")
            }
        }

    
        
//        let business = Business(title: title, address: address, city: city, id: id, latitude: latitude, longitude: longitude, name: name, notes: notes, phone: phone, state: state, type: type, website: website, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
//        mapView.addAnnotation(business)
        //there is also addAnnotations method for array
    }
//coordinate: CLLocationCoordinate2D(latitude: 44.577977, longitude: -123.261567)
    



}
