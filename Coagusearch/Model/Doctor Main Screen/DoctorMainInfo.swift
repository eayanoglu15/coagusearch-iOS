//
//  DoctorMainInfo.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 9.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct DoctorMainInfo : Codable {
    var emergencyPatients: [EmergencyPatientInfo]
    var todayAppointments: [DoctorTodayAppointment]
}
