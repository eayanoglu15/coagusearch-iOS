//
//  DoctorPatientDetailInfo.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 9.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct DoctorPatientDetailInfo : Codable {
    var patientResponse: User?
    var userAppointmentResponse: PatientAllAppointments?
    var lastDataAnalysisTime: PatientAllDataAnalysis?
    var patientDrugs: [UserDrug]?
    var previousBloodOrders: [GeneralOrder]?
}

struct PatientAllAppointments : Codable {
    var nextAppointment: PatientAppointment?
    var oldAppointment: [PatientAppointment]?
}

struct PatientAllDataAnalysis : Codable {
    var id: Int?
    var testDate: DayYearInfo?
}

struct DayYearInfo: Codable {
    var day: Int
    var month: Int
    var year: Int
}

func getDateStr(date: DayYearInfo) -> String {
    return "\(date.day)/\(date.month)/\(date.year)"
}
