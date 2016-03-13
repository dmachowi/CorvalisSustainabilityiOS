//
//  Reuse and Repair App -- iOS
//  Drew Matthew Machowicz
//  Allyce McWhorter
//  Andrew Pierno
//
//  Copyright © 2016 dmm. All rights reserved.
//
//  MapsViewController.swift -- This view controller is a map that contains a pin for each of the businesses
//  with a green for reuse category businesses and blue for repair category businesses. The user can tap a pin
//  and a bubble will pop up that contains the name of the business along with an information button. If
//  the user taps the information button they can see all the data for the business, including name, address,
//  phone number, website, type and any notes. Then there are buttons listed that allow the user to easily get
//  directions from their current location to the business, call it, or visit their website. Tapping on "Map it"
//  will open up the Maps app for directinos, tapping call it will open up the dialer, and tapping Visit Website
//  will open up their website in Safari.
// http://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial


import UIKit
import MapKit
import Alamofire

class MapsViewController: UIViewController {
    //outlet for map in the vew c
    @IBOutlet weak var mapView: MKMapView!
    
    //array that holds all the Business objects
    var businessArray=[Business]()
    //array that holds all the json data before being put into a Business object
    var jsonArray = [JSON] ()
    
    //url used to get all businesses, must be changed from localhost to actual URL upon deployment
    var url = "http://localhost:8888/sustain/app/api/businesses.php"
    
    //function taken from tutorial, centers the map and specifies the default visible space
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnScreen(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2.0, regionRadius*2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //vars to hold Business object data
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
        
        
        //center of corvallis as initial location
        let intialLocation = CLLocation(latitude: 44.564566, longitude: -123.262044)
        centerMapOnScreen(intialLocation)
        
        mapView.delegate = self
        
        //make JSON GET request from using Alamofire
        Alamofire.request(.GET, url).responseJSON{
            response in switch response.result{
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    //print("JSON: \(json)")
                
                    //takes all the data from the JSON call and creates a Business object with all
                    //data to be added to the map
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
                        thisPhone = subJson["phone"].stringValue
                        thisWebsite = subJson["website"].stringValue
                        thisState = subJson["state"].stringValue
                        thisType = subJson["type"].stringValue
                        thisTitle = subJson["name"].stringValue   //title required for object
                        
                        //creates local Business object var
                        let business = Business(title: thisTitle, address: thisAddress, city: thisCity, id: thisId , latitude: thisLatitude, longitude: thisLongitude, name: thisName, notes: thisNotes, phone: thisPhone, state: thisState, type: thisType, website: thisWebsite, coordinate: CLLocationCoordinate2D(latitude: thisLatitude, longitude: thisLongitude))
                        
                        //adds current business to the map
                        self.mapView.addAnnotation(business)
                    }
                }
            case .Failure(let Error):
                print("There was an error \(Error)")
            }
        }
    }
}
