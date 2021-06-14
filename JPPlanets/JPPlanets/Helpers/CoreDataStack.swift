//
//  CoreDataStack.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 03/05/2021.
//

import Foundation
import CoreData
// MARK: - Core Data stack
class CoreDataStack {
    let moduleName = "JPPlanets"
    
    func saveToMainContext() { // Just a helper method for removing boilerplate code when you want to save. Remember this will be
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: moduleName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var shared = CoreDataStack()
}

extension CoreDataStack: StorageManager{
    /// Generic function to fetch from Core data
    func fetchFromCoreData<Storable: NSManagedObject>(name: Storable.Type) -> [Storable]?{
        let managedObjectContext = persistentContainer.viewContext
        let entityName = String(describing: name)
        let fetchRequest = NSFetchRequest<Storable>(entityName: entityName)
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            guard result.count > 0 else {
                return nil
            }
            return result
        } catch let error {
            print(error)
            return nil
        }
    }
}
protocol Storable { }
extension NSManagedObject: Storable { } // Core Data Database
protocol StorageManager {
    /// Save Object into Core database
    func saveToMainContext()
    func fetchFromCoreData<Storable: NSManagedObject>(name: Storable.Type) -> [Storable]?
}
