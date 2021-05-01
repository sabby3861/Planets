//
//  APIManager.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 27/04/2021.
//

import Foundation
import Foundation

/**
 All query output are wrapped into this Enum
 */
public enum Result<T> {
    /**
     Success Result
     - Parameter T: T can be Weather of Forecast struct
     */
    case success(T)
    /**
     Error case
     - Parameter Error?: error can be nil when error are unknown
     */
    case error(Error?)
}

struct APIManager {
    private func sendRequest<T: Codable>(completion: @escaping (Result<T>) -> Void)  {
       
    }
}


/**
 Extension for APIManager
 */
extension APIManager: APIManagerProtocol {
    /**
     Retrieve the contacts
     - Parameter id:  internal ids as Array of Cities
     - Parameter completion: Result of api call
     */
    func getPlanetsInfo(completion: @escaping (Result<[Planets]>) -> Void){
        sendRequest(completion: completion)
    }
}
