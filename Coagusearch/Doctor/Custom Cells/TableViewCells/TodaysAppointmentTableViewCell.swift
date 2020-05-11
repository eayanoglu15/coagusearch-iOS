//
//  TodaysAppointmentTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 27.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class TodaysAppointmentTableViewCell: UITableViewCell {
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(patient: DoctorTodayAppointment) {
        patientNameLabel.text = "\(patient.userName) \(patient.userSurname)"
        
        let time = patient.appointmentHour
        
        var hourStr = "\(time.hour)"
        if time.hour < 10 {
            hourStr = "0" + "\(time.hour)"
        }
        
        var minStr = "\(time.minute)"
        if time.minute < 10 {
            minStr = "0" + "\(time.minute)"
        }
        timeLabel.text = "\(hourStr):\(minStr)"
    }
}
