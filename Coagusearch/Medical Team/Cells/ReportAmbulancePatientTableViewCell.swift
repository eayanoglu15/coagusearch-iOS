//
//  ReportAmbulancePatientTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 23.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

protocol ReportAmbulancePatientTableViewCellDelegate: AnyObject {
    func notifyDoctorButtonClicked(id: Int)
}

class ReportAmbulancePatientTableViewCell: UITableViewCell {
    weak var delegate: ReportAmbulancePatientTableViewCellDelegate?
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var patientInfoTextField: UITextField!
    @IBOutlet weak var notifyDoctorButton: UIButton!
    
    func clear() {
        patientInfoTextField.text = nil
    }
    
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
        if let idStr = patientInfoTextField.text, !idStr.isEmpty {
            if let id = Int(idStr) {
                self.delegate?.notifyDoctorButtonClicked(id: id)
            }
        }
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
