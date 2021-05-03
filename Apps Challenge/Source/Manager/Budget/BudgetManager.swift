//
//  BudgetManager.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 02/05/2021.
//

import Foundation
import CoreData

struct BudgetManager {
    
    static let sharedInstance = BudgetManager()
    
    let managerPersistentContainer = PersistentContainerManager.sharedInstance
    let context = PersistentContainerManager.sharedInstance.context
    
    // MARK: - CRUD
    
    // MARK: - Create
    func create(name: String, phone: Int32, email: String, definition: String, location: String, subcategory: String) {
        let newBudget = Budget(context: self.context)
        
        newBudget.name = name
        newBudget.phone = phone
        newBudget.email = email
        newBudget.definition = definition
        newBudget.location = location
        newBudget.subcategory = subcategory
        
        self.managerPersistentContainer.saveContext()
    }
    
    // MARK: - Read
    func getAllBudgets() -> [Budget] {
        do {
            let arrayAllBudget: [Budget] = try self.context.fetch(Budget.fetchRequest())
            
            return arrayAllBudget
        } catch let error {
            print("BudgetManager - getAllBudgets - self.context.fetch(Budget.fetchRequest() - Failed with error: \(error.localizedDescription)")
        }
        
        return []
    }
    
    // MARK: - Update
    func update(budget: Budget, name: String? = nil, phone: Int32? = nil, email: String? = nil, definition: String? = nil, location: String? = nil, subcategory: String? = nil) {
        
        if let name = name {
            budget.name = name
        }
        
        if let phone = phone {
            budget.phone = phone
        }
        
        if let email = email  {
            budget.email = email
        }
        
        if let definition = definition {
            budget.definition = definition
        }
        
        if let location = location  {
            budget.location = location
        }
        
        if let subcategory = subcategory {
            budget.subcategory = subcategory
        }
        self.managerPersistentContainer.saveContext()
    }
    
    // Delete
    func delete(budget: Budget) {
        self.context.delete(budget)
        self.managerPersistentContainer.saveContext()
    }
}
