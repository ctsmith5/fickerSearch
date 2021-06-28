//
//  Models.swift
//  FlickrSearch
//
//  Created by Colin Smith on 6/26/21.
//

import Foundation

struct FlickrResponse: Codable {
    var title: String
    var items: [FlickrItem]
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case items = "items"
    }
}

struct FlickrItem: Codable {
    var title: String
    var media: Media
    var tags: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case media = "media"
        case tags = "tags"
    }
}

struct Media: Codable{
    var value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "m"
    }
}

struct FlickerPhoto {
    var link: URL?
    var title: String
    var width: String
    var height: String
    var tags: String
}
