//
//  MedicalTeamAddPatientDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 6.05.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol MedicalTeamAddPatientDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func showLoadingVC()
    func showLoginVC()
    func showPatientLoginInfo(id: Int, code: String)
}

class MedicalTeamAddPatientDataSource {
    var delegate: MedicalTeamAddPatientDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var patientId: Int?
    
    func getPatientId() -> Int? {
        return patientId
    }
    
    func addPatient(id: Int, name: String, surname: String, birthDay: Int?, birthMonth: Int?, birthYear: Int?, height: Double?, weight: Double?, bloodType: String?, rhType: String?, gender: String?) {
       
        self.delegate?.showLoadingVC()
        coagusearchService?.addPatient(id: id, name: name, surname: surname, birthDay: birthDay, birthMonth: birthMonth, birthYear: birthYear, height: height, weight: weight, bloodType: bloodType, rhType: rhType, gender: gender, completion: { (code, error) in
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
                if let code = code {
                    DispatchQueue.main.async {
                        self.delegate?.showPatientLoginInfo(id: id, code: code.protocolCode)
                    }
                }
            }
        })
    }
    
}
