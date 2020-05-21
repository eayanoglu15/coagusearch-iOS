//
//  DoctorActionBloodOrderDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 2.05.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol DoctorActionBloodOrderDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func showLoadingVC()
    func showLoginVC()
}

class DoctorActionBloodOrderDataSource {
    var delegate: DoctorActionBloodOrderDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var testId: Int?
    var patientId: Int?
    
    func getTestId() -> Int? {
        return testId
    }
    
    func getPatientId() -> Int? {
        return patientId
    }
    
    func notifyMedicalTeam() {
        guard let patientId = patientId else {
            return
        }
        self.delegate?.showLoadingVC()
        coagusearchService?.notifyMedicalTeam(patientId: patientId, completion: { (success, error) in
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
                    self.delegate?.showAlertMessage(title: "Medical Team Have Been Notified".localized, message: "Your medical team have been notified.".localized)
                } else {
                    self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                }
            }
            
        })
    }
    
    func callPatientForNewAppointment() {
        guard let patientId = patientId else {
            return
        }
        self.delegate?.showLoadingVC()
        coagusearchService?.callForNewAppointment(patientId: patientId, completion: { (success, error) in
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
                    self.delegate?.showAlertMessage(title: "Patient Has Been Notified".localized, message: "Your patient has been notified about getting a new appointment.".localized)
                } else {
                    self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                }
            }
            
        })
    }
}
