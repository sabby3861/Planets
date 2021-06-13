//
//  PlanetsProtocols.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 27/04/2021.
//

import Foundation
import UIKit

/// View Protocol
protocol PlanetsViewProtocol: JPViewErroProtocol, AnyObject
{
    var presenter: PlanetsPresenterProtocol? { get set}
    var tableView: UITableView!{get set}
}

/// View -> Interactor and View -> Router Communication Protocols
protocol PlanetsPresenterProtocol: AnyObject
{
    var view: PlanetsViewProtocol? { get }
    var interactor: PlanetsInteractorProtocol?{get}
    var result: [JPResult]? {get}
    func fetchPlanetsInformation()
}

/// Interactor -> Presenter Communication Protocols
protocol PlanetsInteractorProtocol: AnyObject
{
    var output: PlanetsOutputProtocol? { get }
    func decodeJSONInformation()
}

/// Interactor to Presenter Output Protocol
protocol PlanetsOutputProtocol: AnyObject
{
    func planetsInfoDidFetch(result: Set<Results>)
    func errorOccured(message: String)
}

/// Router Protocols and assembling Module
protocol PlanetsRouterProtocol: AnyObject
{
    var viewController: PlanetsViewProtocol? { get}
    static func assembleModule(view: PlanetsViewProtocol)
}

/// APIManager Protocol
protocol APIManagerProtocol {
    func getPlanetsInfo(payload: JPHTTPPayloadProtocol,completion: @escaping (Result<Planets, Error>) -> Void)
}

/// Protocol for error message Alert
protocol JPViewErroProtocol {
    func showError(_ title: String, message: String)
}
