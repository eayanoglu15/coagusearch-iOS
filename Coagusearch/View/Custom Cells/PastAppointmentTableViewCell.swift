//
//  PastAppointmentTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 28.02.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class PastAppointmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var doctorLabel: UILabel!
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

}
