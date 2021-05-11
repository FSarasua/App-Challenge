//
//  CoreDataManager.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 02/05/2021.
//

import Foundation
import CoreData

struct CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    
    let context = PersistentContainerManager.sharedInstance.context
    let managerBudget = BudgetManager.sharedInstance
    
    // MARK: - Check CoreData
    
    func initCoreData() {
        
        self.managerBudget.create(name: "Antonio", phone: 655871624, email: "antonio@mail.com", definition: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum pulvinar dolor et mauris sagittis, in porta sem ultrices. Curabitur at ante mi. Nunc tincidunt est sed magna bibendum, nec elementum diam eleifend.", location: "Francia", subcategory: "Mudanzas Viviendas")
        
        self.managerBudget.create(name: "Fran", phone: 674325538, email: "franciscojavier.sg.trabajo@gmail.com", definition: "Necesito una mosquitera.", location: "España", subcategory: "Mosquitera")
    }
    
    func isCoreDataEmpty() -> Bool {
        let arrayAllBudget = self.managerBudget.getAllBudgets()
        
        return arrayAllBudget.count > 0 ? false : true
    }
    
    func deleteAll() {
        let arrayAllBudget = self.managerBudget.getAllBudgets()
        
        for budget in arrayAllBudget {
            self.managerBudget.delete(budget: budget)
        }
    }
}
