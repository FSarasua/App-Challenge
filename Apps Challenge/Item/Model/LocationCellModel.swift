//
//  LocationCellModel.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 21/04/2021.
//

import Foundation

class LocationCellModel {
    
    var title: String
    var isFirstItem: Bool
    
    init() {
        self.title = ""
        self.isFirstItem = false
    }
    
    init(title: String, isFirstItem: Bool, isLastItem: Bool) {
        self.title = title
        self.isFirstItem = isFirstItem
    }
}
