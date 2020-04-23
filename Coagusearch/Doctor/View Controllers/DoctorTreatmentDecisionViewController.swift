//
//  DoctorTreatmentDecisionViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 15.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class DoctorTreatmentDecisionViewController: UIViewController {
    @IBOutlet weak var treatmentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        hideKeyboard()
        title = "Treatment Decision".localized
        treatmentTableView.dataSource = self
        treatmentTableView.delegate = self
        treatmentTableView.tableFooterView = UIView()
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
    
    let ORDER_SECTION = 0
    let MEDICINE_SECTION = 1
    let DOSAGE_SECTION = 2
    let MEDICINE_BUTTON_SECTION = 3
    let SUGGESTION_HEADING_SECTION = 4
    
    var suggestionArray: [String] = ["TXA", "Fibrinogen Concentrate", "PCC"]
    
    var searchedText: String = "" // selectedCustomText
    
    var searchActive: Bool = false
    var searched: [String] = []
    
    func getSuggestionNumber() -> Int {
        if searchActive {
            return searched.count
        }
        return suggestionArray.count
    }
    
    var selectionArray = [false, false]
    
    let MEDICINE_SELECTION_INDEX = 0
    let DOSAGE_SELECTION_INDEX = 1
    
    func invertSelection(index: Int) {
        if selectionArray[index] {
            selectionArray[index] = false
        } else {
            selectionArray[index] = true
        }
    }
    
    func getSuggestion(index: Int) -> String {
        if searchActive {
            return searched[index]
        }
        return suggestionArray[index]
    }
    
    func getSearchResults(searchText: String) {
        searchedText = searchText
        searched = suggestionArray.filter({ (medicine : String) -> Bool in
            if medicine.lowercased().contains(searchText.lowercased()) {
                return true
            }
            return false
        })
        searchActive = (searchText != "")
    }
    
    func setSelection(index: Int, isSelected: Bool) {
        selectionArray[index] = isSelected
    }
}

extension DoctorTreatmentDecisionViewController: BasicWithButtonCellDelegate {
    func addCustomMedicine() {
        let searchCellIndexPath = IndexPath(row: 0, section: MEDICINE_SECTION)
        let searchCell = treatmentTableView.cellForRow(at: searchCellIndexPath) as! SearchMedicineTableViewCell
        searchCell.medicineLabel.text = searchedText
        
        //dataSource.selectedMode = .Custom
        
        // Close current cell
        invertSelection(index: MEDICINE_SELECTION_INDEX)
        let indexPath = IndexPath(row: 0, section: MEDICINE_SECTION)
        let cell = treatmentTableView.cellForRow(at: indexPath) as! SearchMedicineTableViewCell
        cell.changeArrow(selected: selectionArray[MEDICINE_SELECTION_INDEX])
        treatmentTableView.beginUpdates()
        treatmentTableView.endUpdates()
    }
}

extension DoctorTreatmentDecisionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        
        if indexPath.section == MEDICINE_SECTION {
            guard let tableViewCell = cell as? SearchMedicineTableViewCell else { return }
            tableViewCell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == treatmentTableView {
            switch indexPath.section {
            case ORDER_SECTION:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PRODUCT_ORDER_CELL, for: indexPath) as! ProductOrderTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                return cell
            case MEDICINE_SECTION:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_SEARCH_MEDICINE_CELL, for: indexPath) as! SearchMedicineTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                cell.medicineLabel.text = ""
                return cell
            case DOSAGE_SECTION:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_ENTER_DOSAGE_CELL, for: indexPath) as! EnterDosageTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                return cell
            case MEDICINE_BUTTON_SECTION:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_BUTTON_CELL, for: indexPath) as! ButtonTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                return cell
            case SUGGESTION_HEADING_SECTION:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_HEADING_CELL, for: indexPath) as! HeadingTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_SUGGESTION_CELL, for: indexPath) as! SuggestionTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                return cell
            }
        } else {
            if getSuggestionNumber() == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! BasicWithButtonTableViewCell
                cell.delegate = self
                cell.label.text = "No Result"
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath) as! BasicTableViewCell
            cell.label.text = getSuggestion(index: indexPath.row)
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == treatmentTableView {
            return 9
        }
        return 1
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == treatmentTableView {
            return 1
        } else {
            let count = getSuggestionNumber()
            if count == 0 {
                return 1
            }
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return HEIGHT_FOR_HEADER
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //(view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.systemPink
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
        //(view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == treatmentTableView {
            switch indexPath.section {
            case ORDER_SECTION:
                return 202
            case MEDICINE_SECTION:
                if selectionArray[MEDICINE_SELECTION_INDEX] {
                    return 300
                } else {
                    return CELL_HEIGHT
                }
            case DOSAGE_SECTION:
                if selectionArray[DOSAGE_SELECTION_INDEX] {
                    return ENTER_DOSADE_EXPANDED_CELL_HEIGHT
                } else {
                    return ENTER_DOSADE_CELL_HEIGHT
                }
            case MEDICINE_BUTTON_SECTION:
                return 40
            case SUGGESTION_HEADING_SECTION:
                return 21
            default:
                return 152
            }
        } else {
            return CELL_HEIGHT_SMALL
        }
    }
}

extension DoctorTreatmentDecisionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == treatmentTableView {
            if indexPath.section == MEDICINE_SECTION {
                let cell = treatmentTableView.cellForRow(at: indexPath) as! SearchMedicineTableViewCell
                invertSelection(index: MEDICINE_SELECTION_INDEX)
                cell.changeArrow(selected: selectionArray[MEDICINE_SELECTION_INDEX])
                
                if selectionArray[DOSAGE_SELECTION_INDEX] {
                    setSelection(index: DOSAGE_SELECTION_INDEX, isSelected: false)
                    let otherCellIndexPath = IndexPath(row: 0, section: DOSAGE_SECTION)
                    let otherCell = treatmentTableView.cellForRow(at: otherCellIndexPath) as! EnterDosageTableViewCell
                    otherCell.changeArrow(selected: false)
                }
                
                tableView.beginUpdates()
                tableView.endUpdates()
            } else if indexPath.section == DOSAGE_SECTION {
                let cell = treatmentTableView.cellForRow(at: indexPath) as! EnterDosageTableViewCell
                invertSelection(index: DOSAGE_SELECTION_INDEX)
                cell.changeArrow(selected: selectionArray[DOSAGE_SELECTION_INDEX])
                
                if selectionArray[MEDICINE_SELECTION_INDEX] {
                    setSelection(index: MEDICINE_SELECTION_INDEX, isSelected: false)
                    let otherCellIndexPath = IndexPath(row: 0, section: MEDICINE_SECTION)
                    let otherCell = treatmentTableView.cellForRow(at: otherCellIndexPath) as! SearchMedicineTableViewCell
                    otherCell.changeArrow(selected: false)
                }
                
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        } else {
            if getSuggestionNumber() != 0 {
                let searchCellIndex = IndexPath(row: 0, section: MEDICINE_SECTION)
                let searchCell = treatmentTableView.cellForRow(at: searchCellIndex) as! SearchMedicineTableViewCell
                
                let medicineCell = searchCell.tableView.cellForRow(at: indexPath) as! BasicTableViewCell
                
                let selectedMedicine = medicineCell.label.text
                searchCell.medicineLabel.text = selectedMedicine
                /*
                 dataSource.selectedMode = .Key
                 dataSource.selectedMedicineIndex = indexPath.row
                 */
                
                // Close current cell
                let indexPath = IndexPath(row: 0, section: MEDICINE_SECTION)
                let cell = treatmentTableView.cellForRow(at: indexPath) as! SearchMedicineTableViewCell
                invertSelection(index: MEDICINE_SELECTION_INDEX)
                cell.changeArrow(selected: selectionArray[MEDICINE_SELECTION_INDEX])
                treatmentTableView.beginUpdates()
                treatmentTableView.endUpdates()
            }
        }
    }
}

extension DoctorTreatmentDecisionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getSearchResults(searchText: searchText)
        let indexPath = IndexPath(row: 0, section: MEDICINE_SECTION)
        let cell = treatmentTableView.cellForRow(at: indexPath) as! SearchMedicineTableViewCell
        cell.tableView.reloadData()
    }
    
}

