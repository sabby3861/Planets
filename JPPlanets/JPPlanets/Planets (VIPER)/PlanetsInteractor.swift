//
//  PlanetsInteractor.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 27/04/2021.
//

import Foundation
import CoreData

class PlanetsInteractor: PlanetsInteractorProtocol, PayLoadFormat {
    var output: PlanetsOutputProtocol?
    
    /// Call the API to fetch Decodable Resonse
    /// Check if we have data in database, if so then use the local data else get fresh data from the server
    func decodeJSONInformation() {
        let corData = CoreDataStack.shared
        guard let data = corData.fetchFromCoreData(name: Planets.self) else {
            startDownloadingPlanetsInfo(coreData: corData)
          return
        }
        self.output?.planetsInfoDidFetch(result: data.first?.results ?? [])
    }
    /// Function to fetch data from the API
    func startDownloadingPlanetsInfo(coreData: CoreDataStack)  {
        let payload = formatGetPayload(url: .planetsUrl, type: .requestMethodGET)
        let service = APIManager()
        service.getPlanetsInfo(payload: payload){ [unowned self]result in
            switch result {
            case .success(_):
                coreData.saveToMainContext()
                guard let planets = coreData.fetchFromCoreData(name: Planets.self) else { return  }
                self.output?.planetsInfoDidFetch(result: planets.first?.results ?? [])
        
            case .failure(let error):
                self.output?.errorOccured(message: error.localizedDescription)
            }
        }
    }
}


