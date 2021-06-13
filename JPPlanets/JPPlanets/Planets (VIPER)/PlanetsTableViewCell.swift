//
//  PlanetsTableViewCell.swift
//  JPPlanets
//
//  Created by Sanjay Chauhan on 16/05/2021.
//

import UIKit

class PlanetsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// Display data on table view cell
    ///
    /// - Parameter data: Results containing all info
    func displayData(data: JPResult) {

        nameLabel.text = data.planetName

    }
}

extension PlanetsTableViewCell: JPReusableIdentifier{}
