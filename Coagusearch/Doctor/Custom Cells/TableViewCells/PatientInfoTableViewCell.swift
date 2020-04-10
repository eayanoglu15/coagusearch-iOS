//
//  PatientInfoTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 29.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class PatientInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(user: User) {
        if let day = user.birthDay, let month = user.birthMonth, let year = user.birthYear {
            birthDateLabel.text = "\(day).\(month).\(year)"
        } else {
            birthDateLabel.text = "-"
        }
        if let height = user.height {
            heightLabel.text = "\(height) cm"
        } else {
            heightLabel.text = "-"
        }
        if let weight = user.weight {
            weightLabel.text = "\(weight) kg"
        } else {
            weightLabel.text = "-"
        }
        if let bType = user.bloodType, let rhType = user.rhType {
            if rhType == RhType.Positive {
                bloodTypeLabel.text = "\(bType) Rh+"
            } else {
                bloodTypeLabel.text = "\(bType) Rh-"
            }
        } else {
            bloodTypeLabel.text = "-"
        }
    }
}
