//
//  UserDrug.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 21.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct UserDrug : Codable {
    var id: Int?
    var mode: DrugMode
    var key: String?
    var custom: String?
    var frequency: Frequency
    var dosage: Double
    
    // Key Medication
    init(key: String, frequency: Frequency, dosage: Double) {
        self.mode = .Key
        self.key = key
        self.frequency = frequency
        self.dosage = dosage
    }
    
    // Custom Medication
    init(custom: String, frequency: Frequency, dosage: Double) {
        self.mode = .Custom
        self.custom = custom
        self.frequency = frequency
        self.dosage = dosage
    }
}

enum DrugMode: String, Codable {
    case Key = "KEY"
    case Custom = "CUSTOM"
}


