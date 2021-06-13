//
//  JPReusableIdentifier.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 16/05/2021.
//

import Foundation
/// Protocol to use resuse identifier
protocol JPReusableIdentifier: class {
    static var reuseIdentifier: String { get }
}

extension JPReusableIdentifier {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}

/// Constants to use
let title = "Planets"
let genericError = "Something wrong happened, please try later"
let activityTitle = "Fetching Planets Info"
