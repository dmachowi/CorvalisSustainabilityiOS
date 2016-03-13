//
//  Reuse and Repair App -- iOS
//  Drew Matthew Machowicz
//  Allyce McWhorter
//  Andrew Pierno
//
//  Copyright © 2016 dmm. All rights reserved.
//
//  ReuseCatBusInf.swift -- This view controller shows all of the data for the business
//  selected in the previous VC

import Alamofire
import UIKit
import MapKit

class ReuseCatBusInf: UIViewController {
    //outlets for the labels to be populated with the business data
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var addresslabel: UILabel!
    @IBOutlet weak var noteslabel: UILabel!
    @IBOutlet weak var phonelabel: UILabel!
    @IBOutlet weak var websitelabel: UILabel!
    
    //business id chosen in previous VC
    var chosenBusID = 0
    //url to get business info, must change after deployment
    var url = "http://localhost:8888/sustain/app/api/business.php"
    //array to hold JSON objects
    var jsonArray = [JSON] ()
    //array to hold the names of categories
    var nameArray=[String]()
    
    //center map, default sizing
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
        
        mapView.delegate = self
        
        //Makes POST request with Alamofire for business
        Alamofire.request(.POST, url, parameters: ["bus_id":chosenBusID], encoding: .JSON).responseJSON{
            response in switch response.result{
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    for(_, subJson):(String, JSON) in json {
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
                        
                        //populates the labels
                        self.namelabel.text = thisName
                        if thisAddress != "" {
                            self.addresslabel.text = thisAddress + " " + thisCity + ", " + thisState
                        }
                        self.phonelabel.text = thisPhone
                        self.noteslabel.text = thisNotes
                        
                        //sets default location to the location of the current business
                        let intialLocation = CLLocation(latitude: thisLatitude, longitude: thisLongitude)
                        self.centerMapOnScreen(intialLocation)
                        
                        //creates local business object
                        let business = Business(title: thisTitle, address: thisAddress, city: thisCity, id: thisId , latitude: thisLatitude, longitude: thisLongitude, name: thisName, notes: thisNotes, phone: thisPhone, state: thisState, type: thisType, website: thisWebsite, coordinate: CLLocationCoordinate2D(latitude: thisLatitude, longitude: thisLongitude))
                        
                        self.mapView.addAnnotation(business)
                    }
                }
            case .Failure(let error):
                print("There was an error\(error)")
            }
        }
    }
}
