//
//  Pho.swift
//  pho shizzle
//
//  Created by Ben Wong on 2016-04-11.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit



class Pho : Comparable{
    var name = ""
    var address = ""
    var postalCode = ""
    var phoneNumber = ""
    var rating = ""
    var votes = ""
    var distanceFromUser = 0.00
    var latitude = 0.00
    var longitude = 0.00
    var gRating = 0.00
    var yRating = 0.00
    var yVotes = 0
    
    
    init(){
        
    }

}

func < (lhs: Pho, rhs: Pho) -> Bool {
    return lhs.distanceFromUser < rhs.distanceFromUser
}

func == (lhs: Pho, rhs: Pho) -> Bool {
    return lhs.name == rhs.name
}