//
//  HomeScreen.swift
//  HaircutApp
//
//  Created by CheckoutUser on 3/2/18.
//  Copyright © 2018 CheckoutUser. All rights reserved.
//

import UIKit
import MapKit

class HomeScreen: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initLocationManager()
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
