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
    @IBOutlet weak var unitImageView: UIImageView!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    
    var suggestion: TreatmentSuggestion?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(suggestion: TreatmentSuggestion) {
        self.suggestion = suggestion
        
        suggestionLabel.isHidden = true
        suggestionPartNumberLabel.isHidden = true
        
        diagnosisLabel.text = suggestion.diagnosis
        unitLabel.text = "\(suggestion.quantity) \(suggestion.unit)"
        
        productLabel.text = suggestion.product
        /*
        if suggestion.product == .FibrinojenConcentrate {
            productLabel.text = "Fibrinojen Concentrate"
        } else if suggestion.product == .PlateletConcentrate {
            productLabel.text = "Platelet Concentrate"
        } else {
            productLabel.text = suggestion.product.rawValue
        }
        */
        switch suggestion.kind {
        case .Blood:
            unitImageView.image = UIImage(named: IMAGE_NAME_TRANSFUSION)
            productImageView.image = UIImage(named: IMAGE_NAME_PRODUCT_TYPE)
        case .Medicine:
            unitImageView.image = UIImage(named: IMAGE_NAME_BLUE_DOSAGE)
            productImageView.image = UIImage(named: IMAGE_NAME_BLUE_MEDICINE)
        }
    }

    func getSuggestion() -> TreatmentSuggestion? {
        return suggestion
    }
    
}
