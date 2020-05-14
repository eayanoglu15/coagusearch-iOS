//
//  Drug.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 12.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct Drug : Codable {
    var content: String
    var key: String
    
    init(content: String, key: String) {
        self.content = content
        self.key = key
    }
}
