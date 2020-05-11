//
//  MedicalTeamPrepareDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 7.05.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol MedicalTeamPrepareDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func showLoadingVC()
    func showLoginVC()
    func reloadTableView()
}

class MedicalTeamPrepareDataSource {
    var delegate: MedicalTeamPrepareDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var toDoList: [OrderToDo]?
    var doneList: [OrderToDo]?
    
    func getToDoList() {
        self.delegate?.showLoadingVC()
        coagusearchService?.getToDoList(completion: { (list, error) in
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
                if let list = list {
                    self.toDoList = list.todoOrderList
                    self.doneList = list.doneOrderList
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
    
    func setOrderReady(bloodOrderId: Int) {
        self.delegate?.showLoadingVC()
        coagusearchService?.setOrderReady(bloodOrderId: bloodOrderId, completion: { (list, error) in
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
                if let list = list {
                    self.toDoList = list.todoOrderList
                    self.doneList = list.doneOrderList
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
    
    
    func getTableViewCount(list: ListType) -> Int {
        switch list {
        case .TODO:
            if let list = toDoList {
                return list.count
            }
        case .DONE:
            if let list = doneList {
                return list.count
            }
        }
        return 0
    }
    
    func getOrderInfo(list: ListType, forIndex: Int) -> OrderToDo? {
        switch list {
        case .TODO:
            if let list = toDoList {
                return list[forIndex]
            }
        case .DONE:
            if let list = doneList {
                if list.count > 1 {
                    return list[(list.count - 1) - forIndex]
                }
                return list[forIndex]
            }
        }
        return nil
    }
}
