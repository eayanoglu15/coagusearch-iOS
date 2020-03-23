//
//  UserDrugs.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 21.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct UserDrugs : Codable {
    var allDrugs: Drugs
    var userDrugs: [UserDrug]
}
