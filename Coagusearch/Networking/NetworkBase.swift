//
//  NetworkBase.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 9.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation
import Alamofire

let UNEXPECTED_ERROR = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Unexpected Error", comment: "")])
let UNAUTHORIZED_ERROR = NSError(domain: "BE", code: UNAUTHORIZED_ERROR_CODE, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
let UNAUTHORIZED_ERROR_CODE = 401

enum ResponseType: Int {
    case Dictionary
    case Array
}

typealias UserReturnFunction = (User?, NSError?) -> Void
typealias TokenReturnFunction = (String?, NSError?) -> Void
typealias ResponseReturnFunction = (Any?, NSError?) -> Void
typealias DrugsReturnFunction = (Drugs?, NSError?) -> Void
typealias AppointmentCalendarReturnFunction = (AppointmentCalendar?, NSError?) -> Void
typealias SuccessReturnFunction = (Bool, NSError?) -> Void
typealias RegularMedicationsReturnFunction = (UserDrugs?, NSError?) -> Void
typealias PatientAppointmentsReturnFunction = (PatientAppointments?, NSError?) -> Void
typealias PatientMainInfoReturnFunction = (PatientMainInfo?, NSError?) -> Void

typealias DoctorMainInfoReturnFunction = (DoctorMainInfo?, NSError?) -> Void
typealias DoctorPatientsReturnFunction = ([DoctorPatient], NSError?) -> Void
typealias DoctorPatientDetailInfoReturnFunction = (DoctorPatientDetailInfo?, NSError?) -> Void
typealias BloodOrderReturnFunction = (BloodOrderResult?, NSError?) -> Void
typealias PastGeneralBloodOrderReturnFunction = ([GeneralOrder], NSError?) -> Void
typealias DataAnalysisListReturnFunction = (UserDataAnalysisList?, NSError?) -> Void
typealias DataAnalysisReturnFunction = (DataAnalysis?, NSError?) -> Void
typealias TreatmentSuggestionListReturnFunction = (TreatmentSuggestionList?, NSError?) -> Void
typealias ProtocolCodeReturnFunction = (ProtocolCode?, NSError?) -> Void

typealias OrderToDoReturnFunction = (OrderToDoList?, NSError?) -> Void

typealias NotificationsReturnFunction = ([NotificationStruct], NSError?) -> Void

protocol CoaguSearchService {
    // MARK: Patient
    // MARK: AUTH
    func refreshAuthToken(refreshToken: String, completion: @escaping TokenReturnFunction)
    func loginUser(id: String, password: String, completion: @escaping UserReturnFunction)
    // MARK: USER
    func getUser(completion: @escaping UserReturnFunction)
    func postUserInfo(name: String, surname: String, birthDay: Int?, birthMonth: Int?, birthYear: Int?, height: Double?, weight: Double?, bloodType: String?, rhType: String?, gender: String?, completion: @escaping SuccessReturnFunction)
    // MARK: APPOINTMENT
    func getAvailableAppointments(completion: @escaping AppointmentCalendarReturnFunction)
    func postAppointment(day: Int, month: Int, year: Int, hour: Int, minute: Int, completion: @escaping SuccessReturnFunction)
    // MARK: MEDICINE
    func getAllMedicine(completion: @escaping DrugsReturnFunction)
    func postRegularMedication(medication: UserDrug, completion: @escaping RegularMedicationsReturnFunction)
    func getUserMedicine(completion: @escaping RegularMedicationsReturnFunction)
    func deleteMedicine(medicineId: Int, completion: @escaping RegularMedicationsReturnFunction)
    func getPatientUserAppointments(completion: @escaping PatientAppointmentsReturnFunction)
    func deletePatientNextAppointment(appointmentId: Int, completion: @escaping SuccessReturnFunction)
    func getPatientMainScreenInfo(completion: @escaping PatientMainInfoReturnFunction)
    
    // MARK: Doctor
    func getDoctorMainScreenInfo(completion: @escaping DoctorMainInfoReturnFunction)
    func getDoctorPatients(completion: @escaping DoctorPatientsReturnFunction)
    func getDoctorPatientInfo(patientId: Int, completion: @escaping DoctorPatientDetailInfoReturnFunction)
    func postBloodOrder(order: BloodOrder, completion: @escaping BloodOrderReturnFunction)
    func getPastGeneralBloodOrders(completion: @escaping PastGeneralBloodOrderReturnFunction)
    func orderForAnalysis(order: GeneralOrder, completion: @escaping SuccessReturnFunction)
    
    // MARK: Data Analysis
    func getDataAnalysisList(patientId: Int, completion: @escaping DataAnalysisListReturnFunction)
    func getLastDataAnalysis(patientId: Int, completion: @escaping DataAnalysisReturnFunction)
    func getDataAnalysisByID(bloodTestDataId: Int, completion: @escaping DataAnalysisReturnFunction)
    func getSuggestionForAnalysis(bloodTestDataId: Int, completion: @escaping TreatmentSuggestionListReturnFunction)
    
    // MARK: Medical Team
    func savePatientInfo(name: String, surname: String, patientId: Int, birthDay: Int?, birthMonth: Int?, birthYear: Int?, height: Double?, weight: Double?, bloodType: String?, rhType: String?, gender: String?, completion: @escaping SuccessReturnFunction)
    func addPatient(id: Int, name: String, surname: String, birthDay: Int?, birthMonth: Int?, birthYear: Int?, height: Double?, weight: Double?, bloodType: String?, rhType: String?, gender: String?, completion: @escaping ProtocolCodeReturnFunction)
    func getToDoList(completion: @escaping OrderToDoReturnFunction)
    func setOrderReady(bloodOrderId: Int, completion: @escaping OrderToDoReturnFunction)
    func saveAmbulancePatient(userIdentityNumber: Int, completion: @escaping SuccessReturnFunction)
    
    // MARK: Notification
    func callForNewAppointment(patientId: Int, completion: @escaping SuccessReturnFunction)
    func notifyMedicalTeam(patientId: Int, completion: @escaping SuccessReturnFunction)
    func getNotifications(completion: @escaping NotificationsReturnFunction)
}

class NetworkBase {
    
    //let baseURL = "http:"//localhost:8080"
    
    let baseURL = "http://ec2-52-28-26-31.eu-central-1.compute.amazonaws.com:8080"

    // MARK: Custom Functions
    class func getDefaultHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = ["accept": "application/json",
                       "content-type": "application/json",
                       "accept-language": Locale.current.identifier,
                       "X-Timezone": TimeZone.current.identifier]
        
        return headers
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
