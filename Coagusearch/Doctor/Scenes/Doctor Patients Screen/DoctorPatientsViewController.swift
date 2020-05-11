//
//  DoctorPatientsViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 26.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension DoctorPatientsViewController: DoctorPatientsDataSourceDelegate {
    func reloadTable() {
        tableView.reloadData()
    }
}

class DoctorPatientsViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = DoctorPatientsDataSource()
    
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        stylize()
        title = "My Patients".localized
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.getPatients()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == SEGUE_SHOW_DOCTOR_PATIENT_INFO {
            if let selectedIndex = selectedIndex {
                let destinationVc = segue.destination as! DoctorPatientInfoViewController
                destinationVc.dataSource.patientId = selectedIndex
            }
        }
    }
}

extension DoctorPatientsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PATIENT_CELL, for: indexPath) as! PatientTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
        
        if let patient = dataSource.getPatient(index: indexPath.section) {
            if let name = patient.name, let surname = patient.surname, let hasNewData = patient.newData {
                cell.patientNameLabel.text = "\(name) \(surname)"
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.getPatientCount()
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
}

extension DoctorPatientsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let patientId = dataSource.getPatientId(index: indexPath.section) {
            selectedIndex = patientId
            performSegue(withIdentifier: SEGUE_SHOW_DOCTOR_PATIENT_INFO, sender: nil)
        }
    }
}


extension DoctorPatientsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.getSearchResults(searchText: searchText)
        tableView.reloadData()
    }
}
