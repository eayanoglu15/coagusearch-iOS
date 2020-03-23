//
//  PatientAppointments.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 23.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct PatientAppointments : Codable {
    var nextAppointment: PatientAppointment?
    var oldAppointment: [PatientAppointment]?
}
