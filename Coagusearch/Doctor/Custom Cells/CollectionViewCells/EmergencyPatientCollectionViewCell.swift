//
//  EmergencyPatientCollectionViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 27.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class EmergencyPatientCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var ambulanceImageView: UIImageView!
    @IBOutlet weak var verificationImageView: UIImageView!
    
    var patient: EmergencyPatientInfo?
    
    func getPatientId() -> Int? {
        return patient?.patientId
    }
    
    func isDataReady() -> Bool {
        if let patient = patient {
            return patient.dataReady
        }
        return false
    }
    
    func setEmergencyPatient(patient: EmergencyPatientInfo) {
        self.patient = patient
        patientNameLabel.text = "\(patient.userName) \(patient.userSurname)"
        let time = patient.arrivalHour
        
        var hourStr = "\(time.hour)"
        if time.hour < 10 {
            hourStr = "0" + "\(time.hour)"
        }
        
        var minStr = "\(time.minute)"
        if time.minute < 10 {
            minStr = "0" + "\(time.minute)"
        }
        timeLabel.text = "\(hourStr):\(minStr)"
        
        if patient.dataReady {
            verificationImageView.image = UIImage(named: IMAGE_NAME_VERIFIED)
        } else {
            verificationImageView.image = UIImage(named: IMAGE_NAME_HOUR_GLASS)
        }
        
        // TODO: user at ambulance
        // if patient.userAtAmbulance
    }
    
}



