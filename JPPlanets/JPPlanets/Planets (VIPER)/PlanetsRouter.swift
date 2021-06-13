//
//  PlanetsRouter.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 27/04/2021.
//

import Foundation

class PlanetsRouter: PlanetsRouterProtocol {
    
     func assembleModule(view: PlanetsViewProtocol) {
        let presenter = PlanetsPresenter()
        let interactor = PlanetsInteractor()
        presenter.view = view
        presenter.interactor = interactor
        interactor.output = presenter
        view.presenter = presenter
    }
    
}
