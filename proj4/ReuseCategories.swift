//
//  ReuseCategories.swift
//  proj4
//
//  Created by DREWCIFER on 2/14/16.
//  Copyright © 2016 dmm. All rights reserved.
//

import Foundation
import UIKit

class reuseCategories {
    var catID: Int?
    var catName: String?
    
    init(json: NSDictionary){
        self.catID = json["cat_id"] as? Int
        self.catName = json["cat_name"] as? String
        
    }
    
}