//
//  EnterDosageTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 15.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

protocol EnterDosageTableViewCellDelegate: AnyObject {
    //func setSelection(type: SelectionCellType, cellSectionNumber: Int, index: Int, value: String)
}

class EnterDosageTableViewCell: UITableViewCell {
    weak var delegate: EnterDosageTableViewCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var dosageTextField: UITextField!
    @IBOutlet weak var unitPickerView: UIPickerView!
    @IBOutlet weak var expandView: UIView!
    
    var pickerData = ["g", "ml", "unit"]//[String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
        expandView.isHidden = true
        
        dosageTextField.isHidden = true
    
        unitPickerView.isHidden = true
        unitPickerView.delegate = self
        unitPickerView.dataSource = self
 
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

}

extension EnterDosageTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /*
        selectedRow = row
        if cellType == .AppointmentDay {
            delegate.self?.setSelection(type: .AppointmentDay, cellSectionNumber: cellSectionNumber, index: row, value: pickerData[row])
        }
        if cellType == .TimeSlot {
            delegate.self?.setSelection(type: .TimeSlot, cellSectionNumber: cellSectionNumber, index: row, value: pickerData[row])
        } else {
            delegate.self?.setSelection(type: cellType, cellSectionNumber: cellSectionNumber, index: row, value: pickerData[row])
        }
        
        if cellType == .Dosage {
            if let dosageDouble = Double(pickerData[row]) {
                var dosage: String
                if floor(dosageDouble) == dosageDouble {
                    dosage = "\(Int(dosageDouble))"
                } else {
                    dosage = "\(dosageDouble)"
                }
                if dosageDouble > 1 {
                    dosage = dosage + " dosages".localized
                } else {
                    dosage = dosage + " dosage".localized
                }
                selectionLabel.text = dosage
            } else {
                selectionLabel.text = pickerData[row]
            }
        } else {
            selectionLabel.text = pickerData[row]
        }
 */
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
