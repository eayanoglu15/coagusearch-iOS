//
//  Frequency.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 12.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct Frequency: Codable {
    var key: String
    var title: String
    
    static func == (freqFirst: Frequency, freqSecond: Frequency) -> Bool {
        return (freqFirst.key == freqSecond.key) && (freqFirst.title == freqSecond.title)
    }

    static func != (freqFirst: Frequency, freqSecond: Frequency) -> Bool {
        return !((freqFirst.key == freqSecond.key) && (freqFirst.title == freqSecond.title))
    }
}
