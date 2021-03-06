//
//  TimeSlot.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 19.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct TimeSlot : Codable {
    var hour: Int
    var minute: Int
    var available: Bool
}
