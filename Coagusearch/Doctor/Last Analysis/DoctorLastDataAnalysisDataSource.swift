//
//  DoctorLastDataAnalysisDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 30.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol DoctorLastDataAnalysisDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func showLoadingVC()
    func showLoginVC()
    func reloadTableView()
}

class DoctorLastDataAnalysisDataSource {
    var delegate: DoctorLastDataAnalysisDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var patientId: Int?
    var testId: Int?
    var fibtemValues: [SingleTestResult]?
    var extemValues: [SingleTestResult]?
    var intemValues: [SingleTestResult]?
    
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
                    self.testId = dataInfo.bloodTestId
                    let data = dataInfo.userBloodData
                    for test in data {
                        if test.testName == TestName.Fibtem {
                            self.fibtemValues = test.categoryList
                        } else if test.testName == TestName.Extem {
                            self.extemValues = test.categoryList
                        } else if test.testName == TestName.Intem {
                            self.intemValues = test.categoryList
                        }
                    }
                    
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
    
    
    func getTableViewCount(testName: TestName) -> Int {
        switch testName {
        case .Extem:
            if let test = extemValues {
                return test.count
            }
        case .Fibtem:
            if let test = fibtemValues {
                return test.count
            }
        case .Intem:
            if let test = intemValues {
                return test.count
            }
        }
        return 0
    }
    
    func getOrderInfo(testName: TestName, forIndex: Int) -> SingleTestResult? {
        switch testName {
        case .Extem:
            if let test = extemValues {
                return test[forIndex]
            }
        case .Fibtem:
            if let test = fibtemValues {
                return test[forIndex]
            }
        case .Intem:
            if let test = intemValues {
                return test[forIndex]
            }
        }
        return nil
    }
    
    func getPatientId() -> Int? {
        return patientId
    }
    
    func getTestId() -> Int? {
        return testId
    }
}
