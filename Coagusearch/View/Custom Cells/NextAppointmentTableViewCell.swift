//
//  NextAppointmentTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 26.02.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

protocol NextAppointmentTableViewCellDelegate: AnyObject {
    func cancelAppointment()
}

class NextAppointmentTableViewCell: UITableViewCell {
    weak var delegate: NextAppointmentTableViewCellDelegate?
   
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var doctorIcon: UIImageView!
    @IBOutlet weak var doctorLabel: UILabel!
    
    @IBOutlet weak var dateIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeIcon: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.cancelAppointment()
    }
    
    func setAppointment(appointment: PatientAppointment) {
        doctorLabel.text = "\(appointment.doctorName) \(appointment.doctorSurname)"
        dateLabel.text = "\(appointment.day).\(appointment.month).\(appointment.year) "
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
