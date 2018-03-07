//
//  HomeScreen.swift
//  HaircutApp
//
//  Created by CheckoutUser on 3/2/18.
//  Copyright © 2018 CheckoutUser. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase


class HomeScreen: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var annotations = [MKPointAnnotation]()
    var databaseRef : DatabaseReference?
    var barbers : Barbers?
    
    let currentLatitude = 35.300066
    let currentLongitude = -120.662065
    let client_id = "ZKJ1MMDJU5SI5JL10UDBLDWLDSB0ZHCWXZFMRASNX1RBIB1A"
    let client_secret = "KCMAVC1ZZFSQS25TIUDE4KTGFPVEFZOXYB13PWC5X3UBCKIV"
    let venue_id = "4bf58dd8d48988d110951735"
    
    let barberData = "https://api.foursquare.com/v2/venues/search?client_id=ZKJ1MMDJU5SI5JL10UDBLDWLDSB0ZHCWXZFMRASNX1RBIB1A&client_secret=KCMAVC1ZZFSQS25TIUDE4KTGFPVEFZOXYB13PWC5X3UBCKIV&ll=35.3,-120.6&query=barber&v=20180301"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initLocationManager()
        
        databaseRef = Database.database().reference().child("response")
        
        mapView.delegate = self
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let request = URLRequest(url: URL(string: barberData)!)
        
        let task: URLSessionDataTask = session.dataTask(with: request)
        { (receivedData, response, error) -> Void in
            
            if let data = receivedData {
                do {
                    let decoder = JSONDecoder()
                    let haircutVenueService = try decoder.decode(HaircutVenueService.self, from: data)
                    self.barbers = haircutVenueService.response
                    
                    for barber in (self.barbers?.venues)! {
                        print(barber.name!)
                        self.databaseRef?.child(barber.name!).setValue(barber.toAnyObject())
                    }
                    
                } catch {
                    print("Exception on Decode: \(error)")
                }
            }
        }
        task.resume()
    }
    
    // Segues
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {}
    
    @IBAction func toProfileScreen(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toProfileScreen", sender: self)
    }
    
    @IBAction func toCreateHaircutSeshScreen(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toCreateHaircutSesh", sender: self)
    }
    
    // Map Functions
    func initLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("didUpdate")
        let mostRecent = locations.last!
        
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = mostRecent.coordinate
        
        annotations.append(newAnnotation)
        
        if UIApplication.shared.applicationState == .active {
            mapView.showAnnotations(annotations, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
