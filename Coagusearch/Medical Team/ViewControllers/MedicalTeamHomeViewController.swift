//
//  MedicalTeamHomeViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 23.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class MedicalTeamHomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Welcome".localized
        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    var isSelected = false
    let REPORT_AMBULANCE_PATIENT_SECTION = 0

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func invertSelection() {
        if isSelected {
            isSelected = false
        } else {
            isSelected = true
        }
    }
}

extension MedicalTeamHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEIGHT_FOR_HEADER
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == REPORT_AMBULANCE_PATIENT_SECTION {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_REPORT_AMBULANCE_PATIENT_CELL, for: indexPath) as! ReportAmbulancePatientTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_MEDICAL_TEAM_NOTIFICATION_CELL, for: indexPath) as! MedicalTeamNotificationTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == REPORT_AMBULANCE_PATIENT_SECTION {
            if isSelected {
                return 152
            } else {
                return 52
            }
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension MedicalTeamHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == REPORT_AMBULANCE_PATIENT_SECTION {
            let cell = tableView.cellForRow(at: indexPath) as! ReportAmbulancePatientTableViewCell
            invertSelection()
            cell.changeArrow(selected: isSelected)
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

