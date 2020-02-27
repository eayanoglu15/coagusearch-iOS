//
//  NextAppointmentTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 26.02.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class NextAppointmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outsideStackView: UIStackView!
    
    @IBOutlet weak var sideColorView: UIView!
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var appointmentStackView: UIStackView!
    
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var doctorStackView: UIStackView!
    @IBOutlet weak var doctorIcon: UIImageView!
    @IBOutlet weak var doctorLabel: UILabel!
    
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var dateIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var timeIcon: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
