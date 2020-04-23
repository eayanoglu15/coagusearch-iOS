//
//  BloodOrder.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 16.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct BloodOrder : Codable {
    var bloodType: BloodType?
    var rhType: RhType?
    var patientId: Int?
    var productType: BloodProductType
    var unit: Int
    var additionalNote: String?
    
    init(bloodType: BloodType, rhType: RhType, productType: BloodProductType, unit: Int, additionalNote: String?) {
        self.bloodType = bloodType
        self.rhType = rhType
        self.productType = productType
        self.unit = unit
        self.additionalNote = additionalNote
    }
    
    init(patientId: Int, bloodType: BloodType, rhType: RhType, productType: BloodProductType, unit: Int, additionalNote: String?) {
        self.patientId = patientId
        self.bloodType = bloodType
        self.rhType = rhType
        self.productType = productType
        self.unit = unit
        self.additionalNote = additionalNote
    }
}

enum BloodProductType: String, Codable {
    case PC = "PC"
    case FFP = "FFP"
}

struct BloodOrderResult : Codable {
    var result: String
}

