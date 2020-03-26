//
//  AppointmentsViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 27.02.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension PatientAppointmentsViewController: NextAppointmentTableViewCellDelegate {
    func cancelAppointment() {
        dataSource.cancelNextAppointment()
    }
}

extension PatientAppointmentsViewController:  PatientAppointmentsDataSourceDelegate {
    func reloadTableView() {
        if dataSource.hasNextAppointment() {
            requestAppointmentButton.isHidden = true
            tableViewBottomConstraint.constant = 0
        } else {
            requestAppointmentButton.isHidden = false
            tableViewBottomConstraint.constant = 72
        }
        appointmentTableView.reloadData()
    }
}

class PatientAppointmentsViewController: UIViewController {
    @IBOutlet weak var appointmentTableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var requestAppointmentButton: UIButton!
    
    var dataSource = PatientAppointmentsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "My Appointments".localized
        
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
        
        appointmentTableView.tableFooterView = UIView()
        appointmentTableView.dataSource = self
        appointmentTableView.delegate = self
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.getUserAppointmentsData()
    }
    
    
    private func setupTableView() {
        let nextCellNib = UINib(nibName: CELL_IDENTIFIER_NEXT_APPOINTMENT_CELL, bundle: nil)
        appointmentTableView.register(nextCellNib, forCellReuseIdentifier: CELL_IDENTIFIER_NEXT_APPOINTMENT_CELL)
        let pastCellNib = UINib(nibName: CELL_IDENTIFIER_PAST_APPOINTMENT_CELL, bundle: nil)
        appointmentTableView.register(pastCellNib, forCellReuseIdentifier: CELL_IDENTIFIER_PAST_APPOINTMENT_CELL)
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension PatientAppointmentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataSource.hasNextAppointment() {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_NEXT_APPOINTMENT_CELL, for: indexPath) as! NextAppointmentTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                cell.delegate = self
                if let next = dataSource.getNextAppointmentInfo() {
                    cell.doctorLabel.text = "\(next.doctorName) \(next.doctorSurname)"
                    cell.dateLabel.text = "\(next.day).\(next.month).\(next.year) "
                    var hourStr = "\(next.hour)"
                    var minStr = "\(next.minute)"
                    if hourStr.count == 1 {
                        hourStr = "0" + hourStr
                    }
                    if minStr.count == 1 {
                        minStr = "0" + minStr
                    }
                    cell.timeLabel.text = "\(hourStr):\(minStr)"
                }
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PAST_APPOINTMENT_CELL, for: indexPath) as! PastAppointmentTableViewCell
        if let old = dataSource.getAppointmentInfo(forIndex: indexPath.section) {
            cell.doctorLabel.text = "\(old.doctorName) \(old.doctorSurname)"
            cell.dateLabel.text = "\(old.day).\(old.month).\(old.year) "
            var hourStr = "\(old.hour)"
            var minStr = "\(old.minute)"
            if hourStr.count == 1 {
                hourStr = "0" + hourStr
            }
            if minStr.count == 1 {
                minStr = "0" + minStr
            }
            cell.timeLabel.text = "\(hourStr):\(minStr)"
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.getTableViewCount()
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEIGHT_FOR_HEADER
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
    }
}

extension PatientAppointmentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
