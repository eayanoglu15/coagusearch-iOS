//
//  BasicTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 4.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class BasicTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
