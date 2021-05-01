//
//  PlanetsProtocols.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 27/04/2021.
//

import Foundation

protocol PlanetsViewProtocol: class
{
    var presenter: PlanetsPresenterProtocol? { get }
    func showPlanetsInformation(with info: [Planets]?)
    func showError(with message: String)
    var dataSource: [Planets]? {get set}
    
}

/// View -> Interactor and View -> Router Communication Protocols
protocol PlanetsPresenterProtocol: class
{
    var view: PlanetsViewProtocol? { get }
    var router: PlanetsRouterProtocol? { get }
    var interactor: PlanetsInteractorProtocol?{get}
    func fetchPlanetsInformation()
}

/// Interactor -> Presenter Communication Protocols
protocol PlanetsInteractorProtocol: class
{
    var output: PlanetsOutputProtocol? { get }
    func decodeJSONInformation()
}

protocol PlanetsOutputProtocol: class
{
    func planetsInfoDidFetch(citiesInfo: [Planets]?)
    func errorOccured(message: String)
}

/// Router Protocols and assembling Module
protocol PlanetsRouterProtocol: class
{
    var viewController: PlanetsViewController? { get}
    static func assembleModule(view: PlanetsViewController)
    func showMapView(cityInfo: Planets)
}


protocol APIManagerProtocol {
    func getPlanetsInfo(completion: @escaping (Result<[Planets]>) -> Void)
}
