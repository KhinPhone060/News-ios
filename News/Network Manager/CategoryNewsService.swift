//
//  CategoryNewsService.swift
//  News
//
//  Created by Khin Phone Ei on 03/02/2023.
//

import Foundation
import Alamofire
import ObjectMapper

final class CategoryNewsService {
    func fetchCategoryNews(completionHandler: @escaping (_ categoryNewsList: [CategoryNews]) -> Void, category: String) {
        let url = "https://newsapi.org/v2/top-headlines?country=sg&apiKey=5c9bb4e194434ab281fb1b329fad774d&category=\(category)"
        
        AF.request(url, encoding: JSONEncoding.default)
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        if let resultDict = value as? [String: Any],
                           let articleDict = resultDict["articles"] as? [[String: Any]]
                        {
                            if let categoryNewsList = Mapper<CategoryNews>().mapArray(JSONObject: articleDict) {
                                completionHandler(categoryNewsList)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
    }
    
}
