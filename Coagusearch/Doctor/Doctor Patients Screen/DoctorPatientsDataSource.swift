//
//  DoctorPatientsDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 9.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol DoctorPatientsDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func reloadTable()
    func showLoadingVC()
    func showLoginVC()
 
}

class DoctorPatientsDataSource {
    var delegate: DoctorPatientsDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var patients: [User]?
    
    var searchActive: Bool = false
    var searched: [User] = []
    
    func getPatients() {
        coagusearchService?.getDoctorPatients(completion: { (patients, error) in
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
                self.patients = patients
                DispatchQueue.main.async {
                    self.delegate?.reloadTable()
                }
            }
        })
    }

    func getPatientCount() -> Int {
        if searchActive {
            return searched.count
        } else {
            if let patients = patients {
                return patients.count
            }
        }
        return 0
    }
    
    func getPatient(index: Int) -> User? {
        if searchActive {
            return searched[index]
        } else {
            if let patients = patients {
                return patients[index]
            }
        }
        return nil
    }
    
    func getPatientId(index: Int) -> Int? {
        if let patients = patients {
            return patients[index].userId
        }
        return nil
    }
    
    func getSearchResults(searchText: String) {
        if let patients = patients {
            searched = patients.filter({ (patient : User) -> Bool in
                if let name = patient.name {
                    if name.lowercased().contains(searchText.lowercased()) {
                        return true
                    }
                }
                if let surname = patient.surname {
                    if surname.lowercased().contains(searchText.lowercased()) {
                        return true
                    }
                }
                return false
            })
        }
        searchActive = (searchText != "")
    }
}
