//
//  SearchMedicineTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 5.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class SearchMedicineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var medicineLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var userMedicine: UserDrug?
    
    func checkVisibility() {
        if let text = medicineLabel.text, !text.isEmpty {
            medicineLabel.isHidden = false
        } else {
            medicineLabel.isHidden = true
        }
    }
    
    func setUserDrug(medicine: UserDrug?) {
        userMedicine = medicine
        if let med = medicine {
            if let customName = med.custom {
                medicineLabel.text = customName
            } else if let keyName = med.key {
                medicineLabel.text = keyName
            } else {
                medicineLabel.text = ""
            }
        } else {
            medicineLabel.text = ""
        }
    }
    
    func setTableViewDataSourceDelegate(dataSourceDelegate: UITableViewDataSource & UITableViewDelegate & UISearchBarDelegate, forRow row: Int) {
        tableView.delegate = dataSourceDelegate
        tableView.dataSource = dataSourceDelegate
        searchBar.delegate = dataSourceDelegate
        tableView.tag = 4
        tableView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        searchBar.isHidden = true
        tableView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func changeArrow(selected: Bool) {
        if !selected {
            searchBar.isHidden = true
            tableView.isHidden = true
            arrowImageView.image = UIImage(named: IconNames.downArrow)
        } else {
            searchBar.isHidden = false
            tableView.isHidden = false
            arrowImageView.image = UIImage(named: IconNames.upArrow)
        }
    }
    
    func clearCell() {
        medicineLabel.text = nil
    }
}
