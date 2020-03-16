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
    
    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getUser, .getAllMedicine:
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
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .login(let id, let password):
            return [Parameter.id.rawValue: id, Parameter.password.rawValue: password]
        case .getUser, .getAllMedicine:
            return nil
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .login, .getUser, .getAllMedicine:
            return NetworkBase.getDefaultHeaders()
        }
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
