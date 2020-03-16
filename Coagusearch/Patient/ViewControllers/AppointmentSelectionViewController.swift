//
//  AppointmentSelectionViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 1.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class AppointmentSelectionViewController: UIViewController {
    @IBOutlet weak var appointmentSelectionTableView: UITableView!
    @IBOutlet weak var requestAppointmentButton: UIButton!
    
    var selectionArray = [false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Request Appointment"
        appointmentSelectionTableView.tableFooterView = UIView()
        appointmentSelectionTableView.dataSource = self
        appointmentSelectionTableView.delegate = self
        stylize()
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
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension AppointmentSelectionViewController: SelectionCellDelegate {
    func reloadTable() {
        appointmentSelectionTableView.reloadData()
    }
    
}

extension AppointmentSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "doctorCell", for: indexPath) as! DoctorTableViewCell
            cell.nameLabel.text = "Arthur Clayton"
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionTableViewCell
            cell.setup(type: .TimeSlot, listData: ["13.00 - 13.30", "13.30 - 14.30", "14.30 - 15.00", "15.30 - 16.00"])
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
        return 16
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectionArray[indexPath.section] {
            return 200
        } else {
            return 65
        }
    }
}

extension AppointmentSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let cell = appointmentSelectionTableView.cellForRow(at: indexPath) as! DateTableViewCell
            if selectionArray[indexPath.section] {
                selectionArray[indexPath.section] = false
            } else {
                selectionArray[indexPath.section] = true
            }
            cell.changeArrow(selected: selectionArray[indexPath.section])
            appointmentSelectionTableView.beginUpdates()
            appointmentSelectionTableView.endUpdates()
        } else if indexPath.section == 2 {
            let cell = appointmentSelectionTableView.cellForRow(at: indexPath) as! SelectionTableViewCell
            if selectionArray[indexPath.section] {
                selectionArray[indexPath.section] = false
            } else {
                selectionArray[indexPath.section] = true
            }
            cell.changeArrow(selected: selectionArray[indexPath.section])
            appointmentSelectionTableView.beginUpdates()
            appointmentSelectionTableView.endUpdates()
        }
    }
}
