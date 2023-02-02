//
//  News.swift
//  News
//
//  Created by Khin Phone Ei on 02/02/2023.
//

import Foundation
import ObjectMapper

struct News: Mappable {
    
    var title: String?
    var imageURL: String?
    var url: String?
    
    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        title <- map["title"]
        imageURL <- map["urlToImage"]
        url <- map["url"]
    }
}
