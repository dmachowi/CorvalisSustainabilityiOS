//
//  singleMap.swift
//  proj4
//
//  Created by DREWCIFER on 3/6/16.
//  Copyright © 2016 dmm. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

extension ReuseCatBusInf: MKMapViewDelegate {
    
    // 1
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Business {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                
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
    
    
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let bus = view.annotation as! Business
        let placeName = bus.name
        var placeInfo = bus.address + ", " + bus.city + ", " + bus.state + "\nPhone number: " + bus.phone + "\nWebsite: " + bus.website + "\nType: " + bus.type
        if (bus.notes != "") {
            placeInfo += "\nNotes: " + bus.notes
        }
        let ac = UIAlertController(title: placeName, message: placeInfo , preferredStyle: .Alert)
        presentViewController(ac, animated: true, completion: nil)
        
        let mapIt = UIAlertAction(title: "Map it", style: .Default) { (action) in
            print("map it worked")
            
            let location = view.annotation as! Business
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMapsWithLaunchOptions(launchOptions)
        }
        ac.addAction(mapIt)
        
        
        //http://stackoverflow.com/questions/25117321/iphone-call-from-app-in-swift-xcode-6
        //phone call should work but they say you cannot test it on the simulator, you must use a real device
        let callIt = UIAlertAction(title: "Call it", style: .Default) { (action) in
            print("call it worked")
            var url:NSURL = NSURL(string: "tel://" +  bus.phone)!
            UIApplication.sharedApplication().openURL(url)
            
        }
        ac.addAction(callIt)
        
        let visitWebsite = UIAlertAction(title: "Visit Website", style: .Default) {(action) in
            print("website worked")
            UIApplication.sharedApplication().openURL(NSURL(string: bus.website)!)
        }
        ac.addAction(visitWebsite)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
        
    }
}