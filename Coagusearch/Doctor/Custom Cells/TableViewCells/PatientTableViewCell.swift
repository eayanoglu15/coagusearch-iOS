//
//  PatientTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 28.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class PatientTableViewCell: UITableViewCell {
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var analysisImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
