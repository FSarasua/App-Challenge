//
//  CreateBudget.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 03/05/2021.
//

import Foundation

class CreateBudgetViewModel {
    var tableData: [LocationCellModel]
    var pickerData: [String]
    
    init() {
        self.tableData = []
        self.pickerData = []
    }
    
    init(tableData: [LocationCellModel], pickerData: [String]) {
        self.tableData = tableData
        self.pickerData = pickerData
    }
}
