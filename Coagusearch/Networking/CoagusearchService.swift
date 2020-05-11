//
//  CoagusearchService.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 9.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation
import Alamofire


class CoagusearchService: NetworkBase, CoaguSearchService {
    func callForNewAppointment(patientId: Int, completion: @escaping SuccessReturnFunction) {
        let route = Router.callForNewAppointment(patientId: patientId)
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(false, error)
                } else {
                    completion(false, UNEXPECTED_ERROR)
                }
                return
            }
            guard let success = response["success"] as? Bool,
                let message = response["message"] as? String else {
                    let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize success state", comment: "")])
                    completion(false, error)
                    return
            }
            completion(success, nil)
        }
    }
    
    func notifyMedicalTeam(patientId: Int, completion: @escaping SuccessReturnFunction) {
        let route = Router.notifyMedicalTeam(patientId: patientId)
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(false, error)
                } else {
                    completion(false, UNEXPECTED_ERROR)
                }
                return
            }
            guard let success = response["success"] as? Bool,
                let message = response["message"] as? String else {
                    let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize success state", comment: "")])
                    completion(false, error)
                    return
            }
            completion(success, nil)
        }
    }
    
    func getNotifications(completion: @escaping NotificationsReturnFunction) {
        let route = Router.getNotifications
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Array) { (response, error) in
            guard let response = response as? NSArray else {
                if let error = error {
                    completion([], error)
                } else {
                    completion([], UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let info = try JSONDecoder().decode([NotificationStruct].self, from: jsonData)
                completion(info, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize", comment: "")])
                completion([], error)
            }
        }
    }
    
    func saveAmbulancePatient(userIdentityNumber: Int, completion: @escaping SuccessReturnFunction) {
        let route = Router.saveAmbulancePatient(userIdentityNumber: userIdentityNumber)
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(false, error)
                } else {
                    completion(false, UNEXPECTED_ERROR)
                }
                return
            }
            guard let success = response["success"] as? Bool,
                let message = response["message"] as? String else {
                    let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize success state", comment: "")])
                    completion(false, error)
                    return
            }
            completion(success, nil)
        }
    }
    
    func setOrderReady(bloodOrderId: Int, completion: @escaping OrderToDoReturnFunction) {
        let route = Router.setOrderReady(bloodOrderId: bloodOrderId)
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let list = try JSONDecoder().decode(OrderToDoList.self, from: jsonData)
                completion(list, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize user.", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func getToDoList(completion: @escaping OrderToDoReturnFunction) {
        let route = Router.getOrderToDoList
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let list = try JSONDecoder().decode(OrderToDoList.self, from: jsonData)
                completion(list, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize user.", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func addPatient(id: Int, name: String, surname: String, birthDay: Int?, birthMonth: Int?, birthYear: Int?, height: Double?, weight: Double?, bloodType: String?, rhType: String?, gender: String?, completion: @escaping ProtocolCodeReturnFunction) {
        let route = Router.addPatient(id: id, name: name, surname: surname)
        
        var parameters = [String: Any]()
        parameters = [Parameter.name.rawValue: name, Parameter.surname.rawValue: surname, Parameter.id.rawValue: id, Parameter.type.rawValue: UserType.Patient.rawValue]
        
        if let birthDay = birthDay {
            parameters[Parameter.birthDay.rawValue] = birthDay
        }
        if let birthMonth = birthMonth {
            parameters[Parameter.birthMonth.rawValue] = birthMonth
        }
        if let birthYear = birthYear {
            parameters[Parameter.birthYear.rawValue] = birthYear
        }
        
        if let height = height {
            parameters[Parameter.height.rawValue] = height
        }
        if let weight = weight {
            parameters[Parameter.weight.rawValue] = weight
        }
        
        if let bloodType = bloodType {
            parameters[Parameter.bloodType.rawValue] = bloodType
        }
        if let rhType = rhType {
            parameters[Parameter.rhType.rawValue] = rhType
        }
        if let gender = gender {
            parameters[Parameter.gender.rawValue] = gender
        }
        
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let info = try JSONDecoder().decode(ProtocolCode.self, from: jsonData)
                completion(info, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func savePatientInfo(name: String, surname: String, patientId: Int, birthDay: Int?, birthMonth: Int?, birthYear: Int?, height: Double?, weight: Double?, bloodType: String?, rhType: String?, gender: String?, completion: @escaping SuccessReturnFunction) {
        
        let route = Router.savePatientInfo(name: name, surname: surname, patientId: patientId)
        
        var parameters = [String: Any]()
        parameters = [Parameter.name.rawValue: name, Parameter.surname.rawValue: surname, Parameter.patientId.rawValue: patientId]
        
        if let birthDay = birthDay {
            parameters[Parameter.birthDay.rawValue] = birthDay
        }
        if let birthMonth = birthMonth {
            parameters[Parameter.birthMonth.rawValue] = birthMonth
        }
        if let birthYear = birthYear {
            parameters[Parameter.birthYear.rawValue] = birthYear
        }
        
        if let height = height {
            parameters[Parameter.height.rawValue] = height
        }
        if let weight = weight {
            parameters[Parameter.weight.rawValue] = weight
        }
        
        if let bloodType = bloodType {
            parameters[Parameter.bloodType.rawValue] = bloodType
        }
        if let rhType = rhType {
            parameters[Parameter.rhType.rawValue] = rhType
        }
        if let gender = gender {
            parameters[Parameter.gender.rawValue] = gender
        }
        
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(false, error)
                } else {
                    completion(false, UNEXPECTED_ERROR)
                }
                return
            }
            guard let success = response["success"] as? Bool,
                let message = response["message"] as? String else {
                    let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize success state", comment: "")])
                    completion(false, error)
                    return
            }
            
            if success {
                completion(true, nil)
            } else {
                completion(false, NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey: message]))
            }
        }
    }
    
    func orderForAnalysis(order: GeneralOrder, completion: @escaping SuccessReturnFunction) {
        let route = Router.orderAfterAnalysis
        var parameters = [String: Any]()
        let kind = order.kind.rawValue
        let quantity = order.quantity
        let product = order.productType
        let bloodTestId = order.bloodTestId
        parameters = [Parameter.kind.rawValue: kind,
                      Parameter.quantity.rawValue: quantity,
                      Parameter.product.rawValue: product,
                      Parameter.bloodTestId.rawValue: bloodTestId]
        
        if let bloodType = order.bloodType, let rhType = order.rhType {
            parameters["bloodType"] = bloodType.rawValue
            parameters["rhType"] = rhType.rawValue
        }
        
        if let unit = order.unit {
            parameters[Parameter.unit.rawValue] = unit
        } else {
            parameters[Parameter.unit.rawValue] = "Unit"
        }
        
        if let note = order.additionalNote {
            parameters["additionalNote"] = note
        }
        
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(false, error)
                } else {
                    completion(false, UNEXPECTED_ERROR)
                }
                return
            }
            guard let success = response["success"] as? Bool,
                let message = response["message"] as? String else {
                    let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize success state", comment: "")])
                    completion(false, error)
                    return
            }
            
            if success {
                completion(true, nil)
            } else {
                completion(false, NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey: message]))
            }
        }
    }
    
    func getSuggestionForAnalysis(bloodTestDataId: Int, completion: @escaping TreatmentSuggestionListReturnFunction) {
        let route = Router.getSuggestionForAnalysis(bloodTestDataId: bloodTestDataId)
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let info = try JSONDecoder().decode(TreatmentSuggestionList.self, from: jsonData)
                completion(info, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func getDataAnalysisByID(bloodTestDataId: Int, completion: @escaping DataAnalysisReturnFunction) {
        let route = Router.getAnalysisById(bloodTestDataId: bloodTestDataId)
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let info = try JSONDecoder().decode(DataAnalysis.self, from: jsonData)
                completion(info, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func getLastDataAnalysis(patientId: Int, completion: @escaping DataAnalysisReturnFunction) {
        let route = Router.getLastAnalysis(patientId: patientId)
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let info = try JSONDecoder().decode(DataAnalysis.self, from: jsonData)
                completion(info, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func getDataAnalysisList(patientId: Int, completion: @escaping DataAnalysisListReturnFunction) {
        let route = Router.getAllAnalysis(patientId: patientId)
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let info = try JSONDecoder().decode(UserDataAnalysisList.self, from: jsonData)
                completion(info, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func getPastGeneralBloodOrders(completion: @escaping PastGeneralBloodOrderReturnFunction) {
        let route = Router.getPastGeneralBloodOrders
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Array) { (response, error) in
            guard let response = response as? NSArray else {
                if let error = error {
                    completion([], error)
                } else {
                    completion([], UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let info = try JSONDecoder().decode([GeneralOrder].self, from: jsonData)
                completion(info, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize", comment: "")])
                completion([], error)
            }
        }
    }
    
    func postBloodOrder(order: BloodOrder, completion: @escaping BloodOrderReturnFunction) {
        let route = Router.postBloodOrder
        
        var parameters: [String: Any] = ["productType": order.productType.rawValue]
        parameters["unit"] = order.unit
        
        if let bloodType = order.bloodType, let rhType = order.rhType {
            parameters["bloodType"] = bloodType.rawValue
            parameters["rhType"] = rhType.rawValue
        }
        
        if let patientId = order.patientId {
            parameters["patientId"] = patientId
        }
        
        if let additionalNote = order.additionalNote {
            parameters["additionalNote"] = additionalNote
        }
        
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let result = try JSONDecoder().decode(BloodOrderResult.self, from: jsonData)
                completion(result, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize appointment", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func getDoctorPatientInfo(patientId: Int, completion: @escaping DoctorPatientDetailInfoReturnFunction) {
        let route = Router.getPatientDetail(patientId: patientId)
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let info = try JSONDecoder().decode(DoctorPatientDetailInfo.self, from: jsonData)
                completion(info, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize.", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func getDoctorPatients(completion: @escaping DoctorPatientsReturnFunction) {
        let route = Router.getDoctorPatients
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Array) { (response, error) in
            guard let response = response as? NSArray else {
                if let error = error {
                    completion([], error)
                } else {
                    completion([], UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let info = try JSONDecoder().decode([DoctorPatient].self, from: jsonData)
                completion(info, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize", comment: "")])
                completion([], error)
            }
        }
    }
    
    func getDoctorMainScreenInfo(completion: @escaping DoctorMainInfoReturnFunction) {
        let route = Router.getDoctorMainScreenInfo
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let info = try JSONDecoder().decode(DoctorMainInfo.self, from: jsonData)
                completion(info, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    
    func makeSessionRequest(endpoint: Endpoint, endpointParameter: String?, method: HTTPMethod, parameters: [String: Any]?, encoding: ParameterEncoding, headers: HTTPHeaders, responseType: ResponseType, completion: @escaping ResponseReturnFunction) {
        var endpointStr = endpoint.rawValue
        if let endpointParameter = endpointParameter {
            endpointStr += "/\(endpointParameter)"
        }
        let url = baseURL + endpointStr
        
        guard let user = Manager.sharedInstance.currentUser,
            let accessToken = user.accessToken,
            let refreshToken = user.refreshToken else {
                completion(nil, UNAUTHORIZED_ERROR)
                return
        }
        
        var headersCopy = headers
        headersCopy["Authorization"] = "Bearer " + accessToken
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headersCopy).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if response.response?.statusCode == UNAUTHORIZED_ERROR_CODE {
                    self.refreshAuthToken(refreshToken: refreshToken, completion: { (token, error) in
                        if let error = error {
                            if error.code == UNAUTHORIZED_ERROR_CODE {
                                completion(nil, UNAUTHORIZED_ERROR)
                            } else {
                                completion(nil, error)
                            }
                        } else {
                            if let token = token {
                                headersCopy["Authorization"] = "Bearer " + token
                                UserDefaults.standard.setValue(token, forKey: "BE_ACCESS_TOKEN")
                                
                                AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headersCopy).responseJSON { (response) in
                                    switch response.result {
                                    case .success(let value):
                                        if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                                            switch responseType {
                                            case .Dictionary:
                                                guard var value = value as? [String: Any] else {
                                                    completion(nil, UNEXPECTED_ERROR)
                                                    return
                                                }
                                                value["accessToken"] = token
                                                value["refreshToken"] = refreshToken
                                                completion(value, nil)
                                                break
                                            case .Array:
                                                guard let value = value as? NSArray else {
                                                    completion(nil, UNEXPECTED_ERROR)
                                                    return
                                                }
                                                completion(value, nil)
                                                break
                                            }
                                        } else {
                                            guard let value = value as? [String: Any], let message = value["message"] as? String else {
                                                completion(nil, UNEXPECTED_ERROR)
                                                return
                                            }
                                            completion(nil, NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey: message]))
                                        }
                                        break
                                    case .failure(let error):
                                        completion(nil, error as NSError)
                                        break
                                    }
                                }
                            } else {
                                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not find token", comment: "")])
                                completion(nil, error)
                            }
                        }
                    })
                    return
                }
                
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                    switch responseType {
                    case .Dictionary:
                        guard var value = value as? [String: Any] else {
                            completion(nil, UNEXPECTED_ERROR)
                            return
                        }
                        value["accessToken"] = accessToken
                        value["refreshToken"] = refreshToken
                        completion(value, nil)
                        break
                    case .Array:
                        guard let value = value as? NSArray else {
                            completion(nil, UNEXPECTED_ERROR)
                            return
                        }
                        completion(value, nil)
                        break
                    }
                } else {
                    guard let value = value as? [String: Any], let message = value["message"] as? String else {
                        completion(nil, UNEXPECTED_ERROR)
                        return
                    }
                    completion(nil, NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey: message]))
                }
                break
            case .failure(let error):
                completion(nil, error as NSError)
            }
        }
    }
    
    func refreshAuthToken(refreshToken: String, completion: @escaping TokenReturnFunction) {
        let endpointStr = Endpoint.RefreshToken
        guard let url = URL(string: baseURL + endpointStr.rawValue) else {
            completion(nil, UNEXPECTED_ERROR)
            return
        }
        let headers = NetworkBase.getDefaultHeaders()
        let parameters: [String: Any] = ["refreshToken" : refreshToken]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if response.response?.statusCode == UNAUTHORIZED_ERROR_CODE {
                    completion(nil, UNAUTHORIZED_ERROR)
                    return
                }
                
                guard let value = value as? [String: Any] else {
                    completion(nil, UNEXPECTED_ERROR)
                    return
                }
                
                if let message = value["message"] as? String {
                    completion(nil, NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey: message]))
                } else {
                    guard let accessToken = value["accessToken"] as? String,
                        let _ = value["tokenType"] as? String else {
                            completion(nil, UNEXPECTED_ERROR)
                            return
                    }
                    completion(accessToken, nil)
                }
                break
            case .failure(let error):
                completion(nil, error as NSError)
                break
            }
        }
    }
    
    func loginUser(id: String, password: String, completion: @escaping UserReturnFunction) {
        let route = Router.login(id: id, password: password)
        let endpointStr = route.path
        let method = route.method
        let parameters = route.parameters
        let headers = route.header
        
        let url = baseURL + endpointStr
        
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in 
            switch response.result {
            case .success(let value):
                
                guard let value = value as? [String: Any] else {
                    completion(nil, UNEXPECTED_ERROR)
                    return
                }
                
                if let message = value["message"] as? String {
                    print(message)
                    return
                } else {
                    guard let accessToken = value["accessToken"] as? String,
                        let _ = value["tokenType"] as? String,
                        let refreshToken = value["refreshToken"] as? String else {
                            print("Invalid Response")
                            completion(nil, UNEXPECTED_ERROR)
                            return
                    }
                    var tempUser = User(identityNumber: "", type: UserType.Patient, userId: -1, name: "", surname: "", birthDay: nil, birthMonth: nil, birthYear: nil, height: nil, weight: nil, bloodType: nil, rhType: nil, gender: nil)
                    tempUser.accessToken = accessToken
                    tempUser.refreshToken = refreshToken
                    Manager.sharedInstance.currentUser = tempUser
                    
                    self.getUser(completion: { (user, error) in
                        if let user = user {
                            var returnedUser = user
                            returnedUser.accessToken = accessToken
                            returnedUser.refreshToken = refreshToken
                            completion(returnedUser, nil)
                        } else {
                            Manager.sharedInstance.currentUser = nil
                            if let error = error {
                                completion(nil, error)
                            } else {
                                completion(nil, UNEXPECTED_ERROR)
                            }
                        }
                    })
                }
                break
            case .failure(let error):
                completion(nil, error as NSError)
                break
            }
        }
    }
    
    func getUser(completion: @escaping UserReturnFunction) {
        let route = Router.getUser
        
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                /*
                 user.accessToken = response["accessToken"] as? String
                 user.refreshToken = response["refreshToken"] as? String
                 */
                completion(user, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize user.", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func getAllMedicine(completion: @escaping DrugsReturnFunction) {
        let route = Router.getAllMedicine
        let endpoint = route.endpoint
        let parameters = route.parameters
        let method = route.method
        let headers = route.header
        
        self.makeSessionRequest(endpoint: endpoint, endpointParameter: nil, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let drugs = try JSONDecoder().decode(Drugs.self, from: jsonData)
                completion(drugs, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize medicines", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func getAvailableAppointments(completion: @escaping AppointmentCalendarReturnFunction) {
        let route = Router.getAvailableAppointments
        let endpoint = route.endpoint
        let parameters = route.parameters
        let method = route.method
        let headers = route.header
        
        self.makeSessionRequest(endpoint: endpoint, endpointParameter: nil, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let appointmentCalendar = try JSONDecoder().decode(AppointmentCalendar.self, from: jsonData)
                completion(appointmentCalendar, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize appointment", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func postAppointment(day: Int, month: Int, year: Int, hour: Int, minute: Int, completion: @escaping SuccessReturnFunction) {
        let route = Router.postAppointment(day: day, month: month, year: year, hour: hour, minute: minute)
        let endpoint = route.endpoint
        let method = route.method
        let parameters = route.parameters
        let headers = route.header
        
        self.makeSessionRequest(endpoint: endpoint, endpointParameter: nil, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(false, error)
                } else {
                    completion(false, UNEXPECTED_ERROR)
                }
                return
            }
            guard let success = response["success"] as? Bool,
                let message = response["message"] as? String else {
                    let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize success state", comment: "")])
                    completion(false, error)
                    return
            }
            
            if success {
                completion(true, nil)
            } else {
                completion(false, NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey: message]))
            }
        }
    }
    
    func postUserInfo(name: String, surname: String, birthDay: Int?, birthMonth: Int?, birthYear: Int?, height: Double?, weight: Double?, bloodType: String?, rhType: String?, gender: String?, completion: @escaping SuccessReturnFunction) {
        let route = Router.saveUserInfo(name: name, surname: surname)
        
        var parameters = [String: Any]()
        parameters = [Parameter.name.rawValue: name, Parameter.surname.rawValue: surname]
        
        if let birthDay = birthDay {
            parameters[Parameter.birthDay.rawValue] = birthDay
        }
        if let birthMonth = birthMonth {
            parameters[Parameter.birthMonth.rawValue] = birthMonth
        }
        if let birthYear = birthYear {
            parameters[Parameter.birthYear.rawValue] = birthYear
        }
        
        if let height = height {
            parameters[Parameter.height.rawValue] = height
        }
        if let weight = weight {
            parameters[Parameter.weight.rawValue] = weight
        }
        
        if let bloodType = bloodType {
            parameters[Parameter.bloodType.rawValue] = bloodType
        }
        if let rhType = rhType {
            parameters[Parameter.rhType.rawValue] = rhType
        }
        if let gender = gender {
            parameters[Parameter.gender.rawValue] = gender
        }
        
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(false, error)
                } else {
                    completion(false, UNEXPECTED_ERROR)
                }
                return
            }
            guard let success = response["success"] as? Bool,
                let message = response["message"] as? String else {
                    let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize success state", comment: "")])
                    completion(false, error)
                    return
            }
            
            if success {
                completion(true, nil)
            } else {
                completion(false, NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey: message]))
            }
        }
    }
    
    
    func postRegularMedication(medication: UserDrug, completion: @escaping RegularMedicationsReturnFunction) {
        let route = Router.saveMedicine
        let endpoint = route.endpoint
        let method = route.method
        let headers = route.header
        
        var parameters: [String: Any] = ["mode": medication.mode.rawValue]
        
        switch medication.mode {
        case .Key:
            parameters["key"] = medication.key
        case .Custom:
            parameters["customText"] = medication.custom
        }
        
        parameters["dosage"] = medication.dosage
        parameters["frequency"] = medication.frequency.key
        
        if let objectId = medication.id {
            parameters["id"] = objectId
        }
        
        self.makeSessionRequest(endpoint: endpoint, endpointParameter: nil, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let userDrugs = try JSONDecoder().decode(UserDrugs.self, from: jsonData)
                completion(userDrugs, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize appointment", comment: "")])
                completion(nil, error)
            }            
        }
    }
    
    func getUserMedicine(completion: @escaping RegularMedicationsReturnFunction) {
        let route = Router.getUserMedicine
        let endpoint = route.endpoint
        let method = route.method
        let parameters = route.parameters
        let headers = route.header
        
        self.makeSessionRequest(endpoint: endpoint, endpointParameter: nil, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let userDrugs = try JSONDecoder().decode(UserDrugs.self, from: jsonData)
                completion(userDrugs, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize appointment", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func deleteMedicine(medicineId: Int, completion: @escaping RegularMedicationsReturnFunction) {
        let route = Router.deleteMedicine(medicineId: medicineId)
        let endpoint = route.endpoint
        let method = route.method
        let parameters = route.parameters
        let headers = route.header
        
        self.makeSessionRequest(endpoint: endpoint, endpointParameter: nil, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let userDrugs = try JSONDecoder().decode(UserDrugs.self, from: jsonData)
                completion(userDrugs, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize appointment", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func getPatientUserAppointments(completion: @escaping PatientAppointmentsReturnFunction) {
        let route = Router.getPatientAppointments
        let endpoint = route.endpoint
        let parameters = route.parameters
        let method = route.method
        let headers = route.header
        
        self.makeSessionRequest(endpoint: endpoint, endpointParameter: nil, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let appointments = try JSONDecoder().decode(PatientAppointments.self, from: jsonData)
                completion(appointments, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize appointment", comment: "")])
                completion(nil, error)
            }
        }
    }
    
    func deletePatientNextAppointment(appointmentId: Int, completion: @escaping SuccessReturnFunction) {
        let route = Router.deleteUserAppointment(appointmentId: appointmentId)
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(false, error)
                } else {
                    completion(false, UNEXPECTED_ERROR)
                }
                return
            }
            guard let success = response["success"] as? Bool,
                let message = response["message"] as? String else {
                    let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize success state", comment: "")])
                    completion(false, error)
                    return
            }
            
            if success {
                completion(true, nil)
            } else {
                completion(false, NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey: message]))
            }
        }
    }
    
    func getPatientMainScreenInfo(completion: @escaping PatientMainInfoReturnFunction) {
        let route = Router.getPatientMainScreenInfo
        self.makeSessionRequest(endpoint: route.endpoint, endpointParameter: nil, method: route.method, parameters: route.parameters, encoding: JSONEncoding.default, headers: route.header, responseType: .Dictionary) { (response, error) in
            guard let response = response as? NSDictionary else {
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, UNEXPECTED_ERROR)
                }
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
                let info = try JSONDecoder().decode(PatientMainInfo.self, from: jsonData)
                completion(info, nil)
            } catch {
                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not serialize appointment", comment: "")])
                completion(nil, error)
            }
        }
    }
}
