//
//  PatientAppointment.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 23.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct PatientAppointment : Codable {
    var day: Int
    var doctorName: String
    var doctorSurname: String
    var hour: Int
    var id: Int
    var minute: Int
    var month: Int
    var year: Int
}
