//
//  MissingInfoTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 26.02.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

// missingInfoCell
class MissingInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
