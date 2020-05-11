//
//  OrderToDo.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 7.05.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct OrderToDoList : Codable {
    var todoOrderList: [OrderToDo]
    var doneOrderList: [OrderToDo]
}

struct OrderToDo : Codable {
    var bloodType: BloodType?
    var rhType: RhType?
    var additionalNote: String?
    var unit: String?
    var kind: OrderType
    var quantity: Double
    var productType: String
    var bloodOrderId: Int
    var patientName: String?
    var patientSurname: String?
    var ready: Bool
}

enum ListType {
    case TODO
    case DONE
}

