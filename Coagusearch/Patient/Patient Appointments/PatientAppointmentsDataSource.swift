//
//  PatientAppointmentsDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 23.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol PatientAppointmentsDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func reloadTableView()
    func showLoadingVC()
    func showLoginVC()
}

class PatientAppointmentsDataSource {
    var delegate: PatientAppointmentsDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var patientAppointmentsData: PatientAppointments?
    
    func getUserAppointmentsData() {
        self.delegate?.showLoadingVC()
        coagusearchService?.getPatientUserAppointments(completion: { (patientAppointments, error) in
            self.delegate?.hideLoadingVC()
            if let error = error {
                if error.code == UNAUTHORIZED_ERROR_CODE {
                    Manager.sharedInstance.userDidLogout()
                    self.delegate?.showLoginVC()
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: error.localizedDescription)
                    }
                }
            } else {
                if let data = patientAppointments {
                    self.patientAppointmentsData = data
                    DispatchQueue.main.async {
                        self.delegate?.reloadTableView()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                    }
                }
            }
        })
    }
    
    func getTableViewCount() -> Int {
        if let data = patientAppointmentsData {
            if let olds = data.oldAppointment {
                if hasNextAppointment() {
                    return olds.count + 1
                }
                return olds.count
            }
        }
        return 0
    }
    
    func hasNextAppointment() -> Bool {
        if let data = patientAppointmentsData {
            if data.nextAppointment != nil {
                return true
            }
        }
        return false
    }
    
    func getNextAppointmentInfo() -> PatientAppointment? {
        if let data = patientAppointmentsData {
            if let next = data.nextAppointment {
                return next
            }
        }
        return nil
    }
    
    func getAppointmentInfo(forIndex: Int) -> PatientAppointment? {
        if let data = patientAppointmentsData {
            if let olds = data.oldAppointment {
                if hasNextAppointment() {
                    return olds[forIndex - 1]
                } else {
                    return olds[forIndex]
                }
            }
        }
        return nil
    }
    
    func cancelNextAppointment() {
        guard let data = patientAppointmentsData, let next = data.nextAppointment else {
                return
            }
        let appointmentId = next.id
        self.delegate?.showLoadingVC()
        coagusearchService?.deletePatientNextAppointment(appointmentId: appointmentId, completion: { (success, error) in
            self.delegate?.hideLoadingVC()
            if let error = error {
                if error.code == UNAUTHORIZED_ERROR_CODE {
                    Manager.sharedInstance.userDidLogout()
                    self.delegate?.showLoginVC()
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: error.localizedDescription)
                    }
                }
            } else {
                if success {
                    self.getUserAppointmentsData()
                } else {
                    self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                }
            }
        })
    }
}
