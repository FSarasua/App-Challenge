//
//  CreateBudgetRouter.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 03/05/2021.
//

import Foundation
import UIKit

protocol CreateBudgetRouterProtocol: class {
    func showError(view: UIViewController, _ error: ErrorModel)
    func showErrorValidation(view: UIViewController, message: String)
    func returnToBudgetList(navigation: UINavigationController)
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
    
    func showError(view: UIViewController, _ error: ErrorModel) {
        let alert = UIAlertController(title: error.title, message: error.message + "\n" + error.debugMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.confirm, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        
        view.present(alert, animated: true, completion: nil)
    }
    
    func showErrorValidation(view: UIViewController, message: String) {
        let alert = UIAlertController(title: Constants.Validation.title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.confirm, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        
        view.present(alert, animated: true, completion: nil)
    }
    
    func returnToBudgetList(navigation: UINavigationController) {
        navigation.popViewController(animated: true)
    }
}
