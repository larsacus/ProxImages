//
//  ViewController.swift
//  ProxImages
//
//  Created by Lars Anderson on 1/30/17.
//  Copyright © 2017 theonlylars. All rights reserved.
//

import UIKit
import MapKit

fileprivate enum MapViewSegues : String {
    case showPosts
}

//MARK: -

class MapViewController: UIViewController {
    
    private var locationManager: CLLocationManager = CLLocationManager()
    
    /**
     Typed convenience helper to return the subclassed
     UIView subclass. Force-unwrapping here since if this
     value is nil, we are calling this code before
     viewDidLoad has been called -- which should be
     a programming error.
     */
    var radiusMapView: RadiusMapView! {
        get {
            return viewIfLoaded as! RadiusMapView
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        handleLocationPermissions()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let identifier = segue.identifier,
            let namedSegue = MapViewSegues(rawValue: identifier) else {
                preconditionFailure("Unknown or missing segue name: \(segue.identifier)")
        }
        
        switch namedSegue {
        case .showPosts:
            if let postVC = segue.destination as? ImagesViewController {
                postVC.center = radiusMapView.currentSearchCenter
                postVC.radius = radiusMapView.currentRadius
            } else {
                assertionFailure("View controller for segue \"\(namedSegue)\" was incorrect: \(segue.destination)")
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: view)
        let tappedCoordinate = radiusMapView.handleMapTapAt(location: location, in: view)
        
        // Center the user where they tapped
        radiusMapView.mapView.setCenter(
            tappedCoordinate,
            animated: true
        )
        
        /**
         This is pretty gross, but why MKMapView does not have a
         completion block for map animation transactions -- not sure.
         */
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.performSegue(
                withIdentifier: MapViewSegues.showPosts.rawValue,
                sender: self
            )
        }
    }
    
    //MARK: - Location
    
    private func handleLocationPermissions() {
        let existingAuthStatus = CLLocationManager.authorizationStatus()
        switch (existingAuthStatus) {
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse: break
        // do nothing -- MapView handles location from here on out
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied: fallthrough
        case .restricted:
            // do nothing -- user does not want us to know where they are
            break
        }
    }
}
