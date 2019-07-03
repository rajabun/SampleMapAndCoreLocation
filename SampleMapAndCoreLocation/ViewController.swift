//
//  ViewController.swift
//  SampleMapAndCoreLocation
//
//  Created by Muhammad Rajab Priharsanto on 26/06/19.
//  Copyright © 2019 Muhammad Rajab Priharsanto. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{

    @IBOutlet weak var mapView: MKMapView!
    //bikin objek untuk location manager
    let locationManager = CLLocationManager()
    //let mapView = MKMapView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        checkLocationServices()
    }

    func checkLocationServices()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            setupLocationManager()
            checkLocationAuthorization()
        }
        else
        {
            //show alert ngasitau kalo dia ga ngaktifin location
        }
    }
    
    func setupLocationManager()
    {
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization()
    {
        switch CLLocationManager.authorizationStatus()
        {
        case.authorizedWhenInUse:
            // do map stuff
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case.denied:
            // show alert and suggest them to turn on location services
            break
        case.notDetermined:
            // ask for permission to use the location
            locationManager.requestWhenInUseAuthorization()
            break
        case.restricted:
            // tell them what's up, restricted ini kalo ditolak dari parental control untuk ganti status.
            break
        case.authorizedAlways:
            // sebaiknya ga trlalu digunakan karena sekarang user sangat menjaga privasinya.
            break
        default:
            break
        }
    }
    
    func centerViewOnUserLocation()
    {
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last
            else
        {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        annotation.title = "Green Office Park"
        annotation.subtitle = "BSD, Indonesia"
        mapView.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        checkLocationAuthorization()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if !(annotation is MKPointAnnotation)
        {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else
        {
            annotationView!.annotation = annotation
        }
        
        // Provide the annotation view's image.
        let pinImage = UIImage(named: "ForAnnotation")
        let resizedSize = CGSize(width: 50, height: 50)
        
        UIGraphicsBeginImageContext(resizedSize)
        pinImage?.draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        annotationView!.image = resizedImage
        
        return annotationView
    }

}

//let regionInMeters: Double = 10000

// Do any additional setup after loading the view.
/*
 // 1
 let location = CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402)
 //let location2 = MKMapView.
 //let location2 = MKUserLocation
 
 // 2
 let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
 let region = MKCoordinateRegion(center: location, span: span)
 mapView.setRegion(region, animated: true)
 
 //3
 let annotation = MKPointAnnotation()
 annotation.coordinate = location
 annotation.title = "Green Office Park"
 annotation.subtitle = "BSD, Indonesia"
 mapView.addAnnotation(annotation)
 */

//var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier)
//annotationView!.image = pinImage
