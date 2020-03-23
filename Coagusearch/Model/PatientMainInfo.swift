//
//  PatientMainInfo.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 24.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct PatientMainInfo : Codable {
    var patientMissingInfo: Bool
    var patientNextAppointment: PatientAppointment?
}
