//
//  CreateBudgetInteractor.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 03/05/2021.
//

import Foundation

protocol CreateBudgetInteractorInputProtocol: class {
    func getLocationData()
    func getCategoryData()
    func getSubcategoryData(idCategory: String)
    
    func createNewBudget(name: String, phone: Int32, email: String, definition: String, location: String, subcategory: String)
}

class CreateBudgetInteractor {
    weak var presenter: CreateBudgetInteractorOutputProtocol?
    let managerBudget = BudgetManager.sharedInstance
}

extension CreateBudgetInteractor: CreateBudgetInteractorInputProtocol {
    
    func getLocationData() {
        let request = Constants.URL.baseURL + Constants.Endpoint.location
        
        AlamofireManager.sharedInstance.request(request: request) { data in
            
            do {
                let serverModel = try JSONDecoder().decode([LocationServerModel].self, from: data)
                self.presenter?.setLocationData(serverModel: serverModel)
            } catch {
                let errorModel: ErrorModel = ErrorManager.sharedInstance.parseToErrorModel(error: error, type: .JSONParser)
                
                self.presenter?.setError(error: errorModel)
            }
        } failure: { error in
            let errorModel: ErrorModel = ErrorManager.sharedInstance.parseToErrorModel(error: error, type: .service)
            
            self.presenter?.setError(error: errorModel)
        }
    }
    
    func getCategoryData() {
        let request = Constants.URL.baseURL + Constants.Endpoint.category
        
        AlamofireManager.sharedInstance.request(request: request) { data in
            
            do {
                let serverModel = try JSONDecoder().decode([CategoryServerModel].self, from: data)
                self.presenter?.setCategoryData(serverModel: serverModel)
            } catch {
                let errorModel: ErrorModel = ErrorManager.sharedInstance.parseToErrorModel(error: error, type: .JSONParser)
                
                self.presenter?.setError(error: errorModel)
            }
        } failure: { error in
            let errorModel: ErrorModel = ErrorManager.sharedInstance.parseToErrorModel(error: error, type: .service)
            
            self.presenter?.setError(error: errorModel)
        }
    }
    
    func getSubcategoryData(idCategory: String) {
        let url = Constants.URL.baseURL + Constants.Endpoint.category + idCategory

        AlamofireManager.sharedInstance.request(request: url) { data in
            
            do {
                let serverModel = try JSONDecoder().decode([SubcategoryServerModel].self, from: data)
                self.presenter?.setSubcategoryData(serverModel: serverModel, index: idCategory)
            } catch {
                let errorModel: ErrorModel = ErrorManager.sharedInstance.parseToErrorModel(error: error, type: .service)
                
                self.presenter?.setError(error: errorModel)
            }
        } failure: { error in
            let errorModel: ErrorModel = ErrorManager.sharedInstance.parseToErrorModel(error: error, type: .service)
            
            self.presenter?.setError(error: errorModel)
        }
    }
    
    func createNewBudget(name: String, phone: Int32, email: String, definition: String, location: String, subcategory: String) {
        self.managerBudget.create(name: name, phone: phone, email: email, definition: definition, location: location, subcategory: subcategory)
        self.presenter?.budgetCreated()
    }
}
