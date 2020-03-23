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
    case saveUserInfo(name: String, surname: String, dateOfBirth: String, height: Double, weight: Double, bloodType: String, rhType: String, gender: String)
    case saveMedicine
    case getUserMedicine
    case deleteMedicine(medicineId: Int)
    
    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .login, .postAppointment, .saveUserInfo, .saveMedicine, .deleteMedicine:
            return .post
        case .getUser, .getAllMedicine, .getAvailableAppointments, .getUserMedicine:
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
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .login(let id, let password):
            return [Parameter.id.rawValue: id, Parameter.password.rawValue: password]
        case .getUser, .getAllMedicine, .getAvailableAppointments, .saveMedicine, .getUserMedicine:
            return nil
        case .postAppointment(let day, let month, let year, let hour, let minute):
            return [Parameter.day.rawValue: day, Parameter.month.rawValue: month,
                    Parameter.year.rawValue: year, Parameter.hour.rawValue: hour,
                    Parameter.minute.rawValue: minute]
        case .saveUserInfo(let name, let surname, let dateOfBirth, let height, let weight, let bloodType, let rhType, let gender):
            return [Parameter.name.rawValue: name, Parameter.surname.rawValue: surname,
            Parameter.dateOfBirth.rawValue: dateOfBirth, Parameter.height.rawValue: height,
            Parameter.weight.rawValue: weight, Parameter.bloodType.rawValue: bloodType,
            Parameter.rhType.rawValue: rhType, Parameter.gender.rawValue: gender]
        case .deleteMedicine(let medicineId):
            return [Parameter.medicineId.rawValue: medicineId]
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
