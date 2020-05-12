//
//  PastAppointmentsTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 29.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class PastAppointmentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
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
    
    func setPatientAppointment(appointment: PatientAppointment) {
        dateLabel.text = "\(appointment.day)/\(appointment.month)/\(appointment.year) "
        var hourStr = "\(appointment.hour)"
        var minStr = "\(appointment.minute)"
        if hourStr.count == 1 {
            hourStr = "0" + hourStr
        }
        if minStr.count == 1 {
            minStr = "0" + minStr
        }
        timeLabel.text = "\(hourStr):\(minStr)"
    }
}
