//
//  SubcategoryCellModel.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 04/05/2021.
//

import Foundation

class SubcategoryPickerModel {
    var idSubcategory: String
    var idParent: String
    var title: String
    
    init() {
        self.idSubcategory = ""
        self.idParent = ""
        self.title = ""
    }
    
    init(idSubcategory: String, idParent: String, title: String) {
        self.idSubcategory = idSubcategory
        self.idParent = idParent
        self.title = title
    }
    
    init(serverModel: SubcategoryServerModel) {
        self.idSubcategory = serverModel.idSubcategory ?? ""
        self.idParent = serverModel.idParent ?? ""
        self.title = serverModel.name ?? ""
    }
}
