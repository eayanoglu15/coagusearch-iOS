//
//  DoctorTreatmentDecisionDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 2.05.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol DoctorTreatmentDecisionDataSourceDelegate {
    func showAlertMessage(title: String, message: String)
    func hideLoadingVC()
    func showLoadingVC()
    func showLoginVC()
    func reloadTableView()
    func informPatientBlood(isKnown: Bool)
}

class DoctorTreatmentDecisionDataSource {
    var delegate: DoctorTreatmentDecisionDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var patientId: Int?
    var testId: Int?
    var suggestionList: [TreatmentSuggestion]?
    var selectedSuggestion: TreatmentSuggestion?
    
    var bloodAdditionalNote: String?
    var medAdditionalNote: String?
    
    var clearBloodCell = false
    var clearMedCell = false
    var clearDosageCell = false
    
    func shouldClearBloodOrder() -> Bool {
        return clearBloodCell
    }
    
    func shouldClearMedicationOrder() -> Bool {
        return clearMedCell
    }
    
    func shouldClearDosage() -> Bool {
        return clearDosageCell
    }
    
    func bloodOrderCleared() {
        clearBloodCell = false
    }
    
    func medicationOrderCleared() {
        clearMedCell = false
    }
    
    func dosageCleared() {
        clearDosageCell = false
    }

    func setSuggestion(suggestion: TreatmentSuggestion) {
        selectedSuggestion = suggestion
    }
    
    func getSelectedSuggestion() -> TreatmentSuggestion? {
        return selectedSuggestion
    }
    
    func getSuggestions() {
        guard let id = testId else {
            return
        }
        self.delegate?.showLoadingVC()
        coagusearchService?.getSuggestionForAnalysis(bloodTestDataId: id, completion: { (dataInfo, error) in
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
                    let data = dataInfo.userSuggestionList
                    self.suggestionList = data
                    self.getPatientBloodType()
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                    }
                }
            }
        })
    }
    
    func getSuggestionCount() -> Int {
        if let list = suggestionList {
            return list.count
        }
        return 0
    }
    
    func getSuggestionInfo(forIndex: Int) -> TreatmentSuggestion? {
        if let list = suggestionList {
            return list[forIndex]
        }
        return nil
    }
    
    // MARK: Medication Search
    
    var medicationSuggestionArray: [String] = ["TXA", "Fibrinogen Concentrate", "PCC"]
    var searchedText: String = "" // selectedCustomText
    var searchActive: Bool = false
    var searched: [String] = []
    
    func getMedicationSuggestionNumber() -> Int {
        if searchActive {
            return searched.count
        }
        return medicationSuggestionArray.count
    }
    
    func getMedicationSuggestion(index: Int) -> String {
        if searchActive {
            return searched[index]
        }
        return medicationSuggestionArray[index]
    }
    
    func getSearchResults(searchText: String) {
        searchedText = searchText
        searched = medicationSuggestionArray.filter({ (medicine : String) -> Bool in
            if medicine.lowercased().contains(searchText.lowercased()) {
                return true
            }
            return false
        })
        searchActive = (searchText != "")
    }
    
    func getSearchedText() -> String {
        return searchedText
    }
    
    // MARK: Blood Order
    func orderBlood(product: OrderProductType?, quantity: Double?, note: String?) {
        guard let id = testId else {
            return
        }
        guard let orderProduct = product else {
            delegate?.showAlertMessage(title: "Missing Product Type".localized, message: "Please enter product type.".localized)
            return
        }
        guard let orderQuantity = quantity else {
            delegate?.showAlertMessage(title: "Missing Unit Amount".localized, message: "Please enter unit amount.".localized)
            return
        }
        print("orderProduct: ", orderProduct)
        print("orderQuantity: ", orderQuantity)
        print("note: ", note)
        guard let bloodType = patientBloodType else {
            delegate?.showAlertMessage(title: "Unknown Blood Type".localized, message: "Blood type of the patient is unknown".localized)
            return
        }
        guard let rhType = patientRhType else {
            delegate?.showAlertMessage(title: "Unknown Rh Type".localized, message: "Rh type of the patient is unknown".localized)
            return
        }
        let order = GeneralOrder(kind: .Blood, bloodType: bloodType, rhType: rhType, productType: orderProduct.rawValue, quantity: orderQuantity, bloodTestId: id, additionalNote: bloodAdditionalNote)
        postOrder(order: order)
    }
    
    // MARK: Medication Order
    var selectedMedicine: String?
    var selectedQuantity: Double?
    var selectedUnit: String?
    
    func setSelectedUnit(unit: String) {
        selectedUnit = unit
    }
    
    func setSelectedQuantity(quantity: Double) {
        selectedQuantity = quantity
    }
    
    func setSelectedMedicine(med: String) {
        selectedMedicine = med
    }
    
    func orderMedicine() {
        guard let id = testId else {
            return
        }
        guard var medicine = selectedMedicine else {
            delegate?.showAlertMessage(title: "Missing Medicine".localized, message: "Please enter medicine name".localized)
            return
        }
        guard let quantity = selectedQuantity else {
            delegate?.showAlertMessage(title: "Missing Medicine Dosage".localized, message: "Please enter dosage of medicine".localized)
            return
        }
        guard let unit = selectedUnit else {
            delegate?.showAlertMessage(title: "Missing Dosage Unit".localized, message: "Please enter unit of dosage".localized)
            return
        }
        if medicine == "Fibrinogen Concentrate" || medicine == "Fibrinojen Concentrate" {
            medicine = "FibrinojenConcentrate"
        }
        let order = GeneralOrder(kind: .Medicine, productType: medicine, quantity: quantity, unit: unit, bloodTestId: id, additionalNote: medAdditionalNote)
        postOrder(order: order)
    }
    
    // MARK: Patient Blood Type
    var patientBloodType: BloodType?
    var patientRhType: RhType?
    var patientWeight: Double?
    
    func getPatientBloodType() {
        guard let id = patientId else {
            return
        }
        self.delegate?.showLoadingVC()
        coagusearchService?.getDoctorPatientInfo(patientId: id, completion: { (pageInfo, error) in
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
                if let pageInfo = pageInfo {
                    if let patient = pageInfo.patientResponse {
                        self.patientBloodType = patient.bloodType
                        self.patientRhType = patient.rhType
                        self.patientWeight = patient.weight
                    }
                    DispatchQueue.main.async {
                        let isKnown = self.isBloodTypeKnown()
                        self.delegate?.informPatientBlood(isKnown: isKnown)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.showAlertMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                    }
                }
            }
        })
    }
    
    func isBloodTypeKnown() -> Bool {
        if (self.patientBloodType != nil) && (self.patientRhType != nil) {
            return true
        }
        return false
    }
    
    func getPatientWeight() -> Double? {
        return patientWeight
    }
    
    func postOrder(order: GeneralOrder) {
        self.delegate?.showLoadingVC()
        coagusearchService?.orderForAnalysis(order: order, completion: { (result, error) in
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
                if result {
                    DispatchQueue.main.async {
                        switch order.kind {
                        case .Medicine:
                            self.clearMedCell = true
                            self.clearDosageCell = true
                            self.selectedMedicine = nil
                            self.selectedQuantity = nil
                            self.selectedUnit = nil
                            if let suggestion = self.selectedSuggestion {
                                if suggestion.kind == .Medicine {
                                    self.selectedSuggestion = nil
                                }
                            }
                        case .Blood:
                            self.clearBloodCell = true
                            if let suggestion = self.selectedSuggestion {
                                if suggestion.kind == .Blood {
                                    self.selectedSuggestion = nil
                                }
                            }
                        }
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
}
