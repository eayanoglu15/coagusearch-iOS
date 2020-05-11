//
//  Router.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 9.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case login(id: String, password: String)
    case getUser
    case getAllMedicine
    case getAvailableAppointments
    case postAppointment(day: Int, month: Int, year: Int, hour: Int, minute: Int)
    case saveUserInfo(name: String, surname: String)
    case saveMedicine
    case getUserMedicine
    case deleteMedicine(medicineId: Int)
    case getPatientAppointments
    case deleteUserAppointment(appointmentId: Int)
    case getPatientMainScreenInfo
    
    case getDoctorMainScreenInfo
    case getDoctorPatients
    case getPatientDetail(patientId: Int)
    case postBloodOrder
    case getPastGeneralBloodOrders
    case orderAfterAnalysis
    
    case getAllAnalysis(patientId: Int)
    case getLastAnalysis(patientId: Int)
    case getAnalysisById(bloodTestDataId: Int)
    case getSuggestionForAnalysis(bloodTestDataId: Int)
    
    case addPatient(id: Int, name: String, surname: String)
    case savePatientInfo(name: String, surname: String, patientId: Int)
    case getOrderToDoList
    case setOrderReady(bloodOrderId: Int)
    case saveAmbulancePatient(userIdentityNumber: Int)
    
    case callForNewAppointment(patientId: Int)
    case notifyMedicalTeam(patientId: Int)
    case getNotifications
    
    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .login, .postAppointment, .saveUserInfo, .saveMedicine, .deleteMedicine, .deleteUserAppointment, .getPatientDetail, .postBloodOrder, .orderAfterAnalysis, .getAllAnalysis, .getLastAnalysis, .getAnalysisById, .getSuggestionForAnalysis,
             .addPatient, .savePatientInfo, .setOrderReady, .saveAmbulancePatient, .callForNewAppointment, .notifyMedicalTeam:
            return .post
        case .getUser, .getAllMedicine, .getAvailableAppointments, .getUserMedicine, .getPatientAppointments, .getPatientMainScreenInfo, .getDoctorMainScreenInfo, .getDoctorPatients, .getPastGeneralBloodOrders, .getOrderToDoList, .getNotifications:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .login:
            return Endpoint.Login.rawValue
        case .getUser:
            return Endpoint.GetUser.rawValue
        case .getAllMedicine:
            return Endpoint.GetAllMedicine.rawValue
        case .getAvailableAppointments:
            return Endpoint.GetAvailableAppointments.rawValue
        case .postAppointment:
            return Endpoint.PostAppointment.rawValue
        case .saveUserInfo:
            return Endpoint.SaveUserInfo.rawValue
        case .saveMedicine:
            return Endpoint.SaveMedicine.rawValue
        case .getUserMedicine:
            return Endpoint.GetUserMedicine.rawValue
        case .deleteMedicine:
            return Endpoint.DeleteMedicine.rawValue
        case .getPatientAppointments:
            return Endpoint.GetUserAppointments.rawValue
        case .deleteUserAppointment:
            return Endpoint.DeleteUserAppointment.rawValue
        case .getPatientMainScreenInfo:
            return Endpoint.GetPatientMainScreenInfo.rawValue
        case .getDoctorMainScreenInfo:
            return Endpoint.GetDoctorMainScreen.rawValue
        case .getDoctorPatients:
            return Endpoint.GetDoctorPatients.rawValue
        case .getPatientDetail:
            return Endpoint.GetPatientDetail.rawValue
        case .postBloodOrder:
            return Endpoint.OrderBlood.rawValue
        case .getPastGeneralBloodOrders:
            return Endpoint.PastGeneralOrders.rawValue
        case .orderAfterAnalysis:
            return Endpoint.OrderAfterAnalysis.rawValue
        case .getAllAnalysis:
            return Endpoint.GetAllAnalysis.rawValue
        case .getLastAnalysis:
            return Endpoint.GetLastAnalysis.rawValue
        case .getAnalysisById:
            return Endpoint.GetAnalysisById.rawValue
        case .getSuggestionForAnalysis:
            return Endpoint.GetSuggestionForAnalysis.rawValue
        case .addPatient:
            return Endpoint.AddPatient.rawValue
        case .savePatientInfo:
            return Endpoint.SavePatientInfo.rawValue
        case .getOrderToDoList:
            return Endpoint.GetOrderToDo.rawValue
        case .setOrderReady:
            return Endpoint.SetOrderReady.rawValue
        case .saveAmbulancePatient:
            return Endpoint.SaveAmbulancePatient.rawValue
        case .callForNewAppointment:
            return Endpoint.callForNewAppointment.rawValue
        case .notifyMedicalTeam(let patientId):
            return Endpoint.notifyMedicalTeam.rawValue
        case .getNotifications:
            return Endpoint.getNotifications.rawValue
        }
    }
    
    // MARK: - Path
    var endpoint: Endpoint {
        switch self {
        case .login:
            return Endpoint.Login
        case .getUser:
            return Endpoint.GetUser
        case .getAllMedicine:
            return Endpoint.GetAllMedicine
        case .getAvailableAppointments:
            return Endpoint.GetAvailableAppointments
        case .postAppointment:
            return Endpoint.PostAppointment
        case .saveUserInfo:
            return Endpoint.SaveUserInfo
        case .saveMedicine:
            return Endpoint.SaveMedicine
        case .getUserMedicine:
            return Endpoint.GetUserMedicine
        case .deleteMedicine:
            return Endpoint.DeleteMedicine
        case .getPatientAppointments:
            return Endpoint.GetUserAppointments
        case .deleteUserAppointment:
            return Endpoint.DeleteUserAppointment
        case .getPatientMainScreenInfo:
            return Endpoint.GetPatientMainScreenInfo
        case .getDoctorMainScreenInfo:
            return Endpoint.GetDoctorMainScreen
        case .getDoctorPatients:
            return Endpoint.GetDoctorPatients
        case .getPatientDetail:
            return Endpoint.GetPatientDetail
        case .postBloodOrder:
            return Endpoint.OrderBlood
        case .getPastGeneralBloodOrders:
            return Endpoint.PastGeneralOrders
        case .orderAfterAnalysis:
            return Endpoint.OrderAfterAnalysis
        case .getAllAnalysis:
            return Endpoint.GetAllAnalysis
        case .getLastAnalysis:
            return Endpoint.GetLastAnalysis
        case .getAnalysisById:
            return Endpoint.GetAnalysisById
        case .getSuggestionForAnalysis:
            return Endpoint.GetSuggestionForAnalysis
        case .addPatient:
            return Endpoint.AddPatient
        case .savePatientInfo:
            return Endpoint.SavePatientInfo
        case .getOrderToDoList:
            return Endpoint.GetOrderToDo
        case .setOrderReady:
            return Endpoint.SetOrderReady
        case .saveAmbulancePatient:
            return Endpoint.SaveAmbulancePatient
        case .callForNewAppointment:
            return Endpoint.callForNewAppointment
        case .notifyMedicalTeam(let patientId):
            return Endpoint.notifyMedicalTeam
        case .getNotifications:
            return Endpoint.getNotifications
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .login(let id, let password):
            return [Parameter.id.rawValue: id, Parameter.password.rawValue: password]
        case .getUser, .getAllMedicine, .getAvailableAppointments, .saveMedicine, .getUserMedicine, .getPatientAppointments, .getPatientMainScreenInfo, .getDoctorMainScreenInfo, .getDoctorPatients, .postBloodOrder, .getPastGeneralBloodOrders, .orderAfterAnalysis, .addPatient, .getOrderToDoList, .getNotifications:
            return nil
        case .postAppointment(let day, let month, let year, let hour, let minute):
            return [Parameter.day.rawValue: day, Parameter.month.rawValue: month,
                    Parameter.year.rawValue: year, Parameter.hour.rawValue: hour,
                    Parameter.minute.rawValue: minute]
        case .saveUserInfo(let name, let surname):
            return [Parameter.name.rawValue: name, Parameter.surname.rawValue: surname]
        case .deleteMedicine(let medicineId):
            return [Parameter.medicineId.rawValue: medicineId]
        case .deleteUserAppointment(let appointmentId):
            return [Parameter.appointmentId.rawValue: appointmentId]
        case .getPatientDetail(let patientId):
            return [Parameter.patientId.rawValue: patientId]
        case .getAllAnalysis(let patientId):
            return [Parameter.patientId.rawValue: patientId]
        case .getLastAnalysis(let patientId):
            return [Parameter.patientId.rawValue: patientId]
        case .getAnalysisById(let bloodTestDataId):
            return [Parameter.bloodTestDataId.rawValue: bloodTestDataId]
        case .getSuggestionForAnalysis(let bloodTestDataId):
            return [Parameter.bloodTestDataId.rawValue: bloodTestDataId]
        case .savePatientInfo(let name, let surname, let patientId):
            return [Parameter.name.rawValue: name, Parameter.surname.rawValue: surname, Parameter.patientId.rawValue: patientId]
        case .setOrderReady(let bloodOrderId):
            return [Parameter.bloodOrderId.rawValue: bloodOrderId]
        case .saveAmbulancePatient(let userIdentityNumber):
            return [Parameter.userIdentityNumber.rawValue: userIdentityNumber]
        case .callForNewAppointment(let patientId):
            return [Parameter.patientId.rawValue: patientId]
        case .notifyMedicalTeam(let patientId):
            return [Parameter.patientId.rawValue: patientId]
        }
    }
    
    var header: HTTPHeaders {
        return NetworkBase.getDefaultHeaders()
        /*
         switch self {
         case .login, .getUser, .getAllMedicine, .getAvailableAppointmentsByUser:
         return NetworkBase.getDefaultHeaders()
         }
         */
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.method = method
        // Common Headers
        urlRequest.headers = header
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
