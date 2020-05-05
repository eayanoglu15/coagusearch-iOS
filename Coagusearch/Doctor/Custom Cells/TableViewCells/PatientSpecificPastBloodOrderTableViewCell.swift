//
//  PatientSpecificPastBloodOrderTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 29.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class PatientSpecificPastBloodOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(order: GeneralOrder) {
        let quantity = order.quantity
        var qStr = "\(quantity)"
        let qInt = Int(quantity)
        if quantity - Double(qInt) == 0 {
            qStr = "\(qInt)"
        }
        
        if quantity > 1 {
            unitLabel.text = qStr + " Units".localized
        } else {
            unitLabel.text = qStr + " Unit".localized
        }
        
        var productStr = order.productType
        switch order.productType {
        case "FFP":
            productStr = "Fresh Frozen Plasma"
            break
        case "FibrinojenConcentrate":
            productStr = "Fibrinojen Concentrate"
            break
        case "PlateletConcentrate":
            productStr = "Platelet Concentrate"
            break
        default:
            break
        }
        productLabel.text = productStr
    }
}
