//
//  SuggestionTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 15.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var suggestionPartNumberLabel: UILabel!
    
    @IBOutlet weak var diagnosisLabel: UILabel!
    @IBOutlet weak var unitTopConstraint: NSLayoutConstraint! // If no diagnosis name, set to 16. Otw, 46,5
    
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var productBottomConstraint: NSLayoutConstraint! // change if no info
    
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
