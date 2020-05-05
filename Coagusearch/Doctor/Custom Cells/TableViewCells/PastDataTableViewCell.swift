//
//  PastDataTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 6.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class PastDataTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var colorView: NSLayoutConstraint!
    
    private var info: AnalysisDateInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDateInfo(info: AnalysisDateInfo) {
        self.info = info
        dateLabel.text = getDateStr(date: info.testDate)
    }

}
