//
//  PatientHomeViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 20.02.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension PatientHomeViewController:  PatientHomeDataSourceDelegate {
    func reloadTableView() {
        homeTableView.reloadData()
    }
}

class PatientHomeViewController: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var dataSource = PatientHomeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Welcome".localized
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
        homeTableView.dataSource = self
        homeTableView.delegate = self
        homeTableView.tableFooterView = UIView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.getMainScreenInfo()
    }
    
    private func setupTableView() {
        let nextCellNib = UINib(nibName: CELL_IDENTIFIER_NEXT_APPOINTMENT_CELL, bundle: nil)
        homeTableView.register(nextCellNib, forCellReuseIdentifier: CELL_IDENTIFIER_NEXT_APPOINTMENT_CELL)
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

extension PatientHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.getTableViewCount()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataSource.hasMissingInfo() {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_MISSING_INFO_CELL, for: indexPath) as! MissingInfoTableViewCell
                return cell
            }
            if dataSource.hasNextAppointment() {
                if indexPath.section == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_NEXT_APPOINTMENT_CELL, for: indexPath) as! NextAppointmentTableViewCell
                    cell.backgroundColor = UIColor.clear
                    cell.backgroundView?.backgroundColor = UIColor.clear
                    cell.cancelButton.isHidden = true
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
        } else {
            if dataSource.hasNextAppointment() {
                if indexPath.section == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_NEXT_APPOINTMENT_CELL, for: indexPath) as! NextAppointmentTableViewCell
                    cell.backgroundColor = UIColor.clear
                    cell.backgroundView?.backgroundColor = UIColor.clear
                    cell.cancelButton.isHidden = true
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
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCellTableViewCell
        return cell
    }
}

extension PatientHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if dataSource.hasMissingInfo() {
                performSegue(withIdentifier: SEGUE_SHOW_PATIENT_INFO, sender: nil)
            }
        }
    }
}

