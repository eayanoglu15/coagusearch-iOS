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
        checkForMedicines()
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
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.getPatientDetail()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == SEGUE_SHOW_DOCTOR_PATIENT_PAST_APPOINTMENTS_HOME {
            let destinationVc = segue.destination as! DoctorPatientPastAppointmentsViewController
            if let pastAppointments = dataSource.getPastAppointments() {
                destinationVc.dataSource.pastAppointments = pastAppointments
            }
        }
        if segue.identifier == SEGUE_SHOW_DOCTOR_PATIENT_SPECIFIC_BLOOD_ORDER {
            let destinationVc = segue.destination as! DoctorBloodOrderForPatientViewController
            if let pastOrders = dataSource.getPastBloodOrders() {
                destinationVc.dataSource.pastOrders = pastOrders
            }
            if let patient = dataSource.getPatient() {
                destinationVc.dataSource.patient = patient
            }
        }
        if segue.identifier == SEGUE_SHOW_DOCTOR_PATIENT_LAST_ANALYSIS {
            let destinationVc = segue.destination as! DoctorLastDataAnalysisViewController
            if let patientId = dataSource.getPatientId() {
                destinationVc.dataSource.patientId = patientId
            }
        }
    }
    
    private func setupTableView() {
        let headingCellNib = UINib(nibName: CELL_IDENTIFIER_HEADING_CELL, bundle: nil)
        tableView.register(headingCellNib, forCellReuseIdentifier: CELL_IDENTIFIER_HEADING_CELL)
        let medicineCellNib = UINib(nibName: CELL_IDENTIFIER_MEDICINE_CELL, bundle: nil)
        tableView.register(medicineCellNib, forCellReuseIdentifier: CELL_IDENTIFIER_MEDICINE_CELL)
        let infoCellNib = UINib(nibName: CELL_IDENTIFIER_COLORED_LABEL_CELL, bundle: nil)
        tableView.register(infoCellNib, forCellReuseIdentifier: CELL_IDENTIFIER_COLORED_LABEL_CELL)
    }
    
    let INFO_SECTION = 0
    let MEDICINE_HEADING_SECTION = 1
    let MED_INFO_SECTION = 2
    var APPOINTMENT_SECTION = 3
    var ANALYSIS_SECTION = 4
    var PAST_APPOINTMENTS_SECTION = 5
    var BLOOD_ORDER_SECTION = 6
    var NUMBER_OF_SECTIONS = 7
    
    func checkForMedicines() {
        let medNum = dataSource.getMedicineNumber()
        if medNum == 0 || medNum == 1 {
            APPOINTMENT_SECTION = 3
            ANALYSIS_SECTION = 4
            PAST_APPOINTMENTS_SECTION = 5
            BLOOD_ORDER_SECTION = 6
            NUMBER_OF_SECTIONS = 7
        } else {
            APPOINTMENT_SECTION = 3 + medNum - 1
            ANALYSIS_SECTION = 4 + medNum - 1
            PAST_APPOINTMENTS_SECTION = 5 + medNum - 1
            BLOOD_ORDER_SECTION = 6 + medNum - 1
            NUMBER_OF_SECTIONS = 7 + medNum - 1
        }
    }
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
        } else if indexPath.section == MEDICINE_HEADING_SECTION {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_HEADING_CELL, for: indexPath) as! HeadingTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            cell.label.text = "Regular Medicines".localized
            return cell
        } else if indexPath.section > MEDICINE_HEADING_SECTION && indexPath.section < APPOINTMENT_SECTION {
            if indexPath.section == MED_INFO_SECTION {
                if dataSource.getMedicineNumber() == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_COLORED_LABEL_CELL, for: indexPath) as! ColoredLabelTableViewCell
                    cell.backgroundColor = UIColor.clear
                    cell.backgroundView?.backgroundColor = UIColor.clear
                    cell.label.text = "Patient does not have any recorded regular medicine".localized
                    return cell
                }
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_MEDICINE_CELL, for: indexPath) as! MedicineTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            if let medInfo = dataSource.getMedicine(forIndex: indexPath.section - MED_INFO_SECTION) {
                cell.setCellMedicine(med: medInfo, index: indexPath.section)
            }
            return cell
        } else if indexPath.section == APPOINTMENT_SECTION {
            if let next = dataSource.getNextAppointment() {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PATIENT_NEXT_APPOINTMENT_CELL, for: indexPath) as! PatientNextAppointmentTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                cell.setAppointment(next: next)
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
        return NUMBER_OF_SECTIONS
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
        if indexPath.section == ANALYSIS_SECTION {
            if dataSource.hasLastData() {
                performSegue(withIdentifier: SEGUE_SHOW_DOCTOR_PATIENT_LAST_ANALYSIS, sender: nil)
            }
        }
        if indexPath.section == APPOINTMENT_SECTION {
            if !dataSource.hasNextAppointment() {
                dataSource.callPatientForNewAppointment()
            }
        }
    }
}

