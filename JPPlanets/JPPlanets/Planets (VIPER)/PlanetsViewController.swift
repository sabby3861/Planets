//
//  PlanetsViewController.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 27/04/2021.
//

import UIKit

class PlanetsViewController: UIViewController, PlanetsViewProtocol {
        
    @IBOutlet weak var tableView: UITableView!
    var presenter: PlanetsPresenterProtocol?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchPlanetsInformation()
        // Do any additional setup after loading the view.
    }
    
}


// MARK: - Extension for TableView DataSource
extension PlanetsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = presenter?.result else { return 0 }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanetsTableViewCell.reuseIdentifier, for: indexPath) as? PlanetsTableViewCell else {
            fatalError("cellError")
        }
        if let planetInfo = presenter?.result?[indexPath.row] {
            cell.displayData(data: planetInfo)
        }
        return cell
    }
}
