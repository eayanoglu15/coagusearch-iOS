//
//  GeneralOrder.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 30.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

enum OrderType: String, Codable {
    case Medicine = "Medicine"
    case Blood = "Blood"
}

enum OrderProductType: String, Codable {
    case FFP = "FFP"
    case FibrinojenConcentrate = "FibrinojenConcentrate"
    case PlateletConcentrate = "PlateletConcentrate"
    case TXA = "TXA"
    case PCC = "PCC"
}

struct Result : Codable {
    var result: String?
}

struct GeneralOrder : Codable {
    var bloodType: BloodType?
    var rhType: RhType?
    var additionalNote: String?
    var unit: String?
    var kind: OrderType
    var quantity: Double
    var productType: String
    var bloodTestId: Int?
    var patientName: String?
    var patientSurname: String?
    
    init(kind: OrderType, bloodType: BloodType, rhType: RhType, productType: String, quantity: Double, bloodTestId: Int?, additionalNote: String?) {
        self.kind = kind
        self.bloodType = bloodType
        self.rhType = rhType
        self.productType = productType
        self.quantity = quantity
        self.additionalNote = additionalNote
        self.bloodTestId = bloodTestId
    }
    
    init(kind: OrderType, productType: String, quantity: Double, unit: String, bloodTestId: Int, additionalNote: String?) {
        self.kind = kind
        self.productType = productType
        self.quantity = quantity
        self.unit = unit
        self.additionalNote = additionalNote
        self.bloodTestId = bloodTestId
    }
}
