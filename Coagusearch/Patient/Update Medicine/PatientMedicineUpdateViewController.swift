//
//  PatientMedicineUpdateViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 23.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension PatientMedicineUpdateViewController: PatientMedicineUpdateDataSourceDelegate {
    func routeToProfile() {
        navigationController?.popViewController(animated: true)
    }
    
    func reloadTableView() {
        self.medicineTableView.reloadData()
    }
}

extension PatientMedicineUpdateViewController: BasicWithButtonCellDelegate {
    func addCustomMedicine() {
        let searchCellIndexPath = IndexPath(row: 0, section: 0)
        let searchCell = medicineTableView.cellForRow(at: searchCellIndexPath) as! SearchMedicineTableViewCell
        searchCell.medicineLabel.text = dataSource.searchedText
    
        dataSource.selectedMode = .Custom
        if let med = dataSource.medicine {
            print("Medicine ", med)
        }
        // Close current cell
        dataSource.invertSelection(index: MEDICINE_SECTION)
        let indexPath = IndexPath(row: 0, section: MEDICINE_SECTION)
        let cell = medicineTableView.cellForRow(at: indexPath) as! SearchMedicineTableViewCell
        cell.changeArrow(selected: dataSource.isSelected(index: MEDICINE_SECTION))
        medicineTableView.beginUpdates()
        medicineTableView.endUpdates()
    }
}

class PatientMedicineUpdateViewController: UIViewController {
    let MEDICINE_SECTION = 0
    let FREQUENCY_SECTION = 1
    let DOSAGE_SECTION = 2
    
    @IBOutlet weak var medicineTableView: UITableView!
    
    var dataSource = PatientMedicineUpdateDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        stylize()
        
        title = "Update Medicine".localized
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
        
        medicineTableView.tableFooterView = UIView()
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.getMedicineList()
    }
    
    private func setupTableView() {
        let selectionCellNib = UINib(nibName: CELL_IDENTIFIER_SELECTION_CELL, bundle: nil)
        medicineTableView.register(selectionCellNib, forCellReuseIdentifier: CELL_IDENTIFIER_SELECTION_CELL)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func removeButtonTapped(_ sender: Any) {
        dataSource.deleteUserMedicine()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        dataSource.postMedicine()
    }
}

extension PatientMedicineUpdateViewController: SelectionCellDelegate {
    func setSelection(type: SelectionCellType, cellSectionNumber: Int, index: Int, value: String) {
        if type == SelectionCellType.Frequency {
            dataSource.selectedFrequencyIndex = index
        }
        if type == SelectionCellType.Dosage {
            if let dosage = Double(value) {
                dataSource.selectedDosage = dosage
            }
        }
        
        // Close current cell
        dataSource.invertSelection(index: cellSectionNumber)
        let indexPath = IndexPath(row: 0, section: cellSectionNumber)
        let cell = medicineTableView.cellForRow(at: indexPath) as! SelectionTableViewCell
        cell.changeArrow(selected: dataSource.isSelected(index: cellSectionNumber))
        medicineTableView.beginUpdates()
        medicineTableView.endUpdates()
    }
}

extension PatientMedicineUpdateViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == medicineTableView {
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            
            if indexPath.section == MEDICINE_SECTION {
                guard let tableViewCell = cell as? SearchMedicineTableViewCell else { return }
            tableViewCell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == medicineTableView {
            if indexPath.section == MEDICINE_SECTION {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_SEARCH_MEDICINE_CELL, for: indexPath) as! SearchMedicineTableViewCell
                
                if let med = dataSource.medicine {
                    if let customName = med.custom {
                        cell.medicineLabel.text = customName
                    } else if let keyName = med.key {
                        cell.medicineLabel.text = keyName
                    } else {
                        cell.medicineLabel.text = ""
                    }
                } else {
                    cell.medicineLabel.text = ""
                }
                
                return cell
            } else if indexPath.section == FREQUENCY_SECTION {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_SELECTION_CELL, for: indexPath) as! SelectionTableViewCell
                cell.setup(type: .Frequency, listData: dataSource.getFrequencyArray(), cellSectionNumber: FREQUENCY_SECTION)
                cell.delegate = self
                if let med = dataSource.medicine {
                    cell.selectionLabel.text = med.frequency.title
                } else {
                    cell.selectionLabel.text = ""
                }
                cell.pickerView.selectRow(dataSource.getMedicineFrequencyIndex(), inComponent: 0, animated: false)
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_SELECTION_CELL, for: indexPath) as! SelectionTableViewCell
                cell.setup(type: .Dosage, listData: dataSource.getDosageArray(), cellSectionNumber: DOSAGE_SECTION)
                cell.delegate = self
                if let med = dataSource.medicine {
                    var dosages = "\(med.dosage)"
                    if med.dosage > 1 {
                        dosages = dosages + " dosages".localized
                    } else {
                        dosages = dosages + " dosage".localized
                    }
                    cell.selectionLabel.text = dosages
                } else {
                    cell.selectionLabel.text = ""
                }
                cell.pickerView.selectRow(dataSource.getMedicineDosageIndex(), inComponent: 0, animated: false)
                return cell
            }
            
        } else {
            if dataSource.getSuggestionNumber() == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! BasicWithButtonTableViewCell
                cell.delegate = self
                cell.label.text = "No Result"
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath) as! BasicTableViewCell
            cell.label.text = dataSource.getSuggestion(index: indexPath.row)
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == medicineTableView {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == medicineTableView {
            return 1
        } else {
            let count = dataSource.getSuggestionNumber()
            if count == 0 {
                return 1
            }
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == medicineTableView {
            return HEIGHT_FOR_HEADER
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == medicineTableView {
            if dataSource.isSelected(index: indexPath.section) {
                if indexPath.section == MEDICINE_SECTION {
                    return 300
                }
                return CELL_HEIGHT_EXPANDED
            } else {
                return CELL_HEIGHT
            }
        } else {
            return CELL_HEIGHT_SMALL
        }
    }
}

extension PatientMedicineUpdateViewController: UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == medicineTableView {
            if indexPath.section == MEDICINE_SECTION {
                let cell = medicineTableView.cellForRow(at: indexPath) as! SearchMedicineTableViewCell
                dataSource.invertSelection(index: MEDICINE_SECTION)
                cell.changeArrow(selected: dataSource.isSelected(index: indexPath.section))
                
                if dataSource.isSelected(index: FREQUENCY_SECTION) {
                    dataSource.setSelection(index: FREQUENCY_SECTION, isSelected: false)
                    let otherCellIndexPath = IndexPath(row: 0, section: FREQUENCY_SECTION)
                    let otherCell = medicineTableView.cellForRow(at: otherCellIndexPath) as! SelectionTableViewCell
                    otherCell.changeArrow(selected: false)
                }
                
                if dataSource.isSelected(index: DOSAGE_SECTION) {
                    dataSource.setSelection(index: DOSAGE_SECTION, isSelected: false)
                    let otherCellIndexPath = IndexPath(row: 0, section: DOSAGE_SECTION)
                    let otherCell = medicineTableView.cellForRow(at: otherCellIndexPath) as! SelectionTableViewCell
                    otherCell.changeArrow(selected: false)
                }
                
                medicineTableView.beginUpdates()
                medicineTableView.endUpdates()
                
            } else if indexPath.section == FREQUENCY_SECTION {
                let cell = medicineTableView.cellForRow(at: indexPath) as! SelectionTableViewCell
                dataSource.invertSelection(index: FREQUENCY_SECTION)
                cell.changeArrow(selected: dataSource.isSelected(index: indexPath.section))
                
                if dataSource.isSelected(index: MEDICINE_SECTION) {
                    dataSource.setSelection(index: MEDICINE_SECTION, isSelected: false)
                    let otherCellIndexPath = IndexPath(row: 0, section: MEDICINE_SECTION)
                    let otherCell = medicineTableView.cellForRow(at: otherCellIndexPath) as! SearchMedicineTableViewCell
                    otherCell.changeArrow(selected: false)
                }
                
                if dataSource.isSelected(index: DOSAGE_SECTION) {
                    dataSource.setSelection(index: DOSAGE_SECTION, isSelected: false)
                    let otherCellIndexPath = IndexPath(row: 0, section: DOSAGE_SECTION)
                    let otherCell = medicineTableView.cellForRow(at: otherCellIndexPath) as! SelectionTableViewCell
                    otherCell.changeArrow(selected: false)
                }
                
                medicineTableView.beginUpdates()
                medicineTableView.endUpdates()
                
            } else if indexPath.section == DOSAGE_SECTION {
                let cell = medicineTableView.cellForRow(at: indexPath) as! SelectionTableViewCell
                dataSource.invertSelection(index: DOSAGE_SECTION)
                cell.changeArrow(selected: dataSource.isSelected(index: indexPath.section))
                
                if dataSource.isSelected(index: MEDICINE_SECTION) {
                    dataSource.setSelection(index: MEDICINE_SECTION, isSelected: false)
                    let otherCellIndexPath = IndexPath(row: 0, section: MEDICINE_SECTION)
                    let otherCell = medicineTableView.cellForRow(at: otherCellIndexPath) as! SearchMedicineTableViewCell
                    otherCell.changeArrow(selected: false)
                }
                
                if dataSource.isSelected(index: FREQUENCY_SECTION) {
                    dataSource.setSelection(index: FREQUENCY_SECTION, isSelected: false)
                    let otherCellIndexPath = IndexPath(row: 0, section: FREQUENCY_SECTION)
                    let otherCell = medicineTableView.cellForRow(at: otherCellIndexPath) as! SelectionTableViewCell
                    otherCell.changeArrow(selected: false)
                }
                
                medicineTableView.beginUpdates()
                medicineTableView.endUpdates()
            }
            
        } else {
            if dataSource.getSuggestionNumber() != 0 {
                let searchCellIndex = IndexPath(row: 0, section: 0)
                let searchCell = medicineTableView.cellForRow(at: searchCellIndex) as! SearchMedicineTableViewCell
                
                let medicineCell = searchCell.tableView.cellForRow(at: indexPath) as! BasicTableViewCell
                
                let selectedMedicine = medicineCell.label.text
                searchCell.medicineLabel.text = selectedMedicine
                dataSource.selectedMode = .Key
                dataSource.selectedMedicineIndex = indexPath.row
                
                // Close current cell
                dataSource.invertSelection(index: MEDICINE_SECTION)
                let indexPath = IndexPath(row: 0, section: MEDICINE_SECTION)
                let cell = medicineTableView.cellForRow(at: indexPath) as! SearchMedicineTableViewCell
                cell.changeArrow(selected: dataSource.isSelected(index: MEDICINE_SECTION))
                medicineTableView.beginUpdates()
                medicineTableView.endUpdates()
            }
        }
    }
    
}

extension PatientMedicineUpdateViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.getSearchResults(searchText: searchText)
        //medicineTableView.reloadData() // Aslında içerideki
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = medicineTableView.cellForRow(at: indexPath) as! SearchMedicineTableViewCell
        cell.tableView.reloadData()
        /*
        let table = view.viewWithTag(4) as! UITableView
        table.reloadData()
 */
 
    }
    
}
