//
//  CreateBudget.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 03/05/2021.
//

import Foundation

class CreateBudgetBusinessModel {
    var completeLocationCellModels: [LocationCellModel]
    var categoryCellModels: [CategoryPickerModel]
    var subcategoryCellModels: [SubcategoryPickerModel]
    
    init() {
        self.completeLocationCellModels = []
        self.categoryCellModels = []
        self.subcategoryCellModels = []
    }
    
    init(completeLocationCellModels: [LocationCellModel], categoryCellModels: [CategoryPickerModel], subcategoryCellModels: [SubcategoryPickerModel]) {
        self.completeLocationCellModels = completeLocationCellModels
        self.categoryCellModels = categoryCellModels
        self.subcategoryCellModels = subcategoryCellModels
    }
}
