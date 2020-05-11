//
//  EnterDosageTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 15.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

protocol EnterDosageTableViewCellDelegate: AnyObject {
    func setSelectedDosage(dosage: Double)
    func setSelectedUnit(unit: String)
}

class EnterDosageTableViewCell: UITableViewCell {
    weak var delegate: EnterDosageTableViewCellDelegate?
    
    var selectedDosage: Double?
    var selectedUnit: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var dosageTextField: UITextField!
    @IBOutlet weak var unitPickerView: UIPickerView!
    @IBOutlet weak var expandView: UIView!
    
    var pickerData = ["g", "ml", "Unit"]//[String]()
    
    func setSuggestion(suggestion: TreatmentSuggestion) {
        if suggestion.kind == .Medicine {
            selectedDosage = suggestion.quantity
            selectedUnit = suggestion.unit
            setSelection()
        }
    }
    
    func clearCell() {
        selectedDosage = nil
        selectedUnit = nil
        if let first = pickerData.first {
            dosageLabel.text = "- " + first
            selectedUnit = first
            delegate?.setSelectedUnit(unit: first)
        } else {
            dosageLabel.text = "-"
        }
        setSelection()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        expandView.isHidden = true
        
        dosageTextField.isHidden = true
    
        unitPickerView.isHidden = true
        unitPickerView.delegate = self
        unitPickerView.dataSource = self
        
        dosageTextField.delegate = self
        
        if let first = pickerData.first {
            dosageLabel.text = "- " + first
            selectedUnit = first
            delegate?.setSelectedUnit(unit: first)
        } else {
            dosageLabel.text = "-"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func changeArrow(selected: Bool) {
        if !selected {
            expandView.isHidden = true
            dosageTextField.isHidden = true
            unitPickerView.isHidden = true
            arrowImageView.image = UIImage(named: IconNames.downArrow)
        } else {
            expandView.isHidden = false
            dosageTextField.isHidden = false
            unitPickerView.isHidden = false
            arrowImageView.image = UIImage(named: IconNames.upArrow)
        }
    }
    
    func setSelection() {
        var dosage = "-"
        if let selDosage = selectedDosage {
            dosage = "\(selDosage)"
        }
        if let unit = selectedUnit {
            dosageLabel.text = dosage + " " + unit
        } else {
            dosageLabel.text = dosage
        }
    }

}

extension EnterDosageTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedUnit = pickerData[row]
        if let unit = selectedUnit {
            delegate?.setSelectedUnit(unit: unit)
        }
        setSelection()
    }
}

extension EnterDosageTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.azul
        ]
        let atributedTitle = NSAttributedString(string: titleData, attributes: attributes)
        return atributedTitle
    }
}

extension EnterDosageTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if !text.isEmpty {
                if let dosage = Double(text) {
                    selectedDosage = dosage
                    if let dos = selectedDosage {
                        delegate?.setSelectedDosage(dosage: dos)
                    }
                    setSelection()
                }
            }
        }
    }
}

