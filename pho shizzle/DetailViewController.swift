//
//  DetailViewController.swift
//  pho shizzle
//
//  Created by Ben Wong on 2016-04-14.
//  Copyright © 2016 Ben Wong. All rights reserved.
//


import UIKit
import MapKit
import CoreData

class DetailViewController: UIViewController  {
    
    var pho : Pho? = nil
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var phoneLabel: UILabel!
    
    @IBOutlet var addressLabel: UILabel!
    

    

    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(pho?.mobileURL);
        print(pho?.zURL)
        
        // We need just to get the documents folder url
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        
        
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel.text = self.pho!.name
        self.phoneLabel.text = String(self.pho!.phoneNumber)
        self.addressLabel.text = self.pho!.address
        
//        self.zomatoLabel.text = "\(self.pho!.rating) - \(self.pho!.votes) reviews"
//        
//        self.googleLabel.text = "\(self.pho!.gRating)"
//        
//        self.yelpLabel.text = "\(self.pho!.yRating) - \(self.pho!.yVotes) reviews"
        
        let latitudeAnn:CLLocationDegrees = self.pho!.latitude
        let longitudeAnn:CLLocationDegrees = self.pho!.longitude
        
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeAnn, longitudeAnn)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        
        self.mapView.addAnnotation(annotation)
        
        self.mapView.setRegion(region, animated: true)
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Restaurant")
        //        request.predicate = NSPredicate(format: "latitude = %@", latitude)
        let firstPredicate = NSPredicate(format: "name = %@", "\(self.pho!.name)")
        let secondPredicate = NSPredicate(format: "address = %@", "\(self.pho!.address)")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [firstPredicate, secondPredicate])
        
        do {
            
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                print(results)
                self.saveButton.hidden = true
                
                for result in results as! [NSManagedObject] {
                    
                    
                }
            }
        } catch {
        }
    }
    
    
    @IBAction func initDirection(sender: AnyObject) {
        
        
        
        let latitudeAnn:CLLocationDegrees = self.pho!.latitude
        let longitudeAnn:CLLocationDegrees = self.pho!.longitude
        
        let coordinates:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeAnn, longitudeAnn)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "\(self.pho!.name)"
        
        
        
        dispatch_async(dispatch_get_main_queue(),{
            
            mapItem.openInMapsWithLaunchOptions(launchOptions)
            
        })
        
        
    }
    
    @IBAction func savePho(sender: AnyObject) {
        
        self.saveButton.hidden = true
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let newRestaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: context)
        
        newRestaurant.setValue(self.pho!.latitude, forKey: "latitude")
        
        newRestaurant.setValue(self.pho!.longitude, forKey: "longitude")
        
        newRestaurant.setValue(self.pho!.name, forKey: "name")
        
        newRestaurant.setValue(self.pho!.phoneNumber, forKey: "phone")
        
        newRestaurant.setValue(self.pho!.address, forKey: "address")
        
        do {
            try context.save()
        } catch {
            print("There was a problem")
        }
    }
    
}