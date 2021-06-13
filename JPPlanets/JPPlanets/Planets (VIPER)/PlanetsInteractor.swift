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
    func decodeJSONInformation() {
        let payload = formatGetPayload(url: .planetsUrl, type: .requestMethodGET)
        let service = APIManager()
        service.getPlanetsInfo(payload: payload){ [unowned self]result in
            switch result {
            case .success(_):
                let corData = CoreDataStack.shared
                corData.saveToMainContext()
                guard let planets = corData.fetchFromCoreData(name: Planets.self) else { return  }
                self.output?.planetsInfoDidFetch(result: planets.first?.results ?? [])
        
            case .failure(let error):
                self.output?.errorOccured(message: error.localizedDescription)
            }
        }
    }
}


