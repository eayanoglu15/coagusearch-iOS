//
//  DoctorTodayAppointment.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 9.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct DoctorTodayAppointment : Codable {
    var appointmentHour: TimeInfo
    var patientId: Int
    var userName: String
    var userSurname: String
}
