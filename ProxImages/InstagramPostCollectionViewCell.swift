//
//  ImageLocationPostCollectionViewCell.swift
//  ProxImages
//
//  Created by Lars Anderson on 1/30/17.
//  Copyright © 2017 theonlylars. All rights reserved.
//

import UIKit

import MapKit.MKDistanceFormatter

class ImageLocationPostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    var identifier: String = ""
    
    private let distanceFormatter = MKDistanceFormatter()
    
    var distance: CLLocationDistance = 0.0 {
        didSet {
            if distance > 0 {
                distanceLabel.text = distanceFormatter.string(fromDistance: distance)
            } else {
                distanceLabel.text = nil
            }
        }
    }
    
    var username: String? {
        didSet {
            usernameLabel.text = username
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        /**
         Reset our custom values for cell reuse
         */
        username = nil
        distance = 0.0
        imageView.image = nil
    }
}
