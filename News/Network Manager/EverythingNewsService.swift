//
//  EverythingNewsService.swift
//  News
//
//  Created by Khin Phone Ei on 04/02/2023.
//

import Foundation
import Alamofire
import ObjectMapper

final class EverythingNewsService {
    func fetchEverythingNews(completionHandler: @escaping (_ everythingNewslist: [EverythingNews]) -> Void, keyword: String) {
        let url = "https://newsapi.org/v2/everything?q=\(keyword)&apiKey=ff41e86b7f3b47ebb8eba4ecd7e29f59&language=en"
        
        AF.request(url, encoding: JSONEncoding.default)
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        if let resultDict = value as? [String: Any],
                           let articleDict = resultDict["articles"] as? [[String: Any]]
                        {
                            if let everythingNewsList = Mapper<EverythingNews>().mapArray(JSONObject: articleDict) {
                                completionHandler(everythingNewsList)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
    }
    
}
