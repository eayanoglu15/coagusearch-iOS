//
//  PatientHomeDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 24.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol PatientHomeDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func reloadTableView()
    func showLoadingVC()
    func showLoginVC()
}

class PatientHomeDataSource {
    var delegate: PatientHomeDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var mainInfo: PatientMainInfo?
    
    func getMainScreenInfo() { coagusearchService?.getPatientMainScreenInfo(completion: { (info, error) in
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
        var info = 0
        print("hasMissingInfo()", hasMissingInfo())
        print("hasNextAppointment()", hasNextAppointment())
        if mainInfo != nil {
            if hasMissingInfo() {
                if hasNextAppointment() {
                    info = 2
                } else {
                    info = 1
                }
            } else {
               if hasNextAppointment() {
                    info = 1
                }
            }
            guard let notifyArray = mainInfo?.patientNotifications else {
                return info
            }
            return info + notifyArray.count
        }
        return info
    }
    
    func hasMissingInfo() -> Bool {
        if let data = mainInfo {
            return data.patientMissingInfo
        }
        return false
    }
    
    func hasNextAppointment() -> Bool {
        if let data = mainInfo {
            if data.patientNextAppointment != nil {
                return true
            }
        }
        return false
    }
    
    func getNextAppointmentInfo() -> PatientAppointment? {
        if let data = mainInfo {
            if let next = data.patientNextAppointment {
                return next
            }
        }
        return nil
    }
    
    func getNotification(index: Int) -> NotificationStruct? {
        guard let mainInfo = mainInfo, let notificationArray = mainInfo.patientNotifications else {
            return nil
        }
        if hasMissingInfo() && hasNextAppointment() {
            return notificationArray[index - 2]
        } else if hasMissingInfo() {
            return notificationArray[index - 1]
        } else if hasNextAppointment() {
            return notificationArray[index - 1]
        } else {
            return notificationArray[index]
        }
    }
}
