//
//  YelpManager.swift
//  WeedmapsChallenge
//
//  Created by Perez Willie-Nwobu on 3/5/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//

import Foundation
import Alamofire

class YelpManager {
    
    private let baseURL = "https://api.yelp.com/v3"
    let authHeader = ["Authorization": "Bearer 65n_kH2_5j5dUW52QqgLeEYjr3fR3_RKNNp442dJYHfXSFP7RrOCc-wtlNXKnVxcYTo5WO48mZkSusuzKuwMnKuKvBdS13hY-oaDisOiwWrCmpBzXSyWOyiqlQ1DXnYx"]
    
    private var imageCache = Cache<String, UIImage>()
    private var currentTotal = 0
    var searchCache = Cache<String, BusinessesList>()
    var searchTermHistory: [String] = []
    
    @discardableResult
    func search(term: String, latitude: String, longitude: String, page: Int, isNewTerm: Bool = true, completion: @escaping ([Business]?, Error?) -> Void) -> DataRequest? {
        if page == 1, let businesses = searchCache[term] {
            currentTotal = businesses.total
            completion(businesses.businesses, nil)
        }
        guard var url = URL(string: baseURL) else { return nil }
        let offset = (page - 1) * 15
        if !isNewTerm && offset >= currentTotal { completion(nil, nil); return nil }
        url.appendPathComponent(.appendPathComponent1)
        url.appendPathComponent(.appendPathComponent2)
        let queries = [.term : term, .latitude: latitude, .longtitude: longitude, "limit": .limit, "offset": "\(offset)"]
        let request = Alamofire.request(url, parameters: queries, headers: authHeader)
            .responseData() { response in
                switch response.result {
                case .success(let data):
                    let businesses = try? JSONDecoder().decode(BusinessesList.self, from: data)
                    if page == 1 {
                        self.searchTermHistory.append(term)
                        self.searchCache[term] = businesses
                    }
                    self.currentTotal = businesses?.total ?? 0
                    completion(businesses?.businesses, nil)
                    return
                case .failure(let error):
                    completion(nil, error)
                    return
                }
        }
        return request
    }
    
    func getImage(for business: Business, completion: @escaping (UIImage?) -> Void) {
        if let image = imageCache[business.id] {
            completion(image)
            return
        } else {
            Alamofire.request(business.imageURL)
                .responseData() { resp in
                    guard let data = resp.data else { completion(nil); return }
                    let image = UIImage(data: data)
                    self.imageCache[business.id] = image
                    completion(image)
            }
        }
    }
}
