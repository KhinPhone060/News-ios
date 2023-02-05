//
//  CategoryNews.swift
//  News
//
//  Created by Khin Phone Ei on 03/02/2023.
//

import Foundation
import ObjectMapper

class CategoryNews: Mappable {
    var title: String?
    var description: String?
    var imageURL: String?
    var url: String?
    
    required init?(map: Map) {

    }

    // Mappable
    func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        imageURL <- map["urlToImage"]
        url <- map["url"]
    }
}
