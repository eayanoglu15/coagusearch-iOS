//
//  AddMedicineDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 6.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol AddMedicineDataSourceDelegate {
    func endRefreshing()
    func refreshTableView()
    func showLoginVC()
    func showAlertMessage(title: String, message: String)
    func showLoadingVC()
    func hideLoadingVC()
    func routeToProfile()
}

class AddMedicineDataSource {
    var suggestionArray: [Drug] = []
    
    private var selectionArray = [false, false, false]
    
    var searchedText: String = "" // selectedCustomText
    
    var searchActive: Bool = false
    var searched: [Drug] = []
    
    var delegate: AddMedicineDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var selectedMode: DrugMode?
    
    var selectedMedicine: Drug?
    
    var selectedFrequencyIndex: Int = 0
    
    var selectedDosage: Double = 0.5
    
    var frequencyArray: [String] = []
    
    var drugData: Drugs?
    
    var dosageArray = ["0.5", "1", "1.5", "2", "2.5", "3"]
    
    func findSelectedMedicine(index: Int) {
        if searchActive {
            selectedMedicine = searched[index]
        } else {
            selectedMedicine = suggestionArray[index]
        }
    }
    
    func setSelectedMedicine(med: Drug) {
        selectedMedicine = med
    }
    
    func getSelectedMedicine() -> UserDrug? {
        guard let data = drugData, let mode = selectedMode else {
                return nil
        }
        let freqIndex = selectedFrequencyIndex
        let dosage = selectedDosage
        let freq = data.frequencies[freqIndex]
        switch mode {
        case .Key:
            guard let med = selectedMedicine else {
                return nil
            }
            let key = med.key
            return UserDrug(key: key, frequency: freq, dosage: dosage)
        case .Custom:
            if !searchedText.isEmpty {
                let drug = UserDrug(custom: searchedText, frequency: freq, dosage: dosage)
                return drug
            }
        }
        return nil
    }
    
    func postMedicine() {
        guard let medicine = getSelectedMedicine() else {
            delegate?.showAlertMessage(title: "Missing Information".localized, message: "Please fill all the fields that are related to your medicine".localized)
            return
        }
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
            return searched[index].content
        }
        return suggestionArray[index].content
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
        searched = suggestionArray.filter({ (medicine : Drug) -> Bool in
            if medicine.content.lowercased().contains(searchText.lowercased()) {
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
                self.delegate?.endRefreshing()
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
                    self.delegate?.refreshTableView()
                }
            }
        })
    }
    
    func setDataArrays (drugData: Drugs) {
        let drugs = drugData.drugs
        var suggestions = [Drug]()
        for drug in drugs {
            suggestions.append(drug)
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
    
    
}
