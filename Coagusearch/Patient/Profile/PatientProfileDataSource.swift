//
//  PatientProfileDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 23.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol PatientProfileDataSourceDelegate {
    func showLoadingVC()
    func hideLoadingVC()
    func showLoginVC()
    func reloadTableView()
    func showAlertMessage(title: String, message: String)
}

class PatientProfileDataSource {
    var delegate: PatientProfileDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var userDrugs: [UserDrug]?
    var selectedMedicine: UserDrug?
    
    func setSelectedMedicine(medicineId: Int) {
        if let userDrugs = userDrugs {
            selectedMedicine = userDrugs[medicineId]
        }
    }
    
    func getUserMedicineList() {
        self.delegate?.showLoadingVC()
        coagusearchService?.getUserMedicine(completion: { (userDrugs, error) in
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
                if let drugs = userDrugs {
                    self.userDrugs = drugs.userDrugs
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
    
    func getMedicineInfo(index: Int) -> MediceneInfo? {
        if let drugs = userDrugs {
            let med = drugs[index]
            var title = ""
            switch(med.mode) {
            case .Key:
                if let medTitle = med.key {
                    title = medTitle
                }
            case .Custom:
                if let medTitle = med.custom {
                    title = medTitle
                }
            }
            let frequency = med.frequency.title
            let dosageDouble = med.dosage
            var dosage: String
            if floor(dosageDouble) == dosageDouble {
                dosage = "\(Int(dosageDouble))"
            } else {
                dosage = "\(dosageDouble)"
            }
            if dosageDouble > 1 {
                dosage = dosage + " dosages".localized
            } else {
                dosage = dosage + " dosage".localized
            }
            
            return MediceneInfo(title: title, frequency: frequency, dosage: dosage)
        }
        return nil
    }
    
    func getUserDrugsCount() -> Int {
        if let drugs = userDrugs {
            return drugs.count
        }
        return 0
    }
    
}

struct MediceneInfo {
    var title: String
    var frequency: String
    var dosage: String
}
