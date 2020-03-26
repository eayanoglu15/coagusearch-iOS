//
//  MedicineTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 29.02.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

protocol MedicineTableViewCellDelegate: AnyObject {
    func updateMedicine(medicineIndex: Int)
}

class MedicineTableViewCell: UITableViewCell {
    weak var delegate: MedicineTableViewCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    
    var medicineIndex: Int?
    
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
