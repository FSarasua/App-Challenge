//
//  CategoryCellModel.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 04/05/2021.
//

import Foundation

class CategoryPickerModel {
    var idCategory: String
    var title: String
    
    init() {
        self.idCategory = ""
        self.title = ""
    }
    
    init(idCategory: String, title: String) {
        self.idCategory = idCategory
        self.title = title
    }
    
    init(serverModel: CategoryServerModel) {
        self.idCategory = serverModel.idCategory ?? ""
        self.title = serverModel.name ?? ""
    }
}
