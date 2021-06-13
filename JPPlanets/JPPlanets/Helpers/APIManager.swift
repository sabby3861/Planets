//
//  APIManager.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 27/04/2021.
//

import Foundation
import UIKit
import CoreData

/**
 All query output are wrapped into this Enum
 *//*
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
*/

enum JPError: Error {
    case invalidRequest
    case serviceFailure
}

protocol JPContactServiceProtocol {
    var urlSession: URLSessionProtocol {get}
}

/// Network status
enum ReachabilityStatus {
    case unknown
    case disconnected
    case connected
}

///  API manager class to handle the API calls
class APIManager: JPContactServiceProtocol {
    /// URLSession used for query
    var urlSession: URLSessionProtocol
    /// Data Task
    private var task: URLSessionDataTask?
    // Reachability to check the internet
    private let reachabilityManager: NetworkReachabilityManager?
    private(set) var reachabilityStatus: ReachabilityStatus
    /**
     Init kit
        - Parameter urlSession: URLSession used for query
     */
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
        self.reachabilityManager = NetworkReachabilityManager()
        self.reachabilityStatus = .unknown
        beginListeningNetworkReachability()
    }
    
    deinit {
        reachabilityManager?.stopListening()
    }
    
    /*
     Reachability
     
     - Start the reachability
     - To checek network status
     */
    func beginListeningNetworkReachability() {
        reachabilityManager?.listener = { status in
            switch status {
            case .unknown: self.reachabilityStatus = .unknown
            case .notReachable:
                self.reachabilityStatus = .disconnected
                self.showErrorForNoNetwork()
            case .reachable(.ethernetOrWiFi), .reachable(.wwan): self.reachabilityStatus = .connected
            }
            
        }
        reachabilityManager?.startListening()
    }
    /*
     Show Alert message on no network connection
     */
    func showErrorForNoNetwork()  {
        task?.suspend()
        DispatchQueue.main.async {
            
        }
    }
    
    /**
     Init kit
     
     - Parameter key: void
     */
    public convenience init() {
        self.init(urlSession: URLSession.shared)
    }
    
    /**
            - Send API Request
     **/
    private func sendRequest<T: Codable>(payload: JPHTTPPayloadProtocol, completion: @escaping (Result<T, Error>) -> Void)  {
        
        if let requestURL = URL(string: payload.url){
            var urlRequest = URLRequest(url: requestURL)
            guard let headers = payload.headers else {
                fatalError("There must be headers")
            }
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
            urlRequest.httpMethod = payload.type?.httpMethod()
            task = urlSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(error!))
                    }
                    return
                }
                do {
                    guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                      fatalError("Failed to retrieve managed object context")
                    }
                    // Parse JSON data
                    var managedObjectContext: NSManagedObjectContext?
                        managedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
                    DispatchQueue.global(qos: .background).async {
                        managedObjectContext?.perform {
                            let result: Result<T, Error>
                            let decoder = JSONDecoder()
                            decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext!
    
                            do{
                             let contacts = try decoder.decode(T.self, from: data)
                                result = .success(contacts)
                            }
                            catch let error {
                                result = .failure(error)
                            }
                            completion(result)
                        }
                    }
                    
                }
            }
            task?.resume()
        }
    }
}


/**
 Extension for APIManager
 */
extension APIManager: APIManagerProtocol {
    /**
     Retrieve the contacts
     - Parameter id:  Payload protocol, containing payload data
     - Parameter completion: Result of api call
     */
    func getPlanetsInfo(payload: JPHTTPPayloadProtocol, completion: @escaping (Result<Planets, Error>) -> Void){
        sendRequest(payload: payload,completion: completion)
    }
}
