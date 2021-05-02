//
//  BudgetListPresenter.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 02/05/2021.
//

import Foundation

protocol BudgetListPresenterProtocol {
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
    
    func loadDataTable() {
        self.interactor?.getDataTable()
    }
}

extension BudgetListPresenter: BudgetListInteractorOutputProtocol {
    
    func reponse(model: BudgetListModel) {
        self.model = model
        self.view?.results(model: model)
    }
}
