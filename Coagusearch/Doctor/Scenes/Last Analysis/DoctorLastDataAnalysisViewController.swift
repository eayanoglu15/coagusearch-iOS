//
//  DoctorLastDataAnalysisViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 30.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension DoctorLastDataAnalysisViewController: DoctorLastDataAnalysisDataSourceDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

class DoctorLastDataAnalysisViewController: UIViewController {
    var dataSource = DoctorLastDataAnalysisDataSource()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "µTem Data Analysis".localized
        // Do any additional setup after loading the view.
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blueBlue], for: UIControl.State.normal)
        segmentedControl.borderColor = .white
        segmentedControl.borderWidth = 1
        //segmentedControl.backgroundColor = .dodgerBlue
        segmentedControl.selectedSegmentTintColor = .blueBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.getLastAnalysisData()
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if segue.identifier == SEGUE_SHOW_DOCTOR_DATA_ANALYSES {
            let destinationVc = segue.destination as! DoctorPastDataAnalysesViewController
            if let patientId = dataSource.getPatientId() {
                destinationVc.dataSource.patientId = patientId
            }
        }
        if segue.identifier == SEGUE_SHOW_DOCTOR_ACTION_LIST {
            let destinationVc = segue.destination as! DoctorActionBloodOrderViewController
            if let testId = dataSource.getTestId() {
                destinationVc.dataSource.testId = testId
            }
            if let patientId = dataSource.getPatientId() {
                destinationVc.dataSource.patientId = patientId
            }
        }
     }
     
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        tableView.reloadData()
    }
}

extension DoctorLastDataAnalysisViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_DATA_CELL, for: indexPath) as! DataTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        
        var val: SingleTestResult?
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            val = dataSource.getOrderInfo(testName: .Fibtem, forIndex: indexPath.section)
            break
        case 1:
            val = dataSource.getOrderInfo(testName: .Extem, forIndex: indexPath.section)
            break
        case 2:
            val = dataSource.getOrderInfo(testName: .Intem, forIndex: indexPath.section)
            break
        default:
            break
        }
        
        if let result = val {
            cell.setTestResult(result: result)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            return dataSource.getTableViewCount(testName: .Fibtem)
        case 1:
            return dataSource.getTableViewCount(testName: .Extem)
        case 2:
            return dataSource.getTableViewCount(testName: .Intem)
        default:
            return 0
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HEIGHT_FOR_DATA_CELL
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //(view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.systemPink
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
        //(view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
}

extension DoctorLastDataAnalysisViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
