//
//  AppointmentSelectionDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 19.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol AppointmentSelectionDataSourceDelegate {
    func showErrorMessage(title: String, message: String)
    func hideLoading()
    func reloadTableView()
    func routeToAppointments()
    func showLoginVC()
}

class AppointmentSelectionDataSource {
    var delegate: AppointmentSelectionDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    var appointmentCalendar: [(String, [String])] = []
    
    var doctorName: String?
    
    var hasNextAppointment = false
    var selectedDateIndex = 0
    var selectedDate = ""
    var selectedTimeSlotIndex = 0
    var selectedTimeSlot = ""
    
    func getAppointments() {
        coagusearchService?.getAvailableAppointments(completion: { (appointmentCalendar, error) in
            self.delegate?.hideLoading()
            if let error = error {
                if error.code == UNAUTHORIZED_ERROR_CODE {
                    Manager.sharedInstance.userDidLogout()
                    self.delegate?.showLoginVC()
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.showErrorMessage(title: ERROR_MESSAGE.localized, message: error.localizedDescription)
                    }
                }
            } else {
                if let appointmentCalendar = appointmentCalendar {
                    self.setAppointmentCalendar(calendar: appointmentCalendar)
                    DispatchQueue.main.async {
                        self.delegate?.reloadTableView()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.showErrorMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                    }
                }
            }
        })
    }
    
    func setAppointmentCalendar(calendar: AppointmentCalendar) {
        self.doctorName = "\(calendar.doctorName) \(calendar.doctorSurname)"
        for dayInfo in calendar.week {
            var day = ""
            day = "\(dayInfo.day)/\(dayInfo.month)/\(dayInfo.year)"
            var timeSlots = [String]()
            for timeSlot in dayInfo.hours {
                if timeSlot.available {
                    var timeSlotStr = ""
                    var minStr = String(timeSlot.minute)
                    if minStr == "0" {
                        minStr = "00"
                    }
                    timeSlotStr = "\(timeSlot.hour):\(minStr)"
                    timeSlots.append(timeSlotStr)
                }
            }
            if !timeSlots.isEmpty {
                let pair = (day, timeSlots)
                appointmentCalendar.append(pair)
            }
        }
        if let datePair = appointmentCalendar.first {
            selectedDate = datePair.0
            selectedTimeSlot = datePair.1.first ?? ""
        }
    }
    
    func getDates() -> [String] {
        var dates = [String]()
        for date in appointmentCalendar {
            dates.append(date.0)
        }
        return dates
    }
    
    func getTimeSlots(index: Int) -> [String] {
        if appointmentCalendar.isEmpty {
            return []
        }
        return appointmentCalendar[index].1
    }
    
    func getUserAppointment() {
        if selectedDate != "" && selectedTimeSlot != "" {
            let dateArray = selectedDate.components(separatedBy: "/")
            let timeSlotArray = selectedTimeSlot.components(separatedBy: ":")
            guard let day = Int(dateArray[0]),
                let month = Int(dateArray[1]),
                let year = Int(dateArray[2]),
                let hour = Int(timeSlotArray[0]),
                let minute = Int(timeSlotArray[1]) else {
                    return
            }
            print("------")
            print(day, "/", month, "/", year)
            print(hour, ":", minute)
            postUserAppointment(day: day, month: month, year: year, hour: hour, minute: minute)
        }
    }
    
    //getAppointment(day: Int, month: Int, year: Int, hour: Int, minute: Int)
    func postUserAppointment(day: Int, month: Int, year: Int, hour: Int, minute: Int) {
        coagusearchService?.postAppointment(day: day, month: month, year: year, hour: hour, minute: minute, completion: { (success, error) in
            if let error = error {
                if error.code == UNAUTHORIZED_ERROR_CODE {
                    Manager.sharedInstance.userDidLogout()
                    self.delegate?.showLoginVC()
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.showErrorMessage(title: ERROR_MESSAGE.localized, message: error.localizedDescription)
                    }
                }
            } else {
                if success {
                    DispatchQueue.main.async {
                        self.delegate?.routeToAppointments()
                    }
                } else {
                    self.delegate?.showErrorMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                }
            }
            
        })
    }
}
