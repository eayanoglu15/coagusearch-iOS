//
//  PatientInfoDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 21.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol PatientInfoDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoading()
    func routeToProfile()
    func showLoginVC()
}

class PatientInfoDataSource {
  
    var delegate: PatientInfoDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    func postUserInfo(name: String, surname: String, birthDay: Int?, birthMonth: Int?, birthYear: Int?, height: Double?, weight: Double?, bloodType: String?, rhType: String?, gender: String?) {
        coagusearchService?.postUserInfo(name: name, surname: surname, birthDay: birthDay, birthMonth: birthMonth, birthYear: birthYear, height: height, weight: weight, bloodType: bloodType, rhType: rhType, gender: gender, completion: { (success, error) in
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
                    DispatchQueue.main.async {
                        Manager.sharedInstance.currentUser?.name = name
                        Manager.sharedInstance.currentUser?.surname = surname
                        Manager.sharedInstance.currentUser?.birthDay = birthDay
                        Manager.sharedInstance.currentUser?.birthMonth = birthMonth
                        Manager.sharedInstance.currentUser?.birthYear = birthYear
                        Manager.sharedInstance.currentUser?.height = height
                        Manager.sharedInstance.currentUser?.weight = weight
                        
                        if bloodType == BloodType.A.rawValue {
                            Manager.sharedInstance.currentUser?.bloodType = BloodType.A
                        } else if bloodType == BloodType.B.rawValue {
                            Manager.sharedInstance.currentUser?.bloodType = BloodType.B
                        } else if bloodType == BloodType.AB.rawValue {
                            Manager.sharedInstance.currentUser?.bloodType = BloodType.AB
                        } else if bloodType == BloodType.O.rawValue {
                            Manager.sharedInstance.currentUser?.bloodType = BloodType.O
                        } else {
                            Manager.sharedInstance.currentUser?.bloodType = nil
                        }
                        
                        if rhType == RhType.Positive.rawValue {
                            Manager.sharedInstance.currentUser?.rhType = RhType.Positive
                        } else if rhType == RhType.Negative.rawValue {
                            Manager.sharedInstance.currentUser?.rhType = RhType.Negative
                        } else {
                            Manager.sharedInstance.currentUser?.rhType = nil
                        }
                        
                        if gender == Gender.Female.rawValue {
                            Manager.sharedInstance.currentUser?.gender = Gender.Female
                        } else if gender == Gender.Male.rawValue {
                            Manager.sharedInstance.currentUser?.gender = Gender.Male
                        } else {
                            Manager.sharedInstance.currentUser?.gender = nil
                        }
                        
                        self.delegate?.routeToProfile()
                    }
                } else {
                    self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                }
            }
            
        })
    }
    
}
