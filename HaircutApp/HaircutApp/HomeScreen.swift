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
import CoreLocation
import GeoFire

class HomeScreen: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var annotations = [MKPointAnnotation]()
    var databaseRef : DatabaseReference?
    var barbers : Barbers?
    var geoFire : GeoFire?
    var regionQuery : GFRegionQuery?
    let coordinatesSLO = CLLocationCoordinate2D(latitude: 35.2828, longitude: -120.6596)
    let barberData = "https://api.foursquare.com/v2/venues/search?client_id=ZKJ1MMDJU5SI5JL10UDBLDWLDSB0ZHCWXZFMRASNX1RBIB1A&client_secret=KCMAVC1ZZFSQS25TIUDE4KTGFPVEFZOXYB13PWC5X3UBCKIV&ll=35.3,-120.6&query=barber&v=20180301"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference().child("response")
        mapView.delegate = self
        
        geoFire = GeoFire(firebaseRef: Database.database().reference().child("GeoFire"))
        
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
        
        configureLocationManager()
        
        let span = MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
        let newRegion = MKCoordinateRegion(center: coordinatesSLO, span: span)
        mapView.setRegion(newRegion, animated: true)
        
        oneTimeInit()
    }
    
    // Segues
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {}
    
    @IBAction func toProfileScreen(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toProfileScreen", sender: self)
    }
    
    @IBAction func toCreateHaircutSeshScreen(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toCreateHaircutSesh", sender: self)
    }
    
    // One Time Init
    func oneTimeInit() {
        databaseRef?.queryOrdered(byChild: "response").observe(.value, with:
            { snapshot in
                
                var newBarbers = [BarbersClass]()
                
                for item in snapshot.children {
                    newBarbers.append(BarbersClass(snapshot: item as! DataSnapshot))
                }
                
                for next in newBarbers {
                    self.geoFire?.setLocation(CLLocation(latitude:next.latitude,longitude:next.longitude), forKey: next.name)
                }
        })
    }
    
    // Map Functions
    func configureLocationManager() {
        CLLocationManager.locationServicesEnabled()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = 1.0
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        
        updateRegionQuery()
    }
    
    func updateRegionQuery() {
        if let oldQuery = regionQuery {
            oldQuery.removeAllObservers()
        }
        
        regionQuery = geoFire?.query(with: mapView.region)
        
        regionQuery?.observe(.keyEntered, with: { (key, location) in
            self.databaseRef?.queryOrderedByKey().queryEqual(toValue: key).observe(.value, with: { snapshot in
                
                let newBarber = BarbersClass(key:key, snapshot:snapshot)
                self.addBarber(newBarber)
            })
        })
    }
    
    func addBarber(_ barber : BarbersClass) {
        DispatchQueue.main.async {
            self.mapView.addAnnotation(barber)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is BarbersClass {
            let annotationView = MKPinAnnotationView()
            annotationView.pinTintColor = .red
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            annotationView.animatesDrop = true
            
            // Disclosure button
            let button = UIButton(type: UIButtonType.detailDisclosure) as UIButton
            
            annotationView.rightCalloutAccessoryView = button
            
            return annotationView
        }
        
        return nil
    }
    
    // Segues
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        performSegue(withIdentifier: "toBusinessInfo", sender: view.annotation?.title ?? "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBusinessInfo"{
            let destVC = segue.destination as! BusinessInfoScreen
            
            destVC.keyBarberName = sender as? String
        }
    }
    

}
