//
//  LastAnalysisTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 29.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class LastAnalysisTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    func setup(time: String) {
        if time == "" {
            arrowImageView.isHidden = true
        } else {
            arrowImageView.isHidden = false
            timeLabel.text = time
        }
    }
    
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
