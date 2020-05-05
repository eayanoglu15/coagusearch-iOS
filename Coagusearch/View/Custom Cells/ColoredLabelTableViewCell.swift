//
//  ColoredLabelTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 14.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class ColoredLabelTableViewCell: UITableViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var label: UILabel!
    
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
