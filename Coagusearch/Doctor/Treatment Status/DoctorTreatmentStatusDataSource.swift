//
//  DoctorTreatmentStatusDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 2.05.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol DoctorTreatmentStatusDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func showLoadingVC()
    func showLoginVC()
    func reloadTableView()
}

class DoctorTreatmentStatusDataSource {
    var delegate: DoctorTreatmentStatusDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var patientId: Int?
    var orders: [GeneralOrder]?
    
    func getLastAnalysisData() {
        guard let id = patientId else {
                return
        }
        self.delegate?.showLoadingVC()
        coagusearchService?.getLastDataAnalysis(patientId: id, completion: { (dataInfo, error) in
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
                if let dataInfo = dataInfo {
                    self.orders = dataInfo.ordersOfData
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
        if let orders = orders {
            return orders.count
        }
        return 0
    }
    
    func getOrderInfo(forIndex: Int) -> GeneralOrder? {
        if let orders = orders {
            if orders.count > 0 {
                return orders[forIndex]
            }
        }
        return nil
    }
}
