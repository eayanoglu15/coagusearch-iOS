//
//  Drugs.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 12.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct Drugs : Codable {
    var drugs: [Drug]
    var frequencies: [Frequency]
}
