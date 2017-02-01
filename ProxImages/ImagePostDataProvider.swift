//
//  ImagePostDataProvider.swift
//  ProxImages
//
//  Created by Lars Anderson on 1/30/17.
//  Copyright © 2017 theonlylars. All rights reserved.
//

import Foundation
import Alamofire

import CoreLocation

protocol ImagePostDataProvider {
    func imagePostsFor(location: CLLocationCoordinate2D, radius: CLLocationDistance, fitting: CGSize, completion: @escaping (([ImageLocationPost], Error?)->(Void)))
}

class WikimediaImagePostDataProvider : ImagePostDataProvider {
    let networkManager = SessionManager()
    let baseURL: URL = URL(string: "https://commons.wikimedia.org/w/api.php")!
    
    /**
     We will be adding:
     
     "ggsradius":500,
     "ggscoord":"51.5|11.95",
     
     to search at a particular location
     
     https://www.mediawiki.org/wiki/API:Imageinfo
     */
    let defaultParameters: Parameters = [
        "format":"json",
        "action":"query",
        "generator":"geosearch",
        "ggsprimary":"all",
        "ggsnamespace":6,
        "prop":"imageinfo",
        "iilimit":1,
        "iiprop":"url|user",
        "meta":"meta"
    ]
    
    func imagePostsFor(location: CLLocationCoordinate2D, radius: CLLocationDistance, fitting: CGSize, completion: @escaping (([ImageLocationPost], Error?)->(Void))) {
        var params = defaultParameters
        
        let coordinateString = "\(location.latitude)|\(location.longitude)"
        params["ggscoord"] = coordinateString
        params["ggsradius"] = radius
        params["iiurlwidth"] = fitting.width
        params["iiurlheight"] = fitting.height
        
        networkManager.request(baseURL, method: .get, parameters: params, headers: nil).responseJSON { (response) in
            
            // Process returned data off the main thread
            DispatchQueue.global(qos: .userInitiated).async {
                
                if let error = response.error {
                    DispatchQueue.main.async {
                        completion([], error)
                    }
                } else if let dict = response.result.value as? [String : Any],
                    let query = dict["query"] as? [String:Any],
                    let posts = query["pages"] as? [String:Any] {
                    
                    let postObjects = posts.flatMap { (pageKey, dict) -> ImageLocationPost? in
                        if let dict = dict as? [String : Any] {
                            do {
                                return try ImageLocationPost.from(data: dict)
                            } catch {
                                print("Error parsing object -- non-fatal error: (\(error)) -- \(dict)")
                                return nil
                            }
                        }
                        
                        return nil
                    }
                    
                    DispatchQueue.main.async {
                        completion(postObjects, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion([], nil)
                    }
                }
            }
        }
    }
}
