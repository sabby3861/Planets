//
//  JPActivityView.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 13/06/2021.
//

import Foundation
import UIKit

protocol JPActivityViewProtocol {
    func showActivityIndicatory(view: UIView, _ title: String)
    func removeActivity()
}

class JPActivityView: JPActivityViewProtocol {
    lazy var activityIndicator = UIActivityIndicatorView()
    lazy var strLabel = UILabel()
    lazy var effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    func showActivityIndicatory(view: UIView, _ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel()
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.color = .white
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
        
        strLabel.translatesAutoresizingMaskIntoConstraints = false
        effectView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        applyConstraints(with: view)
        activityIndicator.startAnimating()
    }
    
    private func applyConstraints(with view: UIView) {
        
        let constraints = [
            effectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            effectView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            effectView.widthAnchor.constraint(equalToConstant: CGFloat(220)),
            effectView.heightAnchor.constraint(equalToConstant: CGFloat(47)),
            
            strLabel.widthAnchor.constraint(equalToConstant: CGFloat(220)),
            strLabel.heightAnchor.constraint(equalToConstant: CGFloat(47)),
            strLabel.leftAnchor.constraint(equalToSystemSpacingAfter: effectView.leftAnchor, multiplier: CGFloat(4)),
            strLabel.topAnchor.constraint(equalTo: effectView.topAnchor, constant: 0),
            
            activityIndicator.centerYAnchor.constraint(equalTo: effectView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: CGFloat(30)),
            activityIndicator.heightAnchor.constraint(equalToConstant: CGFloat(30)),
            activityIndicator.leftAnchor.constraint(equalToSystemSpacingAfter: effectView.leftAnchor, multiplier: CGFloat(0)),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func removeActivity() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        strLabel.removeFromSuperview()
    }
}



protocol JPAlertDelegate {
    func alert(buttonClickedIndex:Int, buttonTitle: String, tag: Int)
}
class JPAlertViewController {
    class func showAlert(withTitle title: String, message:String, buttons:[String] = ["Ok"], delegate: JPAlertDelegate? = nil, tag: Int = 0){
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        var presentingViewController = keyWindow?.rootViewController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tag = tag
        var index = 0
        for button in buttons {
            let action =  UIAlertAction(title: button, style: .default, handler: { (alertAction) in
                
                if let d = delegate{
                    d.alert(buttonClickedIndex: index, buttonTitle: alertAction.title != nil ? alertAction.title! : "GoJek", tag: tag)
                }
            })
            alert.addAction(action)
            index = index + 1
        }
        
        while presentingViewController?.presentedViewController != nil {
            presentingViewController = presentingViewController?.presentedViewController
        }
        
        presentingViewController?.present(alert, animated: true, completion: nil)
    }
}
