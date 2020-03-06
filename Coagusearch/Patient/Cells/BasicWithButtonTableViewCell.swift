//
//  BasicWithButtonTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 6.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

protocol BasicWithButtonCellDelegate: AnyObject {
    func addCustomMedicine()
}

class BasicWithButtonTableViewCell: UITableViewCell {
    weak var delegate: BasicWithButtonCellDelegate?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        delegate?.addCustomMedicine()
    }
    
}
