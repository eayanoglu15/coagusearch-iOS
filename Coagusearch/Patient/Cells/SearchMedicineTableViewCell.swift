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
}
