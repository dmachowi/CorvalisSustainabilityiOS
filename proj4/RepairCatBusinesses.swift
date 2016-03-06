//
//  RepairCatBusinesses.swift
//  proj4
//
//  Created by DREWCIFER on 2/28/16.
//  Copyright © 2016 dmm. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class RepairCatBusinesses: UITableViewController {
    var chosenCat = 0
    var jsonArray = [JSON] ()
    var nameArray=[String]()
    var url = "http://localhost:8888/sustain/app/api/repairBusinesses.php"
    var catID = 0
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
    var catName = ""
    var busName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(.POST, url, parameters:["cat_id":chosenCat], encoding: .JSON).responseJSON{
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
                        self.catName = subJson["cat_name"].stringValue
                        self.busName = subJson["bus_name"].stringValue
                        self.nameArray.append(self.busName)
                        //                        self.jsonArray.append(subJson)
                        //                        self.thisAddress = subJson["address"].stringValue
                        //                        self.thisCity = subJson["city"].stringValue
                        //                        self.thisId = subJson["id"].int!
                        //                        self.thisLatitude = subJson["latitude"].double!
                        //                        self.thisLongitude = subJson["longitude"].double!
                        //                        self.thisName = subJson["name"].stringValue
                        //                        self.thisNotes = subJson["notes"].stringValue
                        //                        self.thisPhone = subJson["phone"].stringValue //int or string? show number to dial
                        //                        self.thisWebsite = subJson["website"].stringValue
                        //                        self.thisState = subJson["state"].stringValue
                        //                        self.thisType = subJson["type"].stringValue
                        //                        self.thisTitle = subJson["name"].stringValue   //title required for object
                        //
                        //                        if self.thisType == self.chosenCat {
                        //                            self.nameArray.append(self.thisName)
                        //                            print("this name   \(self.thisName)" )
                        //                        } else {
                        //                            continue
                        //                        }
                        
                        // let business = Business(title: self.thisTitle, address: self.thisAddress, city: self.thisCity, id: self.thisId , latitude: self.thisLatitude, longitude: self.thisLongitude, name: self.thisName, notes: self.thisNotes, phone: self.thisPhone, state: self.thisState, type: self.thisType, website: self.thisWebsite, coordinate: CLLocationCoordinate2D(latitude: self.thisLatitude, longitude: self.thisLongitude))
                        
                        
                        //http://stackoverflow.com/questions/30676173/populating-table-cells-with-alamofire-data
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    }
                }
                print(self.chosenCat)
            case .Failure(let error):
                print("There was an error\(error)")
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("busCell", forIndexPath: indexPath) as UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = nameArray[indexPath.row]
        //
        //        var selectedCell = tableView.cellForRowAtIndexPath(indexPath)! as busCell
        //        performSegueWithIdentifier("showBusiness", sender: cell)
        
        
        return cell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "repairBusInfoSeg" {
            if let destination = segue.destinationViewController as? RepairCatBusInf {
                
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRowAtIndexPath(path!)
                //destination.chosenCat = (cell?.textLabel?.text!)!
                let cellText = (cell?.textLabel?.text!)!
                for item in jsonArray {
                    var thisName = item["bus_name"]
                    var thisID = item["bus_id"]
                    if (thisName).stringValue == cellText {
                        destination.chosenBusID = (thisID).int!
                        //print("this is chosencat \(thisID)")
                    }
                }
            }
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRowAtIndexPath(indexPath) {
            self.performSegueWithIdentifier("repairBusInfoSeg", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
