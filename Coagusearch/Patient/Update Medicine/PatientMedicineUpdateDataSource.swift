//
//  PatientMedicineUpdateDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 23.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol PatientMedicineUpdateDataSourceDelegate {
    func reloadTableView()
    func showLoginVC()
    func showAlertMessage(title: String, message: String)
    func showLoadingVC()
    func hideLoadingVC()
    func routeToProfile()
}

class PatientMedicineUpdateDataSource {
    var suggestionArray: [String] = []
    
    private var selectionArray = [false, false, false]
    
    var searchedText: String = "" // selectedCustomText
    
    var searchActive: Bool = false
    var searched: [String] = []
    
    var delegate: PatientMedicineUpdateDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var medicine: UserDrug? // get with segue
    
    var selectedMode: DrugMode?
    
    var selectedMedicineIndex: Int?
    
    var selectedFrequencyIndex: Int?
    
    var selectedDosage: Double?
    
    var frequencyArray: [String] = []
    
    var drugData: Drugs?
    
    var dosageArray = ["0.5", "1", "1.5", "2", "2.5", "3"]
    
    func checkForChange() {
        if var curMedicine = medicine, let data = drugData {
            if let mode = selectedMode {
                if mode != curMedicine.mode {
                    curMedicine.mode = mode
                }
            }
            switch curMedicine.mode {
            case .Key:
                if let keyIndex = selectedMedicineIndex {
                    let key = data.drugs[keyIndex].key
                    if curMedicine.key != key {
                        curMedicine.key = key
                    }
                }
            case .Custom:
                if !searchedText.isEmpty {
                    if curMedicine.custom != searchedText {
                        curMedicine.custom = searchedText
                    }
                }
            }
            if let freqIndex = selectedFrequencyIndex {
                let freq = data.frequencies[freqIndex]
                if freq != curMedicine.frequency {
                    curMedicine.frequency = freq
                }
            }
            if let dosage = selectedDosage  {
                if dosage != curMedicine.dosage {
                    curMedicine.dosage = dosage
                }
            }
            self.medicine = curMedicine
        }
    }
    
    func postMedicine() {
        checkForChange()
        if let medicine = medicine {
            self.delegate?.showLoadingVC()
            coagusearchService?.postRegularMedication(medication: medicine, completion: { (drugs, error) in
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
                    if drugs != nil {
                        DispatchQueue.main.async {
                            self.delegate?.routeToProfile()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                            
                        }
                    }
                }
            })
        }
    }
    
    func getMedicineFrequencyIndex() -> Int {
        if let medicine = medicine {
            if !frequencyArray.isEmpty {
                for i in 0...(frequencyArray.count-1) {
                    if frequencyArray[i] == medicine.frequency.title {
                        return i+1
                    }
                }
            }
        }
        return 1
    }
    
    func getMedicineDosageIndex() -> Int {
        if let medicine = medicine {
            for i in 0...(dosageArray.count-1) {
                if dosageArray[i] == "\(medicine.dosage)" {
                    return i
                }
            }
        }
        return 1
    }
    
    func isSelected(index: Int) -> Bool {
        return selectionArray[index]
    }
    
    func invertSelection(index: Int) {
        selectionArray[index] = !selectionArray[index]
    }
    
    func setSelection(index: Int, isSelected: Bool) {
        selectionArray[index] = isSelected
    }
    
    func getSuggestion(index: Int) -> String {
        if searchActive {
            return searched[index]
        }
        return suggestionArray[index]
    }
    
    func getSuggestionNumber() -> Int {
        if searchActive {
            return searched.count
        }
        return suggestionArray.count
    }
    
    func getFrequencyArray() -> [String] {
        return frequencyArray
    }
    
    func getDosageArray() -> [String] {
        return dosageArray
    }
    
    func getSearchedText() -> String {
        return searchedText
    }
    
    func getSearchResults(searchText: String) {
        searchedText = searchText
        searched = suggestionArray.filter({ (medicine : String) -> Bool in
            if medicine.lowercased().contains(searchText.lowercased()) {
                return true
            }
            return false
        })
        searchActive = (searchText != "")
    }
    
    func getMedicineList() {
        self.delegate?.showLoadingVC()
        coagusearchService?.getAllMedicine(completion: { (drugs, error) in
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
                if let drugs = drugs {
                    self.setDataArrays(drugData: drugs)
                }
                DispatchQueue.main.async {
                    self.delegate?.reloadTableView()
                }
            }
        })
    }
    
    func setDataArrays (drugData: Drugs) {
        let drugs = drugData.drugs
        var suggestions = [String]()
        for drug in drugs {
            suggestions.append(drug.content)
        }
        let frequency = drugData.frequencies
        var frequencies = [String]()
        for freq in frequency {
            frequencies.append(freq.title)
        }
        suggestionArray = suggestions
        frequencyArray = frequencies
        self.drugData = drugData
    }
    
    func deleteUserMedicine() {
        if let medicine = medicine, let id = medicine.id {
            self.delegate?.showLoadingVC()
            coagusearchService?.deleteMedicine(medicineId: id, completion: { (userDrugs, error) in
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
                    if userDrugs != nil {
                        DispatchQueue.main.async {
                            self.delegate?.routeToProfile()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                        }
                    }
                }
            })
        }
    }
}
