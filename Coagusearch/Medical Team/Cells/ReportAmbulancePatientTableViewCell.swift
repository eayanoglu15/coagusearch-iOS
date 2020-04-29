//
//  ReportAmbulancePatientTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 23.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class ReportAmbulancePatientTableViewCell: UITableViewCell {
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var patientInfoTextField: UITextField!
    @IBOutlet weak var notifyDoctorButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        patientInfoTextField.isHidden = true
        notifyDoctorButton.isHidden = true
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func notifyDoctorButtonTapped(_ sender: Any) {
    }
    
    func changeArrow(selected: Bool) {
        if !selected {
            patientInfoTextField.isHidden = true
            notifyDoctorButton.isHidden = true
            arrowImageView.image = UIImage(named: IconNames.downArrow)
        } else {
            patientInfoTextField.isHidden = false
            notifyDoctorButton.isHidden = false
            arrowImageView.image = UIImage(named: IconNames.upArrow)
        }
    }
}
