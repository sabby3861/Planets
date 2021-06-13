//
//  JPStoryBoard.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 16/05/2021.
//

import Foundation
import UIKit
/// Storyboard exntesion, an utitlity
extension UIStoryboard {
  enum Storyboard: String {
    case Main
    var filename: String {
      return rawValue.capitalized
    }
  }
  convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
    self.init(name: storyboard.filename, bundle: bundle)
  }
  class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
    return UIStoryboard(name: storyboard.filename, bundle: bundle)
  }
  
  func instantiateVieController<T>() -> T where T: JPStoryboardIdentifiable {
    guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
      fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
    }
    return viewController
  }
  
}


protocol JPStoryboardIdentifiable {
  static var storyboardIdentifier: String { get }
}

extension JPStoryboardIdentifiable where Self: UIViewController {
  static var storyboardIdentifier: String {
    return String(describing: self)
  }
}

extension UIViewController: JPStoryboardIdentifiable{}
