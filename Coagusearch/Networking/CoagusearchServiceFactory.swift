//
//  CoagusearchServiceFactory.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 9.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

class CoagusearchServiceFactory {
    static func createService() -> CoagusearchService {
        return CoagusearchService()
    }
}
