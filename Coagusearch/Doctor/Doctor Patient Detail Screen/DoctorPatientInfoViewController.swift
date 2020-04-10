//
//  DoctorPatientInfoViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 29.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension DoctorPatientInfoViewController: DoctorPatientInfoDataSourceDelegate {
    func reloadTableView(patientName: String?) {
        tableView.reloadData()
        title = patientName
    }
}

class DoctorPatientInfoViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = DoctorPatientInfoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.getPatientDetail()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    let INFO_SECTION = 0
    let APPOINTMENT_SECTION = 1
    let ANALYSIS_SECTION = 2
    let PAST_APPOINTMENTS_SECTION = 3
    let BLOOD_ORDER_SECTION = 4
}

extension DoctorPatientInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == INFO_SECTION {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PATIENT_INFO_CELL, for: indexPath) as! PatientInfoTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            if let user = dataSource.getPatient() {
                cell.setCell(user: user)
            }
            return cell
        } else if indexPath.section == APPOINTMENT_SECTION {
            if let next = dataSource.getNextAppointment() {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PATIENT_NEXT_APPOINTMENT_CELL, for: indexPath) as! PatientNextAppointmentTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                cell.dateLabel.text = "\(next.day)/\(next.month)/\(next.year)"
                let startHour = next.hour
                var endHour = startHour
                let startMin = next.minute
                let endMin = startMin + 20
                var endMinStr = "\(endMin)"
                if endMin >= 60 {
                    endMinStr = "00"
                    endHour += 1
                }
                var startMinStr = "\(startMin)"
                if startMin == 0 {
                    startMinStr = "00"
                }
                cell.timeLabel.text = "\(startHour):\(startMinStr) - \(endHour):\(endMinStr)"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_CALL_PATIENT_FOR_NEW_APPOINTMENT_CELL, for: indexPath) as! CallForAppointmentTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                return cell
            }
            
        } else if indexPath.section == ANALYSIS_SECTION {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_LAST_ANALYSIS_CELL, for: indexPath) as! LastAnalysisTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            let dateStr = dataSource.getLastDataAnalysisDate()
            cell.setup(time: dateStr)
            return cell
        } else if indexPath.section == PAST_APPOINTMENTS_SECTION {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PAST_APPOINTMENTS_CELL, for: indexPath) as! PastAppointmentsTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            
            return cell
        } else { // BLOOD_ORDER_SECTION
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_BLOOD_ORDER_FOR_PATIENT_CELL, for: indexPath) as! BloodOrderForPatientTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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

extension DoctorPatientInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

