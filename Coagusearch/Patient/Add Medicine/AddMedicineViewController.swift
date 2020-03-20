//
//  AddMedicineViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 3.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension AddMedicineViewController: AddMedicineDataSourceDelegate {
    
}

extension AddMedicineViewController: BasicWithButtonCellDelegate {
    func addCustomMedicine() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = medicineTableView.cellForRow(at: indexPath) as! SearchMedicineTableViewCell
        cell.medicineLabel.text = dataSource.searchedText
    }
}

class AddMedicineViewController: UIViewController {
    
    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var coagusearchService: CoagusearchService?
    
    var dataSource = AddMedicineDataSource()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Medicine".localized
        self.hideKeyboard()
        dataSource.delegate = self
        medicineTableView.tableFooterView = UIView()
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        stylize()
        coagusearchService = CoagusearchServiceFactory.createService()
        self.refreshControl.tintColor = UIColor.twilightBlue
        self.medicineTableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(getMedicationData(_ :)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMedicationData()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
     @objc private func getMedicationData(_ sender: Any) {
        coagusearchService?.getAllMedicine(completion: { (drugs, error) in
            if let error = error {
                self.refreshControl.endRefreshing()
                
                if error.code == UNAUTHORIZED_ERROR_CODE {
                    Manager.sharedInstance.userDidLogout()
                    //self.showLoginVC()
                } else {
                    print(error)
                    //self.errorLabel.text = error.localizedDescription
                    //self.errorLabel.isHidden = false
                }
            } else {
                if let drugs = drugs {
                    self.setDataArrays(drugData: drugs)
                }
                DispatchQueue.main.async {
                    self.medicineTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        })
    }
    
    func getMedicationData() {
        //self.showLoadingVC()
        
        coagusearchService?.getAllMedicine(completion: { (drugs, error) in
            if let error = error {
                self.refreshControl.endRefreshing()
                
                if error.code == UNAUTHORIZED_ERROR_CODE {
                    Manager.sharedInstance.userDidLogout()
                    //self.showLoginVC()
                } else {
                    print(error)
                    //self.errorLabel.text = error.localizedDescription
                    //self.errorLabel.isHidden = false
                }
            } else {
                if let drugs = drugs {
                    self.setDataArrays(drugData: drugs)
                }
                DispatchQueue.main.async {
                    self.medicineTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        })
    }
    
    func setDataArrays (drugData: Drugs) {
        let drugs = drugData.drugs
        var suggestions = [String]()
        for drug in drugs {
            suggestions.append(drug.content)
        }
        let frequency = drugData.frequencies
        var frequencies = [String]()
        for freq in frequency {
            frequencies.append(freq.title)
        }
        dataSource.suggestionArray = suggestions
        dataSource.frequencyArray = frequencies
    }
    
}

extension AddMedicineViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == medicineTableView {
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            if indexPath.section == 0 {
                guard let tableViewCell = cell as? SearchMedicineTableViewCell else { return }
                tableViewCell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == medicineTableView {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "searchMedicineCell", for: indexPath) as! SearchMedicineTableViewCell
                return cell
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionTableViewCell
                cell.setup(type: .Frequency, listData: dataSource.getFrequencyArray(), cellSectionNumber: 1)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionTableViewCell
                cell.setup(type: .Dosage, listData: dataSource.getDosageArray(), cellSectionNumber: 2)
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
            return 16
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == medicineTableView {
            if dataSource.isSelected(index: indexPath.section) {
                if indexPath.section == 0 {
                    return 300
                }
                return 200
            } else {
                return 65
            }
        } else {
            return 45
        }
    }
}

extension AddMedicineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == medicineTableView {
            if indexPath.section != 0 {
                let cell = medicineTableView.cellForRow(at: indexPath) as! SelectionTableViewCell
                dataSource.invertSelection(index: indexPath.section)
                cell.changeArrow(selected: dataSource.isSelected(index: indexPath.section))
                medicineTableView.beginUpdates()
                medicineTableView.endUpdates()
            } else { // 0 searchMedicineCell
                let cell = medicineTableView.cellForRow(at: indexPath) as! SearchMedicineTableViewCell
                dataSource.invertSelection(index: indexPath.section)
                cell.changeArrow(selected: dataSource.isSelected(index: indexPath.section))
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
            }
        }
    }
    
}

extension AddMedicineViewController: UISearchBarDelegate {
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
