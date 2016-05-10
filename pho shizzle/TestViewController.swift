//
//  TestViewController.swift
//  pho shizzle
//
//  Created by Test on 04/05/16.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Cosmos


class TestViewController: UIViewController {
var pho : Pho? = nil
    

    @IBOutlet weak var testTitleLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!

    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    @IBOutlet var zomatoRating: UILabel!

    @IBOutlet var zomatoCount: UILabel!
    
    @IBOutlet var yelpRating: UIImageView!
    
    @IBOutlet var yelpCount: UILabel!
    @IBOutlet var googleStars: CosmosView!
    
    @IBOutlet weak var savePhoButton: UIButton!
    
    @IBAction func openYelpReviews(sender: AnyObject) {
        
        if let url = NSURL(string: "\(pho!.mobileURL)") {
            print(url)
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func openZomatoReviews(sender: AnyObject) {
        if let url = NSURL(string: "\(pho!.zURL)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    @IBOutlet var openYelpReviews: UIButton!
    
    @IBOutlet var testMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        print(pho?.latitude)
//        print(pho?.longitude)
//        print(pho?.mobileURL);
        print("Zomato Postal Code \(pho?.postalCode)")
        print("Yelp Postal Code \(pho?.yPostalCode)");
        
        self.testTitleLabel.text = self.pho!.name
        self.phoneLabel.text = String(self.pho!.phoneNumber)
        self.addressLabel.text = self.pho!.address
        
        
        self.zomatoCount.text =   "\(self.pho!.votes) votes"
        
        self.yelpCount.text =  "\(String(self.pho!.yVotes)) votes"
        
        
        self.zomatoRating.text = self.pho!.rating
        
        self.googleStars.rating = self.pho!.gRating
        
        switch(self.pho!.yRating){
        case (1):
            self.yelpRating.image = UIImage(named: "Yelp0")
        case (1.5):
            self.yelpRating.image = UIImage(named: "Yelp1h")
        case (2):
            self.yelpRating.image = UIImage(named: "Yelp2")
        case (2.5):
            self.yelpRating.image = UIImage(named: "Yelp2h")
        case (3):
            self.yelpRating.image = UIImage(named: "Yelp3")
        case (3.5):
            self.yelpRating.image = UIImage(named: "Yelp3h")
        case (4):
            self.yelpRating.image = UIImage(named: "Yelp4")
        case (4.5):
            self.yelpRating.image = UIImage(named: "Yelp4h")
        case (5):
            self.yelpRating.image = UIImage(named: "Yelp5")
        default:
            break;
        }
        
//        self.zomatolabel.text = "\(self.pho!.rating) - \(self.pho!.votes) reviews"
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
        
        self.testMapView.addAnnotation(annotation)
        
        self.testMapView.setRegion(region, animated: true)
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
//                print(results)
                self.savePhoButton.hidden = true
                
                for result in results as! [NSManagedObject] {
                    
                    
                }
            }
        } catch {
        }
    }

    @IBAction func getPhoTapped(sender: UIButton) {
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
    
    
    @IBAction func savePhoTapped(sender: UIButton) {
        
        self.savePhoButton.hidden = true
        
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
