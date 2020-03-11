//
//  CoagusearchService.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 9.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation
import Alamofire


class CoagusearchService: NetworkBase {
    
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
                                let error = NSError(domain: "BE", code: 0, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Could not find token.", comment: "")])
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
}
