//
//  DoctorBloodOrderDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 20.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol DoctorBloodOrderDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func reloadTable()
    func showLoadingVC()
    func showLoginVC()
    func refreshOrderCardAndTable()
}

class DoctorBloodOrderDataSource {
    var delegate: DoctorBloodOrderDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    private var pastOrders: [GeneralOrder]?
    
    func getPastOrders() {
        self.delegate?.showLoadingVC()
        coagusearchService?.getPastGeneralBloodOrders(completion: { (pastOrders, error) in
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
                self.pastOrders = pastOrders
                DispatchQueue.main.async {
                    self.delegate?.reloadTable()
                }
            }
        })
    }
    
    func postBloodOrder(bloodType: BloodType, rhType: RhType, productType: OrderProductType, unit: Double, additionalNote: String?) {
        self.delegate?.showLoadingVC()
        let order = BloodOrder(bloodType: bloodType, rhType: rhType, productType: productType, unit: unit, additionalNote: additionalNote)
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
                let newOrder = GeneralOrder(kind: .Medicine, bloodType: bloodType, rhType: rhType, productType: productType.rawValue, quantity: unit, bloodTestId: nil, additionalNote: nil)
                if self.pastOrders != nil {
                    self.pastOrders!.append(newOrder)
                } else {
                    self.pastOrders = [newOrder]
                }
                DispatchQueue.main.async {
                    self.delegate?.refreshOrderCardAndTable()
                }
            }
            
        })
    }
    
    func getPastOrderCount() -> Int {
        if let pastOrders = pastOrders {
            return pastOrders.count
        }
        return 0
    }
    
    func getPastOrder(index: Int) -> GeneralOrder? {
        if let orders = pastOrders {
            if orders.count > 1 {
                return orders[(orders.count - 1) - index]
            }
            return orders[index]
        }
        return nil
    }
}
