//
//  BudgetListInteractor.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 02/05/2021.
//

import Foundation

protocol BudgetListInteractorInputProtocol {
    func getDataTable()
}

class BudgetListInteractor {
    var presenter: BudgetListInteractorOutputProtocol?
    let managerBudget = BudgetManager.sharedInstance
}

extension BudgetListInteractor: BudgetListInteractorInputProtocol {
    
    func getDataTable() {
        let model = BudgetListModel()
        let allBudgets = self.managerBudget.getAllBudgets()
        
        for budgetEntity in allBudgets {
            model.cellModels.append(BudgetCellModel(budget: budgetEntity))
        }
        self.presenter?.reponse(model: model)
    }
}
