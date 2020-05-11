//
//  DoctorNotificationsDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 11.05.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol DoctorNotificationsDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func showLoadingVC()
    func showLoginVC()
    func reloadTableView()
}

class DoctorNotificationsDataSource {
    var delegate: DoctorNotificationsDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var notifications: [NotificationStruct]?
    
    func getNotification(index: Int) -> NotificationStruct? {
        guard let notificationArray = notifications else {
            return nil
        }
        return notificationArray[index]
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
            return 0
        }
        return notificationArray.count
    }
    
}
