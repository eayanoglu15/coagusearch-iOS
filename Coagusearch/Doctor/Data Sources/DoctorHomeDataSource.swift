//
//  DoctorHomeDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 27.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol DoctorHomeDataSourceDelegate {
    
}

class DoctorHomeDataSource {
    var delegate: DoctorHomeDataSourceDelegate?
    
    var emergencyData: [EmergencyPatient] = [
        EmergencyPatient(patientName: "Muharrem Salel", time: "10:00 - 10:20"),
        EmergencyPatient(patientName: "Okan Akgül", time: "11:00 - 11:20"),
        EmergencyPatient(patientName: "Muharrem Salel 2", time: "10:00 - 10:20"),
        EmergencyPatient(patientName: "Okan Akgül 2", time: "11:00 - 11:20")
    ]
    
    var appointmentData: [TodaysAppointment] = [
        TodaysAppointment(patientName: "Muharrem Salel", time: "10:00 - 10:20"),
        TodaysAppointment(patientName: "Okan Akgül", time: "11:00 - 11:20"),
        TodaysAppointment(patientName: "Muharrem Salel 2", time: "10:00 - 10:20"),
        TodaysAppointment(patientName: "Okan Akgül 2", time: "11:00 - 11:20")
    ]
    
    
    func getEmergencyPatientCount() -> Int {
        return emergencyData.count
    }
    
    func getEmergencyPatient(index: Int) -> EmergencyPatient {
        return emergencyData[index]
    }
    
    
    func getPatientAppointmentCount() -> Int {
        return appointmentData.count
    }
    
    func getPatientAppointment(index: Int) -> TodaysAppointment {
        return appointmentData[index]
    }
}

struct EmergencyPatient {
    var patientName: String
    var time: String
    
    init(patientName: String, time: String) {
        self.patientName = patientName
        self.time = time
    }
}

struct TodaysAppointment {
    var patientName: String
    var time: String
    
    init(patientName: String, time: String) {
        self.patientName = patientName
        self.time = time
    }
}
