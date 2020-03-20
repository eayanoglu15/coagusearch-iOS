//
//  DateTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 3.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func changeArrow(selected: Bool) {
        if !selected {
            datePicker.isHidden = true
            arrowImageView.image = UIImage(named: IconNames.downArrow)
        } else {
            datePicker.isHidden = false
            arrowImageView.image = UIImage(named: IconNames.upArrow)
        }
    }
 
}
