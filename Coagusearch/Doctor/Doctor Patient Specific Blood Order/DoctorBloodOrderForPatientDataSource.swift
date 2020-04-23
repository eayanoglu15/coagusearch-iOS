//
//  DoctorBloodOrderForPatientDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 20.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol DoctorBloodOrderForPatientDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func showLoadingVC()
    func showLoginVC()
    func refreshOrderCardandTable()
}

class DoctorBloodOrderForPatientDataSource {
    var delegate: DoctorBloodOrderForPatientDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var patient: User?
    var pastOrders: [BloodOrder]?
    
    func getTableViewCount() -> Int {
        if let orders = pastOrders {
            return orders.count
        }
        return 0
    }
    
    func getOrderInfo(forIndex: Int) -> BloodOrder? {
        if let orders = pastOrders {
            if orders.count > 1 {
                return orders[(orders.count - 1) - forIndex]
            }
            return orders[forIndex]
        }
        return nil
    }
    
    func postBloodOrder(productType: BloodProductType, unit: Int, additionalNote: String?) {
        guard let currentPatient = self.patient, let bloodType = currentPatient.bloodType, let rhType = currentPatient.rhType else {
            return
        }
        let order = BloodOrder(patientId: currentPatient.userId, bloodType: bloodType, rhType: rhType, productType: productType, unit: unit, additionalNote: additionalNote)
        self.delegate?.showLoadingVC()
        coagusearchService?.postBloodOrder(order: order, completion: { (result, error) in
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
                if self.pastOrders != nil {
                    self.pastOrders!.append(order)
                } else {
                    self.pastOrders = [order]
                }
                
                DispatchQueue.main.async {
                    self.delegate?.refreshOrderCardandTable()
                }
            }
            
        })
    }
}
