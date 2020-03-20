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

class NetworkBase {
    
    let baseURL = "http://localhost:8080"
    
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
