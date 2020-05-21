//
//  GeneralBloodOrderInfoTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 24.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

protocol GeneralBloodOrderInfoTableViewCellDelegate: AnyObject {
    func setReadyButtonClicked(bloodOrderId: Int)
}

class GeneralBloodOrderInfoTableViewCell: UITableViewCell {
    weak var delegate: GeneralBloodOrderInfoTableViewCellDelegate?
    var order: OrderToDo?
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var patientStackView: UIStackView!
    @IBOutlet weak var patientLabel: UILabel!
    
    @IBOutlet weak var unitImageView: UIImageView!
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    
    @IBOutlet weak var bloodStackView: UIStackView!
    @IBOutlet weak var bloodLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setOrder(list: ListType, order: OrderToDo) {
        self.order = order
        // Fill fields
        if let patientName = order.patientName, let patientSurname = order.patientSurname {
            patientStackView.isHidden = false
            patientLabel.text = patientName + " " + patientSurname
        } else {
            patientStackView.isHidden = true
        }
        bloodStackView.isHidden = true
        
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
        
        switch order.kind {
        case .Blood:
            unitImageView.image = UIImage(named: IMAGE_NAME_TRANSFUSION)
            productImageView.image = UIImage(named: IMAGE_NAME_PRODUCT_TYPE)
            
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
            
            if let bloodType = order.bloodType, let rhType = order.rhType {
                if rhType == RhType.Positive {
                    bloodLabel.text = "\(bloodType) Rh+"
                } else {
                    bloodLabel.text = "\(bloodType) Rh-"
                }
                bloodStackView.isHidden = false
            }
            
        case .Medicine:
            unitImageView.image = UIImage(named: IMAGE_NAME_BLUE_DOSAGE)
            productImageView.image = UIImage(named: IMAGE_NAME_BLUE_MEDICINE)
            if let unit = order.unit {
                unitLabel.text = "\(order.quantity) \(unit)"
            }
        }
        
        if let note = order.additionalNote {
            noteLabel.isHidden = false
            noteLabel.text = note
        } else {
            noteLabel.isHidden = true
        }
        
        switch list {
        case .TODO:
            readyButton.isHidden = false
            colorView.backgroundColor = .peach
        case .DONE:
           readyButton.isHidden = true
            colorView.backgroundColor = .skyBlue
        }
    }

    @IBAction func readyButtonTapped(_ sender: Any) {
        if let order = self.order {
            self.delegate?.setReadyButtonClicked(bloodOrderId: order.bloodOrderId)
        }
    }
    
}
