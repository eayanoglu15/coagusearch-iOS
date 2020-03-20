//
//  Enums.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 16.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

enum Parameter: String {
    case id = "identity_number"
    case password = "password"
    case day = "day"
    case month = "month"
    case year = "year"
    case hour = "hour"
    case minute = "minute"
}

enum Endpoint: String {
    case Login = "/auth/sign-in"
    case GetUser = "/users/me"
    case RefreshToken = "/auth/refresh"
    case GetAllMedicine = "/drug/all"
    case GetAvailableAppointmentsByUser = "/appointment/getByUser"
    case PostAppointment = "/appointment/save"
}

enum IconNames {
    static let quitButton = "logout"
    static let downArrow = "downArrow"
    static let upArrow = "upArrow"
    static let timeBlue = "TimeBlue"
    static let medicineBlue = "MedicineBlue"
    static let frequencyBlue = "FrequencyBlue"
    static let dosageBlue = "BlueDosage"
    static let dateBlue = "DateBlue"
}
