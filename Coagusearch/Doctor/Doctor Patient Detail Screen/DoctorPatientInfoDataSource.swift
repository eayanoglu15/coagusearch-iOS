//
//  DoctorPatientInfoDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 9.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol DoctorPatientInfoDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func showLoadingVC()
    func showLoginVC()
    func reloadTableView(patientName: String?)
}

class DoctorPatientInfoDataSource {
    var delegate: DoctorPatientInfoDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var patientId: Int?
    var pageInfo: DoctorPatientDetailInfo?
    
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
                    self.pageInfo = pageInfo
                    var patientName: String?
                    if let patient = pageInfo.patientResponse,
                        let name = patient.name, let surname = patient.surname {
                        patientName = "\(name) \(surname)"
                    }
                    DispatchQueue.main.async {
                        self.delegate?.reloadTableView(patientName: patientName)
                    }
                } else {
                    DispatchQueue.main.async {
                         self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                    }
                }
            }
        })
    }
    
    func getNextAppointment() -> PatientAppointment? {
        if let info = pageInfo, let appointmentInfo = info.userAppointmentResponse,
            let next = appointmentInfo.nextAppointment {
            return next
        }
        return nil
    }
    
    func getPatient() -> User? {
        if let info = pageInfo, let user = info.patientResponse {
            return user
        }
        return nil
    }
    
    func getLastDataAnalysisDate() -> String {
        if let info = pageInfo, let data = info.userDataResponse, let time = data.lastDataAnalysisTime {
            return "\(time.day)/\(time.month)/\(time.year)"
        }
        return "No past data analysis"
    }
}
