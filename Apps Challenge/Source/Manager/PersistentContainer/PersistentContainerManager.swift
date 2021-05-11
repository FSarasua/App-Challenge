//
//  PersistentContainerManager.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 02/05/2021.
//

import Foundation
import CoreData

struct PersistentContainerManager {
    
    static let sharedInstance = PersistentContainerManager()

    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: Constants.Database.name)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext = {
        
        let container = NSPersistentContainer(name: Constants.Database.name)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container.viewContext
    }()
    
    // MARK: - Core Data Saving support

    func saveContext () {

        if self.context.hasChanges {
            
            do {
                try self.context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
