//
//  CreateBudgetInteractor.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 03/05/2021.
//

import Foundation

protocol CreateBudgetInteractorInputProtocol {
    
}

class CreateBudgetInteractor {
    var presenter: CreateBudgetInteractorOutputProtocol?
    let managerBudget = BudgetManager.sharedInstance
}

extension CreateBudgetInteractor: CreateBudgetInteractorInputProtocol {
    
}
