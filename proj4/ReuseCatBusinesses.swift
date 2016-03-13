//
//  Reuse and Repair App -- iOS
//  Drew Matthew Machowicz
//  Allyce McWhorter
//  Andrew Pierno
//
//  Copyright © 2016 dmm. All rights reserved.
//
//  ReuseCatBusinesses.swift -- This view controller displays all the businesses
//  within the chosen category

import UIKit
import MapKit
import Alamofire

class ReuseCatBusinesses: UITableViewController {
    //incoming categegory from previous VC
    var chosenCat = 0
    //array to hold JSON objects
    var jsonArray = [JSON] ()
    //array to hold busniess names
    var nameArray=[String]()
    //url to get reuse businesses, must change after deployment
    var url = "http://localhost:8888/sustain/app/api/reuseBusinesses.php"
    var catName = ""
    var busName = ""
    var busID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //JSON POST using Alamofire, parameters is the category ID from previous VC
        Alamofire.request(.POST, url, parameters: ["cat_id":chosenCat], encoding: .JSON).responseJSON{
            response in switch response.result{
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    //gets business info for businesses in category, adds to array
                    for(key, subJson):(String, JSON) in json {
                        print("this is key: \(key) and this is \(subJson)")
                        self.jsonArray.append(subJson)
                        self.catName = subJson["cat_name"].stringValue
                        self.busName = subJson["bus_name"].stringValue
                        self.busID = subJson["bus_id"].int!
                        self.nameArray.append(self.busName)
                        
                        //http://stackoverflow.com/questions/30676173/populating-table-cells-with-alamofire-data
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    }
                }
            case .Failure(let error):
                print("There was an error\(error)")
            }
        }
    }
    
    //keeps track of number of cells in table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    //puts names of each business into a single cell in the table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("busCell", forIndexPath: indexPath) as UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = nameArray[indexPath.row]
        
        return cell
    }

    //this function uses the business name chosen by the user and then gets its corresponding
    //id to send to the next VC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "reuseBusInfoSeg" {
            if let destination = segue.destinationViewController as? ReuseCatBusInf {
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRowAtIndexPath(path!)
                let cellText = (cell?.textLabel?.text!)!
                
                //use name of business to get id, sends
                //that to the next VC
                for item in jsonArray {
                    var thisName = item["bus_name"]
                    var thisID = item["bus_id"]
                    if (thisName).stringValue == cellText {
                        destination.chosenBusID = (thisID).int!
                    }
                }
            }
        }
    }
    
    //segue
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRowAtIndexPath(indexPath) {
            self.performSegueWithIdentifier("reuseBusInfoSeg", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
