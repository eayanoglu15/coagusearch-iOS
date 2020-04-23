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
    var userDataResponse: PatientAllDataAnalysis?
    var patientDrugs: [UserDrug]?
    var previousBloodOrders: [BloodOrder]?
}

struct PatientAllAppointments : Codable {
    var nextAppointment: PatientAppointment?
    var oldAppointment: [PatientAppointment]?
}

struct PatientAllDataAnalysis : Codable {
    var lastDataAnalysisTime: DayYearInfo?
    var oldAnalysis: [AnalysisStatus]
}

struct DayYearInfo: Codable {
    var day: Int
    var month: Int
    var year: Int
}

struct AnalysisStatus: Codable {
    var message: String
    var success: Bool
}
