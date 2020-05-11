//
//  PatientNextAppointmentTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 29.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class PatientNextAppointmentTableViewCell: UITableViewCell {
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
    
    func setAppointment(next: PatientAppointment) {
        dateLabel.text = "\(next.day)/\(next.month)/\(next.year)"
        let startHour = next.hour
        var endHour = startHour
        let startMin = next.minute
        let endMin = startMin + 20
        var endMinStr = "\(endMin)"
        if endMin >= 60 {
            endMinStr = "00"
            endHour += 1
        }
        var startMinStr = "\(startMin)"
        if startMin == 0 {
            startMinStr = "00"
        }
        timeLabel.text = "\(startHour):\(startMinStr) - \(endHour):\(endMinStr)"
    }

}
