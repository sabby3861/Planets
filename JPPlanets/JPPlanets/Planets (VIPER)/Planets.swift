//
//  Planets.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 27/04/2021.
//

import Foundation
import CoreData
/// Contact info
class Planets : NSManagedObject, Codable {
  enum CodingKeys: String, CodingKey {
    case results = "results"
    case next = "next"
  }
  
  // MARK: - Core Data Managed Object
    @NSManaged var next: String?
  @NSManaged var results: Set<Results>?
  
  // MARK: - Decodable
  required convenience init(from decoder: Decoder) throws {
    guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
      let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
      let entity = NSEntityDescription.entity(forEntityName: JPCoreData.planet.rawValue, in: managedObjectContext) else {
        fatalError("Failed to decode User")
    }
    
    self.init(entity: entity, insertInto: managedObjectContext)
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    //self.results = try container.decodeIfPresent(Results.self, forKey: .results)
    self.next = try container.decodeIfPresent(String.self, forKey: .next)
    self.results = try container.decodeIfPresent(Set<Results>.self, forKey: .results)
  }
  
  // MARK: - Encodable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    //try container.encode(results, forKey: .results)
    
    try container.encode(next, forKey: .next)
    try container.encode(results, forKey: .results)
  }
  
}

/// Get all the results of Planets
class Results : NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
      case planetName = "name"
    }
    
    // MARK: - Core Data Managed Object
    @NSManaged var planetName: String?
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
      guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
        let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: JPCoreData.results.rawValue, in: managedObjectContext) else {
          fatalError("Failed to decode User")
      }
      
      self.init(entity: entity, insertInto: managedObjectContext)
      
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.planetName = try container.decodeIfPresent(String.self, forKey: .planetName)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(planetName, forKey: .planetName)
    }
}

public extension CodingUserInfoKey {
  // Helper property to retrieve the Core Data managed object context
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

enum JPCoreData: String {
    case planet = "Planets"
    case results = "Results"
}
