//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import Foundation


struct Business: Decodable {
    let id: String
    let name: String
    let imageURL: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
        case url
    }
}

struct BusinessesList: Decodable {
    let businesses: [Business]
    let total: Int
}
