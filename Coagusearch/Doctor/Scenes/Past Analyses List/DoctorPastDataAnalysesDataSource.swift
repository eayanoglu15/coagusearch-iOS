//
//  DoctorPastDataAnalysesDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 1.05.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol DoctorPastDataAnalysesDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func showLoadingVC()
    func showLoginVC()
    func reloadTableView()
}

class DoctorPastDataAnalysesDataSource {
    var delegate: DoctorPastDataAnalysesDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var patientId: Int?
    var selectedTestId: Int?
    var selectedTestDate: String?
    var patientDataList: [AnalysisDateInfo]?
    
    func getDataList() {
        guard let id = patientId else {
            return
        }
        self.delegate?.showLoadingVC()
        coagusearchService?.getDataAnalysisList(patientId: id, completion: { (data, error) in
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
                if let data = data {
                    self.patientDataList = data.userTestList
                    
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
        if let list = patientDataList {
            return list.count
        }
        return 0
    }
    
    func getInfo(forIndex: Int) -> AnalysisDateInfo? {
        if let list = patientDataList {
            return list[forIndex]
        }
        return nil
    }
    
    func setSelectedTestIdAndDate(index: Int) {
        if let list = patientDataList {
            self.selectedTestId = list[index].id
            self.selectedTestDate = getDateStr(date: list[index].testDate)
        }
    }
    
    func getSelectedTestId() -> Int? {
        return selectedTestId
    }
    
    func getSelectedTestDate() -> String? {
        return selectedTestDate
    }
}
