//
//  SelectionTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 1.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

enum SelectionCellType {
    case AppointmentDay
    case TimeSlot
    case Medicine
    case Frequency
    case Dosage
}

protocol SelectionCellDelegate: AnyObject {
    func setSelection(type: SelectionCellType, cellSectionNumber: Int, index: Int, value: String)
}

class SelectionTableViewCell: UITableViewCell {
    weak var delegate: SelectionCellDelegate?
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var cellType = SelectionCellType.AppointmentDay
    
    var pickerData = [String]()
    
    var pickerIsHidden = false
    
    var selectedRow = 0
    
    var cellSectionNumber = 0
    
    func checkVisibility() {
        if let text = selectionLabel.text, !text.isEmpty {
            selectionLabel.isHidden = false
        } else {
            selectionLabel.isHidden = true
        }
    }
    
    func setup(type: SelectionCellType, listData: [String]?, cellSectionNumber: Int) {
        self.cellType = type
        self.cellSectionNumber = cellSectionNumber
        switch type {
        case .TimeSlot:
            icon.image = UIImage(named: IconNames.timeBlue)
            titleLabel.text = "Time Slot".localized
        case .Medicine:
            icon.image = UIImage(named: IconNames.medicineBlue)
            titleLabel.text = "Medicine".localized
        case .Frequency:
            icon.image = UIImage(named: IconNames.frequencyBlue)
            titleLabel.text = "Frequency".localized
        case .Dosage:
            icon.image = UIImage(named: IconNames.dosageBlue)
            titleLabel.text = "Dosages".localized
        case .AppointmentDay:
            icon.image = UIImage(named: IconNames.dateBlue)
            titleLabel.text = "Appointment Date".localized
        }
        if let list = listData {
            if !list.isEmpty {
                selectionLabel.text = list.first
                if cellType == .Dosage {
                    if let first = list.first {
                        selectionLabel.text = first + " dosage"
                    }
                }
            } else {
                selectionLabel.text = ""
            }
            pickerData = list
        }
        arrowImageView.image = UIImage(named: IconNames.downArrow)
        selectionStyle = .none
    }
    
    func setRow(index: Int) {
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setPickerData(data: [String]) {
        pickerData = data
        if !data.isEmpty {
            selectionLabel.text = data.first
        } else {
            selectionLabel.text = ""
        }
        pickerView.reloadAllComponents()
    }

    func changeArrow(selected: Bool) {
        if !selected {
            pickerView.isHidden = true
            arrowImageView.image = UIImage(named: IconNames.downArrow)
        } else {
            pickerView.isHidden = false
            arrowImageView.image = UIImage(named: IconNames.upArrow)
        }
    }
}

extension SelectionTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
    }
}

extension SelectionTableViewCell: UIPickerViewDataSource {
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
