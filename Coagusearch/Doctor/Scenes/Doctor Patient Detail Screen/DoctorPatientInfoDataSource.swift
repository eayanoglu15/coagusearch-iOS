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
                if !success {
                    self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                }
            }
            
        })
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
    
    func hasNextAppointment() -> Bool {
        if let info = pageInfo, let appointmentInfo = info.userAppointmentResponse,
            let _ = appointmentInfo.nextAppointment {
            return true
        }
        return false
    }
    
    func getPatient() -> User? {
        if let info = pageInfo, let user = info.patientResponse {
            return user
        }
        return nil
    }
    
    func getPatientId() -> Int? {
        /*
        if let info = pageInfo, let user = info.patientResponse {
            return user.userId
        }*/
        return patientId
    }
    
    func hasLastData() -> Bool {
        if let info = pageInfo, let lastData = info.lastDataAnalysisTime {
            return true
        }
        return false
    }
    
    func getLastDataAnalysisDate() -> String {
        if let info = pageInfo, let lastData = info.lastDataAnalysisTime, let time = lastData.testDate {
            return getDateStr(date: time)
        }
        return ""
    }
    
    func getMedicineNumber() -> Int {
        if let pageInfo = pageInfo, let drugs = pageInfo.patientDrugs {
            return drugs.count
        }
        return 0
    }
    
    func getMedicine(forIndex: Int) -> MediceneInfo? {
        if let pageInfo = pageInfo, let drugs = pageInfo.patientDrugs {
            let med = drugs[forIndex]
            var title = ""
            switch(med.mode) {
            case .Key:
                if let medTitle = med.key {
                    title = medTitle
                }
            case .Custom:
                if let medTitle = med.custom {
                    title = medTitle
                }
            }
            let frequency = med.frequency.title
            let dosageDouble = med.dosage
            var dosage: String
            if floor(dosageDouble) == dosageDouble {
                dosage = "\(Int(dosageDouble))"
            } else {
                dosage = "\(dosageDouble)"
            }
            if dosageDouble > 1 {
                dosage = dosage + " dosages".localized
            } else {
                dosage = dosage + " dosage".localized
            }
            
            return MediceneInfo(title: title, frequency: frequency, dosage: dosage)
        }
        return nil
    }
    
    func getPastAppointments() -> [PatientAppointment]? {
        if let info = pageInfo, let data = info.userAppointmentResponse, let oldData = data.oldAppointment {
            return oldData
        }
        return nil
    }
    
    func getPastBloodOrders() -> [GeneralOrder]? {
        if let info = pageInfo, let data = info.previousBloodOrders {
            return data
        }
        return nil
    }
}
