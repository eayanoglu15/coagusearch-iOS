//
//  DoctorHomeViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 26.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension DoctorHomeViewController: DoctorHomeDataSourceDelegate {
    func reloadTables() {
        appointmentsTableView.reloadData()
        emergencyCollectionView.reloadData()
        emergencyPatientCountLabel.text = "\(dataSource.getEmergencyPatientCount())"
    }
}

class DoctorHomeViewController: UIViewController {
    @IBOutlet weak var emergencyCollectionView: UICollectionView!
    @IBOutlet weak var appointmentsTableView: UITableView!
    @IBOutlet weak var emergencyPatientCountLabel: UILabel!
    
    var dataSource = DoctorHomeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Today".localized
        emergencyCollectionView.dataSource = self
        emergencyCollectionView.delegate = self
        
        appointmentsTableView.dataSource = self
        appointmentsTableView.delegate = self
        appointmentsTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.getMainScreenInfo()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == SEGUE_SHOW_DOCTOR_EMERGENCY_PATIENT_LAST_ANALYSIS {
            let destinationVc = segue.destination as! DoctorLastDataAnalysisViewController
            if let patientId = dataSource.getSelectedEmergencyPatientId() {
                destinationVc.dataSource.patientId = patientId
            }
        }
    }

}

extension DoctorHomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.getEmergencyPatientCount()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER_EMERGENCY_PATIENT_CELL, for: indexPath) as! EmergencyPatientCollectionViewCell
        if let patient = dataSource.getEmergencyPatient(index: indexPath.row) {
            cell.setEmergencyPatient(patient: patient)
        }
        return cell
    }
}

extension DoctorHomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = emergencyCollectionView.cellForItem(at: indexPath) as! EmergencyPatientCollectionViewCell
        if cell.isDataReady() {
            if let patientId = cell.getPatientId() {
                dataSource.setSelectedEmergencyPatientId(id: patientId)
                performSegue(withIdentifier: SEGUE_SHOW_DOCTOR_EMERGENCY_PATIENT_LAST_ANALYSIS, sender: nil)
            }
        }
    }
}

extension DoctorHomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 128)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 64)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension DoctorHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_TODAYS_APPOINTMENT_CELL, for: indexPath) as! TodaysAppointmentTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        let patient = dataSource.getPatientAppointment(index: indexPath.section)
        if let patient = patient {
            cell.setCell(patient: patient)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.getPatientAppointmentCount()
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

extension DoctorHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
