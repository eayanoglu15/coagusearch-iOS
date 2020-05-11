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
    case birthDay = "birthDay"
    case birthMonth = "birthMonth"
    case birthYear = "birthYear"
    case height = "height"
    case weight = "weight"
    case bloodType = "bloodType"
    case rhType = "rhType"
    case gender = "gender"
    case medicineId = "medicineId"
    case appointmentId = "appointmentId"
    case patientId = "patientId"
    case productType = "productType"
    case unit = "unit"
    case bloodTestDataId = "bloodTestDataId"
    case kind = "kind"
    case quantity = "quantity"
    case product = "product"
    case bloodTestId = "bloodTestId"
    case type = "type"
    case bloodOrderId = "bloodOrderId"
    case userIdentityNumber = "userIdentityNumber"
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
    case AddPatient = "/auth/savePatient"
    
    // MARK: Blood Order Controller
    case OrderBlood = "/blood/order"
    case PastGeneralOrders = "/blood/previousOrders"
    case OrderAfterAnalysis = "/blood/orderForUserData"
    
    case GetOrderToDo = "/blood/getOrdersForMedical"
    case SetOrderReady = "/blood/setReadyOrder"
    
    // MARK: Drug Controller
    case GetAllMedicine = "/drug/all"
    case DeleteMedicine = "/drug/deleteRegularMedication"
    case GetUserMedicine = "/drug/getByUser"
    case SaveMedicine = "/drug/saveRegularMedicine"
    
    // MARK: User Controller
    case GetPatientMainScreenInfo = "/users/getPatientMainScreen"
    case GetUser = "/users/me"
    case SaveUserInfo = "/users/saveBodyInfo"
    
    case GetDoctorMainScreen = "/users/getDoctorMainScreen"
    case GetDoctorPatients = "/users/getMyPatients"
    case GetPatientDetail = "/users/getPatientDetail"

    case SavePatientInfo = "/users/saveBodyInfoOfPatient"
    case SaveAmbulancePatient = "/users/saveAmbulancePatient"
    
    // MARK: Patient Data Controller
    case GetAllAnalysis = "/patientData/getAllBloodTest"
    case GetLastAnalysis = "/patientData/getLastOfPatient"
    case GetAnalysisById = "/patientData/getPatientBloodDataById"
    case GetSuggestionForAnalysis = "/patientData/getSuggestionOfBloodTest"

    // MARK: Notification
    case callForNewAppointment = "/notification/callPatient"
    case notifyMedicalTeam = "/notification/notify-medical"
    case getNotifications = "/notification/page"
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
