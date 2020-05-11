//
//  MedicalTeamHomeDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 9.05.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol MedicalTeamHomeDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func showLoadingVC()
    func showLoginVC()
    func segueToAddPatient()
    func reloadTableView()
}

class MedicalTeamHomeDataSource {
    var delegate: MedicalTeamHomeDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var clearAmbulanceCell = false
    var newPatientId: Int?
    var notifications: [NotificationStruct]?
    
    func getNewPatientId() -> Int? {
        return newPatientId
    }
    
    func shouldClearCell() -> Bool {
        return clearAmbulanceCell
    }
    
    func cellCleared() {
        clearAmbulanceCell = false
    }
    
    func getNotification(index: Int) -> NotificationStruct? {
        guard let notificationArray = notifications else {
            return nil
        }
        return notificationArray[index - 1]
    }
    
    func getNotifications() {
        self.delegate?.showLoadingVC()
        coagusearchService?.getNotifications(completion: { (notifications, error) in
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
                
                    self.notifications = notifications
                    DispatchQueue.main.async {
                        self.delegate?.reloadTableView()
                    }
                
            }
        })
    }
    
    func getTableViewCount() -> Int {
        guard let notificationArray = notifications else {
            return 1
        }
        return notificationArray.count + 1
    }
    
    func saveAmbulancePatient(id: Int) {
        self.delegate?.showLoadingVC()
        coagusearchService?.saveAmbulancePatient(userIdentityNumber: id, completion: { (success, error) in
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
                    self.clearAmbulanceCell = true
                    DispatchQueue.main.async {
                        self.delegate?.reloadTableView()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.newPatientId = id
                        self.delegate?.segueToAddPatient()
                    }
                }
            }
        })
    }
    
}
