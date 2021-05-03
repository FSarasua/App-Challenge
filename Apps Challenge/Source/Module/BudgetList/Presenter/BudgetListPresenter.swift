//
//  BudgetListPresenter.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 02/05/2021.
//

import Foundation
import UIKit

protocol BudgetListPresenterProtocol {
    func goToCreateBudget(navigation: UINavigationController)
    func loadDataTable()
}

protocol BudgetListInteractorOutputProtocol {
    func reponse(model: BudgetListModel)
}

class BudgetListPresenter {
    var view: BudgetListViewProtocol?
    var interactor: BudgetListInteractorInputProtocol?
    var router: BudgetListRouterProtocol?
    
    // MARK: - Variables
    var model: BudgetListModel?
}

extension BudgetListPresenter: BudgetListPresenterProtocol {
    
    func goToCreateBudget(navigation: UINavigationController) {
        self.router?.openCreateBudget(navigation: navigation)
    }
    
    func loadDataTable() {
        self.interactor?.getDataTable()
    }
}

extension BudgetListPresenter: BudgetListInteractorOutputProtocol {
    
    func reponse(model: BudgetListModel) {
        self.model = model
        self.view?.setDataTable(model: model)
    }
}
