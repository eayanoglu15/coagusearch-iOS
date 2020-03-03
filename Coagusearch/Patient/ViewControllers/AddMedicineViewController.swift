//
//  AddMedicineViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 3.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class AddMedicineViewController: UIViewController {
    
    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var selectionArray = [false, false, false]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Medicine"
        medicineTableView.tableFooterView = UIView()
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        stylize()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddMedicineViewController: SelectionCellDelegate {
    func reloadTable() {
        medicineTableView.reloadData()
    }
    
}

extension AddMedicineViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionTableViewCell
        if indexPath.section == 0 {
            cell.setup(type: .Medicine, listData: ["Parol", "Appranax"])
        } else if indexPath.section == 1 {
            cell.setup(type: .Frequency, listData: ["Once a day", "Twice a day", "Three times a day"])
        } else {
            cell.setup(type: .Dosage, listData: ["0.5", "1", "1.5", "2"])
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectionArray[indexPath.section] {
            return 200
        } else {
            return 65
        }
    }
}

extension AddMedicineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = medicineTableView.cellForRow(at: indexPath) as! SelectionTableViewCell
        if selectionArray[indexPath.section] {
            selectionArray[indexPath.section] = false
        } else {
            selectionArray[indexPath.section] = true
        }
        cell.changeArrow(selected: selectionArray[indexPath.section])
        medicineTableView.beginUpdates()
        medicineTableView.endUpdates()
    }
}
