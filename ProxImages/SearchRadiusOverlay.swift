//
//  SearchRadiusOverlay.swift
//  ProxImages
//
//  Created by Lars Anderson on 1/31/17.
//  Copyright © 2017 theonlylars. All rights reserved.
//

import Foundation
import MapKit

class SearchRadiusOverlay : NSObject, MKOverlay {
    
    /** Search radius. Default to 1km */
    public var radius: CLLocationDistance = 1000
    
    init(radius: CLLocationDistance, center: CLLocationCoordinate2D) {
        self.radius = radius
        self.coordinate = center
    }
    
    //MARK: MKOverlay
    public let coordinate: CLLocationCoordinate2D
    public var boundingMapRect: MKMapRect {
        get {
            return coordinate.centeredCircleRect(withRadius: radius)
        }
    }
}
