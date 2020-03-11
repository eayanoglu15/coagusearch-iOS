//
//  Constants.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 10.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

enum Parameter: String {
    case id = "identity_number"
    case password = "password"
}

enum Endpoint: String {
    case Login = "/auth/sign-in"
    case GetUser = "/users/me"
    case RefreshToken = "/auth/refresh"
}
