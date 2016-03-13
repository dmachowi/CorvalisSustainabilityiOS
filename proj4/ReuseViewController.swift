//
//  Reuse and Repair App -- iOS
//  Drew Matthew Machowicz
//  Allyce McWhorter
//  Andrew Pierno
//
//  Copyright © 2016 dmm. All rights reserved.
//
//  ReuseViewController.swift -- This view controller makes a JSON call to get
//  all of the categories under Reuse from the API. It then lists them all in a 
//  table. The user can choose one and see all the businesses in that category.

import UIKit
import Alamofire

class ReuseViewController: UITableViewController {
    //array to hold JSON objects
    var jsonArray = [JSON] ()
    //array to hold the names of categories
    var nameArray=[String]()
    //url to get resuse categories, must change after deployment
    var url = "http://localhost:8888/sustain/app/api/reuseCategories.php"
    var catID = 0
    var catName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //JSON GET call with Alamofire
        Alamofire.request(.GET, url).responseJSON{
            response in switch response.result{
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    //gets category ID and name
                    for(_, subJson):(String, JSON) in json {
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
    
    //func to keep track of how many items in the table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }

    //this function adds a table cell for each item
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CatCell", forIndexPath: indexPath) as UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = nameArray[indexPath.row]
        
        return cell
    }
    
    //this function is sends the name of the category to the next view controller
    //it uses the segue reuseSeg to send the cat id
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "reuseSeg" {
            if let destination = segue.destinationViewController as? ReuseCatBusinesses {
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRowAtIndexPath(path!)
                let cellText = (cell?.textLabel?.text!)!
                
                //user taps a cell, it takes the contents of that cell and uses that
                //to get its corresponding id to send
                for item in jsonArray {
                    var thisCatName = item["cat_name"]
                    var thisID = item["cat_id"]
                    if (thisCatName).stringValue == cellText {
                        destination.chosenCat = (thisID).int!
                    }
                }
            }
        }
    }
    
    //segue
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRowAtIndexPath(indexPath) {
            self.performSegueWithIdentifier("reuseSeg", sender: self)
        }
    }
}
