//
//  CreateBudgetRouter.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 03/05/2021.
//

import Foundation

protocol CreateBudgetRouterProtocol {
    
}

class CreateBudgetRouter {
    
    static func createModule() -> CreateBudgetViewController {
        let controller = CreateBudgetViewController()
        let presenter = CreateBudgetPresenter()
        let interactor = CreateBudgetInteractor()
        let router = CreateBudgetRouter()
        
        controller.presenter = presenter
        presenter.view = controller
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return controller
    }
}

extension CreateBudgetRouter: CreateBudgetRouterProtocol {
    
}
