//
//  LocationCellModel.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 21/04/2021.
//

import Foundation

class LocationCellModel {
    
    var title: String
    var isLastItem: Bool
    
    init() {
        self.title = ""
        self.isLastItem = false
    }
    
    init(title: String, isLastItem: Bool) {
        self.title = title
        self.isLastItem = isLastItem
    }
}
