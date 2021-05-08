//
//  CoreDataStack.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 03/05/2021.
//

import Foundation
import CoreData

class CoreDataStack {
    let moduleName = "JPPlanets"

    func saveToMainContext() { // Just a helper method for removing boilerplate code when you want to save. Remember this will be done on the main thread if called.
        if objectContext.hasChanges {
            do {
                try objectContext.save()
            } catch {
                print("Error saving main ManagedObjectContext: \(error)")
            }
        }
        
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("Error saving main ManagedObjectContext: \(error)")
            }
        }
    }

    func fetchFromStorage<Object: NSManagedObject>(name: Object) -> [Object]?{
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Object>(entityName: name.description)
        do {
          let contacts = try managedObjectContext.fetch(fetchRequest)
          guard contacts.count > 0 else {
            return nil
          }
          return contacts
        } catch let error {
          print(error)
          return nil
        }
    }
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let persistenStoreURL = self.applicationDocumentsDirectory.appendingPathComponent("\(moduleName).sqlite")

        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistenStoreURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption : true])
        } catch {
            fatalError("Persistent Store error: \(error)")
        }
        return coordinator
    }()

    lazy var objectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType) // As stated in the documentation change this depending on your need, but i recommend sticking to main thread if possible.

        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: moduleName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
}
