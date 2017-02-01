//
//  RadiusMapView.swift
//  ProxImages
//
//  Created by Lars Anderson on 1/30/17.
//  Copyright © 2017 theonlylars. All rights reserved.
//

import UIKit

import MapKit

class RadiusMapView : UIView, MKMapViewDelegate {
    
    @IBOutlet weak private(set) var mapView: MKMapView!
    @IBOutlet weak private(set) var radiusSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    
    private var hasInitialLocation: Bool = false
    private var circleOverlay: SearchRadiusOverlay?
    private let distanceFormatter = MKDistanceFormatter()
    
    internal private(set) var currentSearchCenter: CLLocationCoordinate2D?
    internal var userHasControlOfMap: Bool = false
    
    internal private(set) var currentRadius: CLLocationDistance = 1000 {
        didSet {
            if distanceLabel != nil {
                distanceLabel.text = distanceFormatter.string(fromDistance: currentRadius)
            }
        }
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /** Update our UI with our initial code values */
        radiusSlider.value = Float(currentRadius)
        distanceLabel.text = distanceFormatter.string(fromDistance: currentRadius)
    }
    
    //MARK: - Actions
    
    @IBAction func distanceSliderChanged(_ sender: UISlider) {
        currentRadius = CLLocationDistance(sender.value)
        
        updateRadiusOverlayForCurrent()
    }
    
    func handleMapTapAt(location: CGPoint, in view: UIView) -> CLLocationCoordinate2D{
        
        let coordinate = mapView.convert(location, toCoordinateFrom: view)
        
        currentSearchCenter = coordinate
        userHasControlOfMap = false
        
        updateRadiusOverlayForCenter(
            coordinate,
            radius: currentRadius
        )
        
        return coordinate
    }
    
    //MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        hasInitialLocation = true
        
        if userHasControlOfMap == false {
            let rect = userLocation.coordinate.centeredCircleRect(withRadius: currentRadius)
            mapView.setVisibleMapRect(rect, animated: true)
            
            self.currentSearchCenter = userLocation.coordinate
        }
        
        updateRadiusOverlayForCenter(
            userLocation.coordinate,
            radius: currentRadius
        )
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let radiusOverlay = overlay as? SearchRadiusOverlay {
            let circle = MKCircle(
                center: radiusOverlay.coordinate,
                radius: radiusOverlay.radius
            )
            let renderer = MKCircleRenderer(circle: circle)
            renderer.fillColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.2498604911)
            renderer.strokeColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5)
            renderer.lineWidth = 1.0
            
            return renderer
        }
        
        preconditionFailure("Developer error -- don't know what to do with this overlay: \(overlay)")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // Don't draw prematurely
        if hasInitialLocation {
            
            /**
             If we have an initial location and we get here
             unanimated, the user is probably moving the map manually
             */
            userHasControlOfMap = !animated
            
            updateRadiusOverlayForCurrent()
        }
    }
    
    //MARK: - Helpers
    
    private func updateRadiusOverlayForCenter(_ location: CLLocationCoordinate2D, radius: CLLocationDistance) {
        if let circleOverlay = circleOverlay {
            mapView.remove(circleOverlay)
        }
        
        circleOverlay = SearchRadiusOverlay(
            radius: radius,
            center: location
        )
        
        mapView.add(circleOverlay!)
    }
    
    private func updateRadiusOverlayForCurrent() {
        updateRadiusOverlayForCenter(
            currentSearchCenter ?? mapView.centerCoordinate,
            radius: currentRadius
        )
    }
}

//MARK: - CLLocationCoordinate2D

extension CLLocationCoordinate2D {
    func centeredCircleRect(withRadius radius: CLLocationDistance) -> MKMapRect {
        
        let circle = MKCircle(center: self, radius: radius)
        
        return circle.boundingMapRect
    }
}
