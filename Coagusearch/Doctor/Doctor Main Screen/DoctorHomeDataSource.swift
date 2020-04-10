//
//  DoctorHomeDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 27.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol DoctorHomeDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func reloadTables()
    func showLoadingVC()
    func showLoginVC()
}

class DoctorHomeDataSource {
    var delegate: DoctorHomeDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var mainInfo: DoctorMainInfo?
    
    func getEmergencyPatientCount() -> Int {
        if let info = mainInfo {
            return info.emergencyPatients.count
        } else {
            return 0
        }
    }
    
    func getEmergencyPatient(index: Int) -> EmergencyPatientInfo? {
        if let info = mainInfo {
            return info.emergencyPatients[index]
        }
        return nil
    }
    
    
    func getPatientAppointmentCount() -> Int {
        if let info = mainInfo {
            return info.todayAppointments.count
        } else {
            return 0
        }
    }
    
    func getPatientAppointment(index: Int) -> DoctorTodayAppointment? {
        if let info = mainInfo {
            return info.todayAppointments[index]
        }
        return nil
    }
    
    func getMainScreenInfo() {
        coagusearchService?.getDoctorMainScreenInfo(completion: { (info, error) in
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
                if let data = info {
                    self.mainInfo = data
                    DispatchQueue.main.async {
                        self.delegate?.reloadTables()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                    }
                }
            }
        })
    }
}

struct EmergencyPatient {
    var patientName: String
    var time: String
    
    init(patientName: String, time: String) {
        self.patientName = patientName
        self.time = time
    }
}

struct TodaysAppointment {
    var patientName: String
    var time: String
    
    init(patientName: String, time: String) {
        self.patientName = patientName
        self.time = time
    }
}
