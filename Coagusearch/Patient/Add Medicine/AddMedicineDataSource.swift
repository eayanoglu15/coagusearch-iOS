//
//  AddMedicineDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 6.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol AddMedicineDataSourceDelegate {
   
}

class AddMedicineDataSource {
    var suggestionArray: [String] = []
    
    var selectionArray = [false, false, false]
    
    var searchedText: String = ""
    
    var searchActive: Bool = false
    var searched: [String] = []
    
    var delegate: AddMedicineDataSourceDelegate?
    
    //var frequencyArray: [String] = []
    var frequencyArray = ["Once a day", "Twice a day", "Three times a day"]
    
    //var dosageArray: [String] = []
    var dosageArray = ["0.5", "1", "1.5", "2"]
    
    func isSelected(index: Int) -> Bool {
        return selectionArray[index]
    }
    
    func invertSelection(index: Int) {
        selectionArray[index] = !selectionArray[index]
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
        
    }
}
