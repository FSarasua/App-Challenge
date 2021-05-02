//
//  BudgetListRouter.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 02/05/2021.
//

import Foundation
import UIKit

protocol BudgetListRouterProtocol {
    
}

class BudgetListRouter {
    
    static func createModule() -> UINavigationController {
        let controller = BudgetListViewController()
        let presenter = BudgetListPresenter()
        let interactor = BudgetListInteractor()
        let router = BudgetListRouter()
        
        controller.presenter = presenter
        presenter.view = controller
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let navigation = UINavigationController(rootViewController: controller)
        
        return navigation
    }
}

extension BudgetListRouter: BudgetListRouterProtocol {
    
}
