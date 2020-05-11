//
//  MedicalTeamPatientsViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 23.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension MedicalTeamPatientsViewController: MedicalTeamPatientsDataSourceDelegate {
    func segueToSelectedPatient() {
        performSegue(withIdentifier: SEGUE_SHOW_MEDICAL_TEAM_PATIENT_INFO, sender: nil)
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}

class MedicalTeamPatientsViewController: UIViewController {
    @IBOutlet weak var patientCountLabel: UILabel!
    @IBOutlet weak var addPatientButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = MedicalTeamPatientsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Patients".localized
        // Do any additional setup after loading the view.
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
    
    @IBAction func addPatientButtonTapped(_ sender: Any) {
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == SEGUE_SHOW_MEDICAL_TEAM_PATIENT_INFO {
            if let selectedIndex = dataSource.getSelectedPatientId() {
                let destinationVc = segue.destination as! MedicalTeamEditPatientViewController
                destinationVc.dataSource.patientId = selectedIndex
            }
        }
    }
    
}

extension MedicalTeamPatientsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_MEDICAL_TEAM_PATIENT_CELL, for: indexPath) as! MedicalTeamPatientTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
        if let patient = dataSource.getPatient(index: indexPath.section) {
            if let name = patient.name, let surname = patient.surname {
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

extension MedicalTeamPatientsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.showSelectedPatient(index: indexPath.section)
    }
}


extension MedicalTeamPatientsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.getSearchResults(searchText: searchText)
        tableView.reloadData()
    }
}
