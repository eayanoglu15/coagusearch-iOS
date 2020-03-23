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
                    print("accessToken: ", accessToken)
                    var tempUser = User(identityNumber: "", type: "", userId: -1, name: "", surname: "", dateOfBirth: nil, height: nil, weight: nil, bloodType: nil, rhType: nil, gender: .Female)
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
        let endpointStr = route.path
        let parameters = route.parameters
        let method = route.method
        let headers = route.header
        
        self.makeSessionRequest(endpoint: Endpoint.GetUser, endpointParameter: nil, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, responseType: .Dictionary) { (response, error) in
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
                var user = try JSONDecoder().decode(User.self, from: jsonData)
                user.accessToken = response["accessToken"] as? String
                user.refreshToken = response["refreshToken"] as? String
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
    
    func postUserInfo(name: String, surname: String, dateOfBirth: String, height: Double, weight: Double, bloodType: String, rhType: String, gender: String, completion: @escaping SuccessReturnFunction) {
        let route = Router.saveUserInfo(name: name, surname: surname, dateOfBirth: dateOfBirth, height: height, weight: weight, bloodType: bloodType, rhType: rhType, gender: gender)
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
        
        print("get user med")
        
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
