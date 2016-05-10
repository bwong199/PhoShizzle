//
//  DataFetch.swift
//  pho shizzle
//
//  Created by Ben Wong on 2016-04-12.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit
import CoreLocation

class DataFetch {
    var businesses: [Business]!
    
    func fetchZomatoData (latitude: Double, longitude: Double, page: Int, completionHandler:(success: Bool, error: String?, results: [Pho]) -> Void){
        
        let url = NSURL(string: "https://developers.zomato.com/api/v2.1/search?q=vietnamese&lat=\(latitude)&lon=\(longitude)&apikey=32cca5c64d799522c794ef24c5ebd21c&radius=20000&cuisines=vietnamese&start=\(page)")! ;
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url){(data, response, error) -> Void in
            if let data = data {
                //                print(urlContent)
                
                do {
                    let jsonResult =  try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    if jsonResult.count > 0 {
                        if let items = jsonResult["restaurants"] as? NSArray {
                            
                            
                            for item in items {
                                
                                if let restaurant = item["restaurant"] as? NSDictionary {
                                    
                                    
                                    //                                    down vote
                                    //                                    Is swift 2.0 is in the following way:
                                    //
                                    
                                    
                                    //                                    let userLocation:CLLocation = CLLocation(latitude: 11.11, longitude: 22.22)
                                    //                                    let phoLocation:CLLocation = CLLocation(latitude: 33.33, longitude: 44.44)
                                    //                                    let meters:CLLocationDistance = userLocation.distanceFromLocation(priceLocation)
                                    
                                    
                                    //                                    print()
                                    //                                    print(restaurant["user_rating"]!["aggregate_rating"]!!)
                                    //                                    print(restaurant["user_rating"]!["votes"]!!)
                                    
                                    
                                    //                                    for x in GlobalVariables.phoInfoList {
                                    //                                        if x.name != restaurant["name"]! as! String {
                                    
                                    
                                    
                                    let newPho = Pho()
                                    
                                    guard let phoName = restaurant["name"] as? String else{
                                        continue
                                    }
                                    newPho.name = phoName
                                    
                                    guard let zomatoURL = restaurant["url"] as? String else{
                                        continue
                                    }
                                    newPho.zURL = zomatoURL
                                    
                                    guard let rating = (restaurant["user_rating"]!["aggregate_rating"] as? String) else{
                                        continue
                                    }
                                    newPho.rating = rating
                                    
                                    guard let votes = restaurant["user_rating"]!["votes"] as? String else{
                                        continue
                                    }
                                    newPho.votes = votes
                                    guard let postalCode = restaurant["location"]!["zipcode"] as? String else{
                                        continue
                                    }
                                    newPho.postalCode = postalCode
                                    guard let city = restaurant["location"]!["city"] as? String else{
                                        continue
                                    }
                                    newPho.city = city
                                    
                                    guard let neighbourhood = restaurant["location"]!["address"] as? String else{
                                        continue
                                    }
                                    
                                    newPho.neighbourhood = neighbourhood
                                    
                                    guard let phoAddress = restaurant["location"]!["address"] as? String else{
                                        continue
                                    }
                                    
                                    newPho.address = phoAddress
                                    
                                    
                                    // Distance Calculation
                                    var phoLatitude = restaurant["location"]!["latitude"]!! as! String
                                    var phoLongitude = restaurant["location"]!["longitude"]!! as! String
                                    
                                    //                                    print("\(phoLatitude) \(phoLongitude)")
                                    
                                    var phoLatitudeD = Double(phoLatitude)
                                    var phoLongitudeD = Double(phoLongitude)
                                    
                                    var missingLatitude : Double = 0
                                    var missingLongitude : Double = 0
                                    
                                    let geocoder = CLGeocoder()
                                    if phoLatitude == "0.0000000000" && phoLongitude == "0.0000000000" || postalCode.isEmpty {
                                        geocoder.geocodeAddressString("\(phoAddress) \(city)", completionHandler: {(placemarks, error) -> Void in
                                            if((error) != nil){
                                                print("Error", error)
                                            }
                                            if let placemark = placemarks?.first {
//                                                print(placemark)
                                                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                                                //                                                print("Geocoded first \(coordinates.latitude) \(coordinates.longitude)")
                                                phoLatitudeD = coordinates.latitude
                                                phoLongitudeD = coordinates.longitude
                                                //                        
//                                                print("Geocoded second \(phoLatitudeD) \(phoLongitudeD)")
                                                
                                                missingLatitude = coordinates.latitude
                                                missingLongitude = coordinates.longitude

                                                newPho.latitude = missingLatitude
                                                newPho.longitude = missingLongitude
                                                
                                                
//                                                print("\(newPho.name) \(newPho.latitude) \(newPho.longitude)")
                                                
                                                let userLocation:CLLocation = CLLocation(latitude: GlobalVariables.userLatitude, longitude: GlobalVariables.userLongitude)
                                                let phoLocation:CLLocation = CLLocation(latitude: phoLatitudeD!, longitude: phoLongitudeD!)
                                                
                                                let phoDistance:CLLocationDistance = userLocation.distanceFromLocation(phoLocation)
                                                
                                                newPho.distanceFromUser = phoDistance / 1000
                                                
                                                newPho.postalCode = placemark.postalCode!
                                                print("Estimated Postal Code \(placemark.postalCode!)")
                                                GlobalVariables.phoInfoList.sortInPlace()
                                                
                                            }
                                        })
                                    } else {
                                        newPho.latitude = phoLatitudeD!
                                        newPho.longitude = phoLongitudeD!
                                        
                                        let userLocation:CLLocation = CLLocation(latitude: GlobalVariables.userLatitude, longitude: GlobalVariables.userLongitude)
                                        let phoLocation:CLLocation = CLLocation(latitude: phoLatitudeD!, longitude: phoLongitudeD!)
                                        
                                        let phoDistance:CLLocationDistance = userLocation.distanceFromLocation(phoLocation)
                                        
                                        newPho.distanceFromUser = phoDistance / 1000
                                        
                                        GlobalVariables.phoInfoList.sortInPlace()
                                    }
                                    
//                                    print("\(phoName) \(postalCode)")
//                                    print("\(phoName) - \(phoLatitudeD) \(phoLongitudeD)")
                                    
//                                      print("Pho Distance \(phoName) \(newPho.latitude) \(newPho.longitude) \(newPho.distanceFromUser)")
                                    
                                    if !GlobalVariables.phoInfoList.contains(newPho){
                                        GlobalVariables.phoInfoList.append(newPho)
                                        
                                        GlobalVariables.phoInfoList.sortInPlace()
                                        
                                        DataFetch().fetchGoogleData(phoName, latitude: phoLatitudeD!, longitude: phoLongitudeD! ){(success, error, results) in
                                            if success {
                                                
                                            } else {
                                                
                                            }
                                            
                                        }
                                    }
                                    
                                    //                                        }
                                    //                                    }
                                    
                                    let viewController = UIApplication.sharedApplication().windows[0].rootViewController?.childViewControllers[0] as? ViewController
                                    
                                    
                                    //                                    viewController?.tableView.reloadData()
                                    //                                    print("\(restaurant["name"]!)   \(restaurant["user_rating"]!["aggregate_rating"]!!)  \(restaurant["user_rating"]!["votes"]!!)")
                                    //                                    print("\(restaurant["location"]!["latitude"]!!)  \(restaurant["location"]!["longitude"]!!)" )
                                }
                                
                                //                                print(restaurant)
                                
                            }
                        }
                    }
                    
                    completionHandler(success: true, error: nil, results: [])
                    
                    //                                        print(jsonResult)
                    
                } catch {
                    print("JSON Serialization failed")
                }
                
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: nil, message:
                        "Failed to Download Data from Zomato", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    //                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
            
        }
        
        task.resume()
    }
    
    func fetchGoogleData(phoPlace: String, latitude : Double, longitude : Double,  completionHandler:(success: Bool, error: String?, results: [Pho]) -> Void){
        //        print(phoPlace)
        //
        let urlParamter = phoPlace.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        if let phoPlace = phoPlace as? String {
            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?&radius=10000&location=\(latitude),\(longitude)&type=restaurant&keyword=\(urlParamter)&key=AIzaSyAtq_jKJ6O-pM-wwvwpCx1n31yjwcI2cPI")!
            
            //            print(url)
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url){(data, response, error) -> Void in
                if let data = data {
                    
                    do {
                        let jsonResult =  try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        
                        if jsonResult.count > 0 {
                            
                            //                                                        print(jsonResult)
                            
                            if let items = jsonResult["results"] as? NSArray {
                                
                                
                                if  let items = items as? NSArray {
                                    for item in items {
                                        
                                        if let name = item["name"] as? String, let rating = item["rating"] as? Double, let phoAddress = item["vicinity"] as? String {
                                            
//                                            print("Google Rating \(phoPlace) \(name) \(rating)")
                                            
                                            for x in GlobalVariables.phoInfoList {
                                                
                                                //                                                print(x.address)
                                                //                                                print(phoAddress)
                                                
                                                if x.name.lowercaseString.substringToIndex(x.name.startIndex.advancedBy(2)) == name.lowercaseString.substringToIndex(name.startIndex.advancedBy(2))
                                                    
                                                    //                                                    &&  x.address.lowercaseString.substringToIndex(x.address.startIndex.advancedBy(4)) == phoAddress.lowercaseString.substringToIndex(phoAddress.startIndex.advancedBy(4))
                                                {
                                                    x.gRating = rating
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        completionHandler(success: true, error: nil, results: [])
                        
                    } catch {
                        print("JSON Serialization failed")
                    }
                    
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        let alertController = UIAlertController(title: nil, message:
                            "Failed to Download Data from Google Place", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        
                        //                    self.presentViewController(alertController, animated: true, completion: nil)
                    })
                }
                
            }
            
            task.resume()
            
        }
        
        
    }
}