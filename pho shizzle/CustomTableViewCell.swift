//
//  CustomTableViewCell.swift
//  pho shizzle
//
//  Created by Ben Wong on 2016-04-14.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit
import Cosmos

class CustomTableViewCell : UITableViewCell{
    
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var distance: UILabel!

    
    @IBOutlet var zomatoRating: UILabel!
//    @IBOutlet var yelpStars: CosmosView!
    @IBOutlet var googleStars: CosmosView!
    
    @IBOutlet var yelpStars: UIImageView!
    
    @IBOutlet var zomatoCount: UILabel!
    @IBOutlet var yelpCount: UILabel!
}