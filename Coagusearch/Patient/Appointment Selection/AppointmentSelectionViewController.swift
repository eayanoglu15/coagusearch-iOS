//
//  AppointmentSelectionViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 1.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension AppointmentSelectionViewController: AppointmentSelectionDataSourceDelegate {
    func routeToAppointments() {
        navigationController?.popViewController(animated: true)
    }
    
    func reloadTableView() {
        appointmentSelectionTableView.reloadData()
    }
    
    func showErrorMessage(title: String, message: String) {
        showAlertMessage(title: title, message: message)
    }
    
    func hideLoading() {
        hideLoadingVC()
    }
}

class AppointmentSelectionViewController: UIViewController {
    let DOCTOR_SECTION = 0
    let DATE_SECTION = 1
    let TIME_SLOT_SECTION = 2
    
    @IBOutlet weak var appointmentSelectionTableView: UITableView!
    @IBOutlet weak var requestAppointmentButton: UIButton!
    
    var dataSource = AppointmentSelectionDataSource()
    
    var selectionArray = [false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        title = "Request Appointment".localized
        appointmentSelectionTableView.tableFooterView = UIView()
        appointmentSelectionTableView.dataSource = self
        appointmentSelectionTableView.delegate = self
        stylize()
        
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoadingVC()
        dataSource.getAppointments()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func requestAppointmentButtonTapped(_ sender: Any) {
        dataSource.getUserAppointment()
    }
    
    private func setupTableView() {
        let doctorCellNib = UINib(nibName: CELL_IDENTIFIER_DOCTOR_CELL, bundle: nil)
        let selectionCellNib = UINib(nibName: CELL_IDENTIFIER_SELECTION_CELL, bundle: nil)
        appointmentSelectionTableView.register(doctorCellNib, forCellReuseIdentifier: CELL_IDENTIFIER_DOCTOR_CELL)
        appointmentSelectionTableView.register(selectionCellNib, forCellReuseIdentifier: CELL_IDENTIFIER_SELECTION_CELL)
    }
}

extension AppointmentSelectionViewController: SelectionCellDelegate {
    func setSelection(type: SelectionCellType, cellSectionNumber: Int, index: Int, value: String) {
        if type == SelectionCellType.AppointmentDay {
            dataSource.selectedDateIndex = index
            dataSource.selectedDate = value
            dataSource.selectedTimeSlotIndex = 0
            dataSource.selectedTimeSlot = dataSource.getTimeSlots(index: index).first ?? ""
        }
        if type == SelectionCellType.TimeSlot {
            dataSource.selectedTimeSlotIndex = index
            dataSource.selectedTimeSlot = value
        }
        
        // Close current cell
        selectionArray[cellSectionNumber] = false
        let indexPath = IndexPath(row: 0, section: cellSectionNumber)
        let cell = appointmentSelectionTableView.cellForRow(at: indexPath) as! SelectionTableViewCell
        cell.changeArrow(selected: selectionArray[cellSectionNumber])
        
        // Reset picker selection for time slot according to selected date
        let timeSlotIndexPath = IndexPath(row: 0, section: TIME_SLOT_SECTION)
        let timeCell = appointmentSelectionTableView.cellForRow(at: timeSlotIndexPath) as! SelectionTableViewCell
        let timeSlots = dataSource.getTimeSlots(index: dataSource.selectedDateIndex)
        timeCell.setPickerData(data: timeSlots)
        timeCell.pickerView.selectRow(0, inComponent: 0, animated: false)
        timeCell.pickerView.reloadAllComponents()
        
        appointmentSelectionTableView.beginUpdates()
        appointmentSelectionTableView.endUpdates()
    }
}

extension AppointmentSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == DOCTOR_SECTION {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_DOCTOR_CELL, for: indexPath) as! DoctorTableViewCell
            if let doctorName = dataSource.doctorName {
                cell.nameLabel.text = doctorName
            }
            return cell
        } else if indexPath.section == DATE_SECTION {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_SELECTION_CELL, for: indexPath) as! SelectionTableViewCell
            cell.setup(type: .AppointmentDay, listData: dataSource.getDates(), cellSectionNumber: DATE_SECTION)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_SELECTION_CELL, for: indexPath) as! SelectionTableViewCell
            cell.setup(type: .TimeSlot, listData: dataSource.appointmentCalendar.first?.1, cellSectionNumber: TIME_SLOT_SECTION)
            cell.delegate = self
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEIGHT_FOR_HEADER
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectionArray[indexPath.section] {
            return CELL_HEIGHT_EXPANDED
        } else {
            return CELL_HEIGHT
        }
    }
}

extension AppointmentSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == DATE_SECTION {
            // Set selected to expand this cell
            let cell = appointmentSelectionTableView.cellForRow(at: indexPath) as! SelectionTableViewCell
            if selectionArray[DATE_SECTION] {
                selectionArray[DATE_SECTION] = false
            } else {
                selectionArray[DATE_SECTION] = true
            }
            cell.changeArrow(selected: selectionArray[DATE_SECTION])
            
            // Set unselected to close other if it is already expanded
            if selectionArray[TIME_SLOT_SECTION] {
                selectionArray[TIME_SLOT_SECTION] = false
            }
            
            appointmentSelectionTableView.beginUpdates()
            appointmentSelectionTableView.endUpdates()
        } else if indexPath.section == TIME_SLOT_SECTION {
            let cell = appointmentSelectionTableView.cellForRow(at: indexPath) as! SelectionTableViewCell
            // Reset picker selection for time slot according to selected date
            let timeSlots = dataSource.getTimeSlots(index: dataSource.selectedDateIndex)
            cell.setPickerData(data: timeSlots)
            cell.pickerView.selectRow(0, inComponent: 0, animated: false)
            cell.pickerView.reloadAllComponents()
            if selectionArray[indexPath.section] {
                selectionArray[indexPath.section] = false
            } else {
                selectionArray[indexPath.section] = true
            }
            cell.changeArrow(selected: selectionArray[indexPath.section])
            
            if selectionArray[DATE_SECTION] {
                selectionArray[DATE_SECTION] = false
            }
            let dateSlotIndexPath = IndexPath(row: 0, section: DATE_SECTION)
            let dateCell = appointmentSelectionTableView.cellForRow(at: dateSlotIndexPath) as! SelectionTableViewCell
            dateCell.changeArrow(selected: selectionArray[DATE_SECTION])
            
            appointmentSelectionTableView.beginUpdates()
            appointmentSelectionTableView.endUpdates()
        }
    }
}
