//
//  PlanetsRouter.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 27/04/2021.
//

import Foundation

class PlanetsRouter: PlanetsRouterProtocol {
    var viewController: PlanetsViewProtocol?
    
    static func assembleModule(view: PlanetsViewProtocol) {
        let presenter = PlanetsPresenter()
        let router = PlanetsRouter()
        let interactor = PlanetsInteractor()
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        view.presenter = presenter
        router.viewController = view
    }
    
}
