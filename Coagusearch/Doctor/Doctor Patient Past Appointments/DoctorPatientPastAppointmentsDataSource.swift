//
//  DoctorPatientPastAppointmentsDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 15.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol DoctorPatientPastAppointmentsDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func reloadTableView()
    func showLoadingVC()
    func showLoginVC()
}

class DoctorPatientPastAppointmentsDataSource {
    var delegate: DoctorPatientPastAppointmentsDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    //var patientAppointmentsData: PatientAppointments?
    var pastAppointments = [PatientAppointment]()
    
    func getPastAppointments() {
        self.delegate?.reloadTableView()
    }
    
    func getTableViewCount() -> Int {
        return pastAppointments.count
    }
    
    func getAppointmentInfo(forIndex: Int) -> PatientAppointment? {
        return pastAppointments[forIndex]
    }
}

