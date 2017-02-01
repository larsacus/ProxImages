//
//  ImageLocationPostParsing.swift
//  ProxImages
//
//  Created by Lars Anderson on 1/30/17.
//  Copyright © 2017 theonlylars. All rights reserved.
//

import Foundation

/**
 {
     "pageid": 8771242,
     "ns": 6,
     "title": "File:Celsius Bryant Park jeh.jpg",
     "index": 0,
     "imagerepository": "local",
     "imageinfo": [
         {
         "thumburl": "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/Celsius_Bryant_Park_jeh.jpg/200px-Celsius_Bryant_Park_jeh.jpg",
         "thumbwidth": 200,
         "thumbheight": 164,
         "url": "https://upload.wikimedia.org/wikipedia/commons/b/b2/Celsius_Bryant_Park_jeh.jpg",
         "descriptionurl": "https://commons.wikimedia.org/wiki/File:Celsius_Bryant_Park_jeh.jpg",
         "descriptionshorturl": "https://commons.wikimedia.org/w/index.php?curid=8771242"
         }
     ]
 }
 */


private enum ImageLocationPostKey : String {
    case imageinfo
    case username = "user"
    case thumburl
}

enum ImageLocationPostDataField : String {
    case username, distance, thumbnailURL, imageURL, imageData
}

enum ImageLocationPostError : Error {
    case MissingData(ImageLocationPostDataField)
}

extension ImageLocationPost {
    static func from(data: [String:Any]) throws -> ImageLocationPost {
        
        guard let imageInfoArray = data[ImageLocationPostKey.imageinfo.rawValue] as? [[String : Any]],
            let imageInfo = imageInfoArray.first else {
            throw ImageLocationPostError.MissingData(.imageData)
        }
        
        /** Parse username data */
        guard let usernameString = imageInfo[ImageLocationPostKey.username.rawValue] as? String else {
            throw ImageLocationPostError.MissingData(.username)
        }
        
        /** Parse thumbnail data */
        guard let thumbnailImageURLString = imageInfo[ImageLocationPostKey.thumburl.rawValue] as? String,
            let thumbnailImageURL = URL(string: thumbnailImageURLString) else {
                throw ImageLocationPostError.MissingData(.thumbnailURL)
        }
        
        return ImageLocationPost(
            distance: 0.0,
            username: usernameString,
            thumbnailURL: thumbnailImageURL
        )
    }
}

