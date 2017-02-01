//
//  InstagramDataSource.swift
//  ProxImages
//
//  Created by Lars Anderson on 1/30/17.
//  Copyright © 2017 theonlylars. All rights reserved.
//

import UIKit
import CoreLocation
import AlamofireImage
import Alamofire

class InstagramDataSource: NSObject, UICollectionViewDataSource {
    
    var posts: [ImageLocationPost] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? ImageLocationPostCollectionViewCell else {
            
            preconditionFailure("This is a programmer error -- register your PostCell with the collection view before running!")
        }
        
        prepare(cell: cell, with: posts[indexPath.item])
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    private func prepare(cell: ImageLocationPostCollectionViewCell, with post: ImageLocationPost) {
        cell.distance = post.distance
        cell.username = post.username
        cell.identifier = post.thumbnailURL.absoluteString
        
        Alamofire.request(post.thumbnailURL).responseImage { response in
            
            // To prevent assigning an image to a cell that's already been reused
            if let image = response.result.value, cell.identifier == post.thumbnailURL.absoluteString {
                UIView.transition(
                    with: cell,
                    duration: 0.25,
                    options: .transitionCrossDissolve,
                    animations: {
                        cell.image = image
                }, completion: nil)
            }
        }
    }
}
