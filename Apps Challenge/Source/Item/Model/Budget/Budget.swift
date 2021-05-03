//
//  Budget.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 02/05/2021.
//

import Foundation

class BudgetListModel {
    var cellModels: [BudgetCellModel]
    
    init() {
        self.cellModels = []
    }
    
    init(cellModels: [BudgetCellModel]) {
        self.cellModels = cellModels
    }
}

class BudgetCellModel {
    var name: String
    var phone: String
    var email: String
    var definition: String
    
    init() {
        self.name = ""
        self.phone = ""
        self.email = ""
        self.definition = ""
    }
    
    init(budget: Budget) {
        self.name = budget.name + " - " + budget.subcategory
        self.phone = Constants.Cell.Budget.phoneTitle + "\(budget.phone)" + " (" + budget.location + ")"
        self.email = Constants.Cell.Budget.emailTitle + budget.email
        self.definition = Constants.Cell.Budget.definitionTitle + budget.definition
    }
}
