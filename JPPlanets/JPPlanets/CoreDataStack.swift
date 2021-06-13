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

    func saveToMainContext() { // Just a helper method for removing boilerplate code when you want to save. Remember this will be
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("Error saving main ManagedObjectContext: \(error)")
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
    
    func save(object: Storable) {
        do {
          let managedObjectContext = persistentContainer.viewContext
          try managedObjectContext.save()
        }
        catch let error {
          print("unable to save context \(error)")
        }
    }
}
protocol Storable { }
extension NSManagedObject: Storable { } // Core Data Database
protocol StorageManager {
    /// Save Object into Core database
    /// - Parameter object: NSManagedObject (as Storable)
    func save(object: Storable)
    func fetchFromCoreData<Storable: NSManagedObject>(name: Storable.Type) -> [Storable]?
}
