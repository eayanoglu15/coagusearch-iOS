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
    case name = "name"
    case surname = "surname"
    case dateOfBirth = "dateOfBirth"
    case height = "height"
    case weight = "weight"
    case bloodType = "bloodType"
    case rhType = "rhType"
    case gender = "gender"
    case medicineId = "medicineId"
    case appointmentId = "appointmentId"
}

enum Endpoint: String {
    // MARK: Appointment Controller
    case GetAvailableAppointments = "/appointment/getAvailableTimes"
    case PostAppointment = "/appointment/save"
    case DeleteUserAppointment = "/appointment/delete"
    case GetUserAppointments = "/appointment/getByUser"
    
    // MARK: Auth Controller
    case RefreshToken = "/auth/refresh"
    case Login = "/auth/sign-in"
    
    // MARK: Drug Controller
    case GetAllMedicine = "/drug/all"
    case DeleteMedicine = "/drug/deleteRegularMedication"
    case GetUserMedicine = "/drug/getByUser"
    case SaveMedicine = "/drug/saveRegularMedicine"
    
    // MARK: User Controller
    case GetPatientMainScreenInfo = "/users/getPatientMainScreen"
    case GetUser = "/users/me"
    case SaveUserInfo = "/users/saveBodyInfo"
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
