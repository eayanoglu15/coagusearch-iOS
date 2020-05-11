//
//  MedicalTeamEditPatientDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 6.05.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol MedicalTeamEditPatientDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func showLoadingVC()
    func showLoginVC()
    func popView()
    func setPatientDetails()
}

class MedicalTeamEditPatientDataSource {
    var delegate: MedicalTeamEditPatientDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var patientId: Int?
    var patient: User?
    
    func getPatient() -> User? {
        return patient
    }
    
    func getPatientDetail() {
        guard let id = patientId else {
                return
        }
        self.delegate?.showLoadingVC()
        coagusearchService?.getDoctorPatientInfo(patientId: id, completion: { (pageInfo, error) in
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
                if let pageInfo = pageInfo {
                    self.patient = pageInfo.patientResponse
                    DispatchQueue.main.async {
                         self.delegate?.setPatientDetails()
                    }
                } else {
                    DispatchQueue.main.async {
                         self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                    }
                }
            }
        })
    }
    
    func savePatientInfo(name: String, surname: String, birthDay: Int?, birthMonth: Int?, birthYear: Int?, height: Double?, weight: Double?, bloodType: String?, rhType: String?, gender: String?) {
        guard let patientId = patientId else {
            return
        }
        self.delegate?.showLoadingVC()
        coagusearchService?.savePatientInfo(name: name, surname: surname, patientId: patientId, birthDay: birthDay, birthMonth: birthMonth, birthYear: birthYear, height: height, weight: weight, bloodType: bloodType, rhType: rhType, gender: gender, completion: { (success, error) in
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
                    DispatchQueue.main.async {
                        self.delegate?.popView()
                    }
                } else {
                    self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                }
            }
            
        })
    }
    
}
