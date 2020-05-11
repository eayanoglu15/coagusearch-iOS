//
//  DoctorNotificationsViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 26.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension DoctorNotificationsViewController: DoctorNotificationsDataSourceDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

class DoctorNotificationsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = DoctorNotificationsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Notifications".localized
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        setupTableView()
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
    }
    
    private func setupTableView() {
        let notificationCellNib = UINib(nibName: CELL_IDENTIFIER_MEDICAL_TEAM_NOTIFICATION_CELL, bundle: nil)
        tableView.register(notificationCellNib, forCellReuseIdentifier: CELL_IDENTIFIER_MEDICAL_TEAM_NOTIFICATION_CELL)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.getNotifications()
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

extension DoctorNotificationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_EMERGENCY_CELL, for: indexPath) as! EmergencyTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_COMPLETED_ANALYSIS_CELL, for: indexPath) as! CompletedAnalysisTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_MEDICAL_NOTIFICATION_CELL, for: indexPath) as! MedicalNotificationTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            
            return cell
        }
        */ 
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_MEDICAL_TEAM_NOTIFICATION_CELL, for: indexPath) as! MedicalTeamNotificationTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        if let notifyInfo = dataSource.getNotification(index: indexPath.section) {
            cell.setNotification(notif: notifyInfo)
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
        if section == 0 {
            return 0
        }
        return HEIGHT_FOR_HEADER
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //(view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.systemPink
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
        //(view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
}

extension DoctorNotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
