//
//  EmergencyTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 28.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class EmergencyTableViewCell: UITableViewCell {
    @IBOutlet weak var infoLabel: UILabel!
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
