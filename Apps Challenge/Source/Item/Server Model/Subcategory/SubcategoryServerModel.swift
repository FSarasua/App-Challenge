//
//  SubcategoryServerModel.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 04/05/2021.
//

import Foundation

struct SubcategoryServerModel: Codable {
    var idSubcategory: String?
    var idParent: String?
    var name: String?
    var normalizedName: String?
    var definition: String?
    var childCount: Int?
    var children: String?
    var icon: String?
    
    enum CodingKeys: String, CodingKey {
        case idSubcategory = "id"
        case idParent = "parent_id"
        case name = "name"
        case normalizedName = "normalized_name"
        case definition = "description"
        case childCount = "child_count"
        case children = "children"
        case icon = "icon"
    }
}
