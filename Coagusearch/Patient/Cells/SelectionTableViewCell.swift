//
//  SelectionTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 1.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

enum CellType {
    case TimeSlot
    case Medicine
    case Frequency
    case Dosage
}

protocol SelectionCellDelegate: AnyObject {
    func reloadTable()
}

class SelectionTableViewCell: UITableViewCell {
    weak var delegate: SelectionCellDelegate?
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var pickerData = [String]()
    
    var pickerIsHidden = false
    
    func setup(type: CellType, listData: [String]) {
        switch type {
        case .TimeSlot:
            icon.image = UIImage(named: "TimeBlue")
            titleLabel.text = "Time Slot"
        case .Medicine:
            icon.image = UIImage(named: "MedicineBlue")
            titleLabel.text = "Medicine"
        case .Frequency:
            icon.image = UIImage(named: "FrequencyBlue")
            titleLabel.text = "Frequency"
        case .Dosage:
            icon.image = UIImage(named: "BlueDosage")
            titleLabel.text = "Dosages"
        }
        if !listData.isEmpty {
            selectionLabel.text = listData.first
        }
        pickerData = listData
        arrowImageView.image = UIImage(named: "downArrow")
        selectionStyle = .none
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

    func changeArrow(selected: Bool) {
        if !selected {
            pickerView.isHidden = true
            arrowImageView.image = UIImage(named: "downArrow")
        } else {
            pickerView.isHidden = false
            arrowImageView.image = UIImage(named: "upArrow")
        }
    }
}

extension SelectionTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectionLabel.text = pickerData[row]
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
