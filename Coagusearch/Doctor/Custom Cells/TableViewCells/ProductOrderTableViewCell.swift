//
//  ProductOrderTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 15.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

protocol ProductOrderTableViewCellDelegate: AnyObject {
    func orderButtonClicked(product: OrderProductType?, quantity: Double?)
    func addNoteButtonTapped()
}

class ProductOrderTableViewCell: UITableViewCell {
    weak var delegate: ProductOrderTableViewCellDelegate?
    
    @IBOutlet weak var orderButton: UIButton!
    
    @IBOutlet weak var FFPButton: UIButton!
    @IBOutlet weak var plateletButton: UIButton!
    
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var unitTextField: UITextField!
    
    private var productTypeSelection = [false, false]
    
    func showSuggestion(suggestion: TreatmentSuggestion, weight: Double?) {
        if suggestion.product == "Platelet Concentrate" {
            stylizeButtonSelected(button: plateletButton)
            stylizeButtonUnselected(button: FFPButton)
            productTypeSelection = [false, true]
        }
        if let weight = weight {
            unitTextField.text = "\(weight * suggestion.quantity)"
        }
    }
    
    func stylizeButtonUnselected(button: UIButton) {
        button.borderWidth = 1
        button.borderColor = .lightBlueGrey
        button.cornerRadius = 8
        button.tintColor = .coolBlue
        button.backgroundColor = .clear
    }
    
    func stylizeButtonSelected(button: UIButton) {
        button.borderWidth = 0
        button.tintColor = .white
        button.backgroundColor = .coolBlue
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setButtons()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setButton(isEnabled: Bool) {
        if isEnabled {
            orderButton.isEnabled = true
            contentView.alpha = 1;
        } else {
            orderButton.isEnabled = false
            //orderButton.alpha = 0.5;
            contentView.alpha = 0.7
        }
    }
    
    func setButtons() {
        if productTypeSelection[0] {
            stylizeButtonSelected(button: FFPButton)
        } else {
            stylizeButtonUnselected(button: FFPButton)
        }
        
        if productTypeSelection[1] {
            stylizeButtonSelected(button: plateletButton)
        } else {
            stylizeButtonUnselected(button: plateletButton)
        }
    }

    @IBAction func FFPButtonTapped(_ sender: Any) {
        if productTypeSelection[0] {
            productTypeSelection[0] = false
            stylizeButtonUnselected(button: FFPButton)
        } else {
            if productTypeSelection[1] {
                productTypeSelection[1] = false
                stylizeButtonUnselected(button: plateletButton)
            }
            productTypeSelection[0] = true
            stylizeButtonSelected(button: FFPButton)
        }
    }
    
    @IBAction func plateletButtonTapped(_ sender: Any) {
        if productTypeSelection[1] {
            productTypeSelection[1] = false
            stylizeButtonUnselected(button: plateletButton)
        } else {
            if productTypeSelection[0] {
                productTypeSelection[0] = false
                stylizeButtonUnselected(button: FFPButton)
            }
            productTypeSelection[1] = true
            stylizeButtonSelected(button: plateletButton)
        }
    }
    
    @IBAction func addNoteButtonTapped(_ sender: Any) {
        self.delegate?.addNoteButtonTapped()
    }
    
    @IBAction func makeOrderButtonTapped(_ sender: Any) {
        var product: OrderProductType?
        var quantity: Double?
        if productTypeSelection[0] {
            product = .FFP
        } else if productTypeSelection[1] {
            product = .PlateletConcentrate
        }
        if let quantityStr = unitTextField.text {
            if !quantityStr.isEmpty {
                if let q = Double(quantityStr) {
                    quantity = q
                }
            }
        }
        delegate?.orderButtonClicked(product: product, quantity: quantity)
        stylizeButtonUnselected(button: FFPButton)
        stylizeButtonUnselected(button: plateletButton)
        unitTextField.text = ""
        productTypeSelection = [false, false]
    }
}
