//
//  BudgetListInteractor.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 02/05/2021.
//

import Foundation

protocol BudgetListInteractorInputProtocol: class {
    func getDataTable()
    func removeDataTable()
}

class BudgetListInteractor {
    weak var presenter: BudgetListInteractorOutputProtocol?
    let managerCoreData = CoreDataManager.sharedInstance
    let managerBudget = BudgetManager.sharedInstance
}

extension BudgetListInteractor: BudgetListInteractorInputProtocol {
    
    func getDataTable() {
        let viewModel = BudgetListViewModel()
        let allBudgets = self.managerBudget.getAllBudgets()
        
        for budgetEntity in allBudgets {
            viewModel.cellModels.append(BudgetCellModel(budget: budgetEntity))
        }
        self.presenter?.setData(viewModel: viewModel)
    }
    
    func removeDataTable() {
        self.managerCoreData.deleteAll()
        self.presenter?.setData(viewModel: BudgetListViewModel())
    }
}
