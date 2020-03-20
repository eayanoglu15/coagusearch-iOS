//
//  DayInfo.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 19.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct DayInfo : Codable {
    var day: Int
    var month: Int
    var year: Int
    var hours: [TimeSlot]
}
