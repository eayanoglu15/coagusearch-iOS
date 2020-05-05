//
//  GivenMedicineTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 15.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class GivenMedicineTableViewCell: UITableViewCell {
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var medicineLabel: UILabel!
    
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
        if let unit = order.unit {
            qStr.append(" ")
            qStr.append(unit)
        }
        dosageLabel.text = qStr
        
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
        medicineLabel.text = productStr
    }

}
