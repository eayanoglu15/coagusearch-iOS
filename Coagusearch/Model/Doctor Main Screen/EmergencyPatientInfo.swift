//
//  EmergencyPatientInfo.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 9.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct EmergencyPatientInfo : Codable {
    var arrivalHour: TimeInfo
    var dataReady: Bool
    var patientId: Int
    var userAtAmbulance: Bool
    var userName: String
    var userSurname: String
}

