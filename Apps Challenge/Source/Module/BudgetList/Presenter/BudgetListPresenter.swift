//
//  BudgetListPresenter.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 02/05/2021.
//

import Foundation
import UIKit

protocol BudgetListPresenterProtocol: class {
    func goToCreateBudget(navigation: UINavigationController)
    func removeDataTable()
    func loadData()
    func reloadData()
}

protocol BudgetListInteractorOutputProtocol: class {
    func setData(viewModel: BudgetListViewModel)
}

class BudgetListPresenter {
    weak var view: BudgetListViewProtocol?
    var interactor: BudgetListInteractorInputProtocol?
    var router: BudgetListRouterProtocol?
    
    // MARK: - Variables
    var viewModel: BudgetListViewModel?
}

extension BudgetListPresenter: BudgetListPresenterProtocol {
    
    func goToCreateBudget(navigation: UINavigationController) {
        self.router?.openCreateBudget(navigation: navigation)
    }
    
    func removeDataTable() {
        self.interactor?.removeDataTable()
    }
    
    func loadData() {
        self.interactor?.getDataTable()
    }
    
    func reloadData() {
        self.loadData()
    }
}

extension BudgetListPresenter: BudgetListInteractorOutputProtocol {
    
    func setData(viewModel: BudgetListViewModel) {
        self.viewModel = viewModel
        self.view?.setData(viewModel: viewModel)
        self.view?.emptyView(isHidden: !viewModel.cellModels.isEmpty)
    }
}
