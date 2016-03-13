//
//  Reuse and Repair App -- iOS
//  Drew Matthew Machowicz
//  Allyce McWhorter
//  Andrew Pierno
//
//  Copyright © 2016 dmm. All rights reserved.
//
//  singleMapReuse.swift -- extension of the map in ReuseCatBusInf

import Foundation
import MapKit
import AddressBook

extension ReuseCatBusInf: MKMapViewDelegate {
    //adds pin to the map
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Business {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                //adds detail disclosure button for the user to get more information about the business
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                
                //pin colors
                //http://stackoverflow.com/questions/32692805/adapting-pintintcolor-to-ray-wenderlich-tutorial-for-mapkit
                switch annotation.type {
                case "reuse":
                    view.pinTintColor = UIColor.greenColor()
                case "repair":
                    view.pinTintColor = UIColor.blueColor()
                default:
                    view.pinTintColor = UIColor.purpleColor()
                }
                return view
            }
            return view
        }
        return nil
    }
    
    
    //this function takes care of what happens when the user taps the info button in the popup bubble from the pin
    //it lists all available data for that business, and then it gives the user the option to get directions, call
    //it or visit the website.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //local var to hold current business
        let bus = view.annotation as! Business
        let placeName = bus.name
        var placeInfo = ""
        var web = "N/A"
        
        //changes website to N/A if there is no webiste listed
        if bus.website != "" {
            web = bus.website
        }
        
        //checks if there is no address, if there is no address it wont try to add commans or other parts of the address
        //this is because there are some websites in the categories, they wouldn't have an address, they also
        //may not have a phone number
        if bus.address != "" {
            placeInfo = bus.address + ", " + bus.city + ", " + bus.state + "\nPhone number: " + bus.phone + "\nWebsite: " + web + "\nType: " + bus.type
        } else {
            var fon = "N/A"
            if bus.phone != "" {
                fon = bus.phone
            }
            placeInfo = "Phone number: " + fon + "\nWebsite: " + web + "\nType: " + bus.type
        }
        
        //adds notes if there are notes
        if (bus.notes != "") {
            placeInfo += "\nNotes: " + bus.notes
        }
        
        //set up alert to choose options for current selected pin
        let ac = UIAlertController(title: placeName, message: placeInfo , preferredStyle: .Alert)
        presentViewController(ac, animated: true, completion: nil)
        
        //checks for address, if there is address the Map it option appears
        if bus.address != "" {
            let mapIt = UIAlertAction(title: "Map it", style: .Default) { (action) in
                //print("map it worked")
                let location = view.annotation as! Business
                
                //opens up Maps app with driving directions to the business
                //http://stackoverflow.com/questions/32341851/bsmacherror-xcode-7-beta
                //getting error messages when opening Maps app, this prevetned it
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    location.mapItem().openInMapsWithLaunchOptions(launchOptions)}
            }
            ac.addAction(mapIt)
        }
        
        //checks for phone number and then adds option to Call it if there is a phone number
        //http://stackoverflow.com/questions/25117321/iphone-call-from-app-in-swift-xcode-6
        //phone call should work but they say you cannot test it on the simulator, you must use a real device
        if bus.phone != "" {
            let callIt = UIAlertAction(title: "Call it", style: .Default) { (action) in
                print("call it worked")
                let url:NSURL = NSURL(string: "tel://" +  bus.phone)!
                UIApplication.sharedApplication().openURL(url)
                
            }
            ac.addAction(callIt)
        }
        
        //checks for website first, if there is a website then Visit website becomes visible
        //website will open in safari
        if bus.website != "" {
            let visitWebsite = UIAlertAction(title: "Visit Website", style: .Default) {(action) in
                print("website worked")
                UIApplication.sharedApplication().openURL(NSURL(string: bus.website)!)
            }
            ac.addAction(visitWebsite)
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
        
    }
}