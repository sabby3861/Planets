//
//  PlanetsPresenter.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 27/04/2021.
//

import Foundation

class PlanetsPresenter: PlanetsPresenterProtocol {
    var view: PlanetsViewProtocol?
    var interactor: PlanetsInteractorProtocol?
    var result: [JPResult]?
    
    /// Call to Intercator to process the API
    func fetchPlanetsInformation() {
        interactor?.decodeJSONInformation()
    }
}

// MARK: - Presenter to view communcation
extension PlanetsPresenter: PlanetsOutputProtocol {
    /// Function to get the Reesponse
    func planetsInfoDidFetch(result: Set<Results>) {
        mapToStructure(managedObject: result)
        view?.tableView.reloadData()
        view?.activity.removeActivity()
    }
    /// Function to show the error Alert
    func errorOccured(message: String) {
        view?.showError(title, message: message)
    }
    
    /**
            Mapping NSManaged Object to Structure
     Avoid using managed objects directly, instead used a stucture
     */
    func mapToStructure(managedObject: Set<Results>?) {
        self.result = [JPResult]()
        for object in managedObject ?? [] {
            self.result?.append(JPResult(name: object.planetName!))
        }
    }
}

