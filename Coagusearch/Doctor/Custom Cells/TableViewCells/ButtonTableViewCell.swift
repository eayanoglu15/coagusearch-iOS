//
//  ButtonTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 17.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: AnyObject {
    func buttonClicked()
}

class ButtonTableViewCell: UITableViewCell {
    weak var delegate: ButtonTableViewCellDelegate?
    
    @IBAction func button(_ sender: Any) {
        delegate?.buttonClicked()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
