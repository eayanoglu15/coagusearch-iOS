//
//  MedicalTeamPatientsDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 6.05.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol MedicalTeamPatientsDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func reloadTable()
    func showLoadingVC()
    func showLoginVC()
    func segueToSelectedPatient()
}

class MedicalTeamPatientsDataSource {
    var delegate: MedicalTeamPatientsDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var patients: [DoctorPatient]?
    var selectedPatientId: Int?
    
    var searchActive: Bool = false
    var searched: [DoctorPatient] = []
    
    func setSelectedPatientId(index: Int) {
        selectedPatientId = index
    }
    
    func getSelectedPatientId() -> Int? {
        return selectedPatientId
    }
    
    func showSelectedPatient(index: Int) {
        if let patientId = getPatientId(index: index) {
            selectedPatientId = patientId
            self.delegate?.segueToSelectedPatient()
        }
    }
    
    func getPatients() {
        self.delegate?.showLoadingVC()
        coagusearchService?.getDoctorPatients(completion: { (patients, error) in
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
    
    func getPatient(index: Int) -> DoctorPatient? {
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
            searched = patients.filter({ (patient : DoctorPatient) -> Bool in
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
