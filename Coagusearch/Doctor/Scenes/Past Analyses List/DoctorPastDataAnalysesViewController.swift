//
//  DoctorPastDataAnalysesViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 6.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension DoctorPastDataAnalysesViewController: DoctorPastDataAnalysesDataSourceDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

class DoctorPastDataAnalysesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = DoctorPastDataAnalysesDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Past µTem Data Analyses".localized
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.getDataList()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == SEGUE_SHOW_DOCTOR_PAST_DATA_ANALYSIS {
            let destinationVc = segue.destination as! DoctorPastDataAnalysisViewController
            if let testId = dataSource.getSelectedTestId() {
                destinationVc.dataSource.testId = testId
            }
            if let testDate = dataSource.getSelectedTestDate() {
                destinationVc.dataSource.testDate = testDate
            }
        }
    }
    
    
}

extension DoctorPastDataAnalysesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PAST_DATA_CELL, for: indexPath) as! PastDataTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        if let info = dataSource.getInfo(forIndex: indexPath.section) {
            cell.setDateInfo(info: info)
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

extension DoctorPastDataAnalysesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.setSelectedTestIdAndDate(index: indexPath.section)
        if dataSource.getSelectedTestId() != nil {
            performSegue(withIdentifier: SEGUE_SHOW_DOCTOR_PAST_DATA_ANALYSIS, sender: nil)
        }
    }
}
