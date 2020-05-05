//
//  TreatmentSuggestion.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 30.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct TreatmentSuggestionList : Codable {
    var userSuggestionList: [TreatmentSuggestion]
}

struct TreatmentSuggestion : Codable {
    var diagnosis: String
    var kind: OrderType
    var product: String
    var quantity: Double
    var unit: String
}
