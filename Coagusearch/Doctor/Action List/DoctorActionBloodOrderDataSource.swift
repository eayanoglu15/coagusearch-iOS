//
//  DoctorActionBloodOrderDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 2.05.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

class DoctorActionBloodOrderDataSource {
    var testId: Int?
    var patientId: Int?
    
    func getTestId() -> Int? {
        return testId
    }
    
    func getPatientId() -> Int? {
        return patientId
    }
}
