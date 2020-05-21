//
//  DoctorActionBloodOrderViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 6.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class DoctorActionBloodOrderViewController: UIViewController, DoctorActionBloodOrderDataSourceDelegate {
    var dataSource = DoctorActionBloodOrderDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Blood Order".localized
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == SEGUE_SHOW_DOCTOR_TREATMENT_DECISION {
            let destinationVc = segue.destination as! DoctorTreatmentDecisionViewController
            if let testId = dataSource.getTestId() {
                destinationVc.dataSource.testId = testId
            }
            if let patientId = dataSource.getPatientId() {
                destinationVc.dataSource.patientId = patientId
            }
        }
        if segue.identifier == SEGUE_SHOW_DOCTOR_TREATMENT_STATUS {
            let destinationVc = segue.destination as! DoctorTreatmentStatusViewController
            if let patientId = dataSource.getPatientId() {
                destinationVc.dataSource.patientId = patientId
            }
        }
    }
    
    @IBAction func callPatientButtonTapped(_ sender: Any) {
        dataSource.callPatientForNewAppointment()
    }
    
    @IBAction func notifyMedicalTeamButtonTapped(_ sender: Any) {
        dataSource.notifyMedicalTeam()
    }
    
    
}
