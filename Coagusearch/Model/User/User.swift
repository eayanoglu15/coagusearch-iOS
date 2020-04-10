//
//  User.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 10.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct User: Codable {
    var identityNumber: String
    var type: UserType
    var userId: Int
    var name: String?
    var surname: String?
    var birthDay: Int?
    var birthMonth: Int?
    var birthYear: Int?
    var height: Double?
    var weight: Double?
    var bloodType: BloodType?
    var rhType: RhType?
    var gender: Gender?
    
    var accessToken: String? {
        didSet {
            UserDefaults.standard.setValue(self.accessToken, forKey: "BE_ACCESS_TOKEN")
        }
    }
    var refreshToken: String? {
        didSet {
            UserDefaults.standard.setValue(self.refreshToken, forKey: "BE_REFRESH_TOKEN")
        }
    }
    
    init(identityNumber: String, type: UserType, userId: Int, name: String?, surname: String?, birthDay: Int?, birthMonth: Int?, birthYear: Int?,
         height: Double?, weight: Double?, bloodType: BloodType?, rhType: RhType?, gender: Gender?) {
        self.identityNumber = identityNumber
        self.type = type
        self.userId = userId
        self.name = name
        self.surname = surname
        self.birthDay = birthDay
        self.birthMonth = birthMonth
        self.birthYear = birthYear
        self.height = height
        self.weight = weight
        self.bloodType = bloodType
        self.rhType = rhType
        self.gender = gender
    }

    func getAccessToken() -> String? {
        return UserDefaults.standard.value(forKey: "BE_ACCESS_TOKEN") as? String
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.value(forKey: "BE_REFRESH_TOKEN") as? String
    }
    
}

enum Gender: String, Codable {
    case Male = "Male"
    case Female = "Female"
}

enum BloodType: String, Codable {
    case A = "A"
    case B = "B"
    case AB = "AB"
    case O = "O"
}

enum RhType: String, Codable {
    case Positive = "Positive"
    case Negative = "Negative"
}

enum UserType: String, Codable {
    case Patient = "Patient"
    case Doctor = "Doctor"
    case Medical = "Medical"
}
