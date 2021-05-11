//
//  LocationServerModel.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 03/05/2021.
//

import Foundation

struct LocationServerModel: Codable {
    var idLocation: Int?
    var idParent: Int?
    var name: String?
    var normalizedDistrict: String?
    var normalizedCity: String?
    var normalizedState: String?
    var zip: String?
    var geoLat: Double?
    var level: Int?
    var geoLng: Double?
    var children: String?
    var slug: String?
    
    enum CodingKeys: String, CodingKey {
        case idLocation = "id"
        case idParent = "parent_id"
        case name = "name"
        case normalizedDistrict = "normalized_district"
        case normalizedCity = "normalized_city"
        case normalizedState = "normalized_state"
        case zip = "zip"
        case geoLat = "geo_lat"
        case level = "level"
        case geoLng = "geo_lng"
        case children = "children"
        case slug = "slug"
    }
}
