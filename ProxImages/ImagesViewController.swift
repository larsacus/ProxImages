//
//  ImagesViewController.swift
//  ProxImages
//
//  Created by Lars Anderson on 1/30/17.
//  Copyright © 2017 theonlylars. All rights reserved.
//

import UIKit
import CoreLocation

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView?
    
    private let dataProvider: ImagePostDataProvider = WikimediaImagePostDataProvider()
    private let dataSource: InstagramDataSource = InstagramDataSource()

    /**
     These parameters will be passed in at segue time
     */
    var center: CLLocationCoordinate2D!
    var radius: CLLocationDistance!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use our abstracted data source
        collectionView?.dataSource = dataSource
        
        // Need to request image sizes that both fit into our current container and are returned
        //  in the correct retina scale
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let screenScale = UIScreen.main.scale
        let imageSize = CGSize(
            width: flow.itemSize.width * screenScale,
            height: flow.itemSize.height * screenScale
        )
        
        dataProvider.imagePostsFor(location: center!, radius: radius, fitting: imageSize) { (posts, error) in
            self.dataSource.posts = posts
            
            self.collectionView?.reloadData()
        }
    }
}
