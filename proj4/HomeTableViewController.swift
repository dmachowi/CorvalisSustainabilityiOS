//
//  FruitsTableViewController.swift
//  proj4
//
//  Created by DREWCIFER on 2/8/16.
//  Copyright © 2016 dmm. All rights reserved.
// https://www.ralfebert.de/tutorials/ios-swift-uitableviewcontroller/#storyboard_table_contents

import UIKit

class HomeTableViewController: UITableViewController {

    var data = ["Recycling", "Reuse", "Repair", "Map"]
    
    // MARK: - UITableViewDataSource
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.editing = true
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let movedObject = self.data[sourceIndexPath.row]
        data.removeAtIndex(sourceIndexPath.row)
        data.insert(movedObject, atIndex: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath) => \(destinationIndexPath.row) \(data)")
        //to check for correctness enable self.tableView.reloadData()
    }
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) 
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
}
