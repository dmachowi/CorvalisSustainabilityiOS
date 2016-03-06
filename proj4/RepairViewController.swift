//
//  RepairViewController.swift
//  proj4
//
//  Created by DREWCIFER on 2/14/16.
//  Copyright © 2016 dmm. All rights reserved.
//

import UIKit
import Alamofire

class RepairViewController: UITableViewController {
    var jsonArray = [JSON] ()
    var nameArray=[String]()
    var url = "http://localhost:8888/sustain/app/api/repairCategories.php"
    var catID = 0
    var catName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(.GET, url).responseJSON{
            response in switch response.result{
            case .Success:                
                if let value = response.result.value {
                    let json = JSON(value)
                    //print("JSON: \(json)")
                    
                    for(key, subJson):(String, JSON) in json {
                        self.jsonArray.append(subJson)
                        self.catID = subJson["cat_id"].int!
                        self.catName = subJson["cat_name"].stringValue
                        self.nameArray.append(self.catName)
                        
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CatCell", forIndexPath: indexPath) as UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "repairSeg" {
            if let destination = segue.destinationViewController as? RepairCatBusinesses {
                
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRowAtIndexPath(path!)
                //destination.chosenCat = (cell?.textLabel?.text!)!
                let cellText = (cell?.textLabel?.text!)!
                for item in jsonArray {
                    var thisCatName = item["cat_name"]
                    var thisID = item["cat_id"]
                    if (thisCatName).stringValue == cellText {
                        destination.chosenCat = (thisID).int!
                        print("this is chosencat \(thisID)")
                    }
                }
            }
            
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRowAtIndexPath(indexPath) {
            self.performSegueWithIdentifier("repairSeg", sender: self)
        }
        
    }
}


