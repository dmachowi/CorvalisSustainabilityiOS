//
//  ReuseViewController.swift
//  proj4
//
//  Created by DREWCIFER on 2/14/16.
//  Copyright © 2016 dmm. All rights reserved.
//

import UIKit
import Alamofire

class ReuseViewController: UITableViewController {
    var jsonArray = [JSON] ()
    var nameArray=[String]()
    var url = "http://localhost:8888/sustain/app/api/reuseCategories.php"
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
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
}


