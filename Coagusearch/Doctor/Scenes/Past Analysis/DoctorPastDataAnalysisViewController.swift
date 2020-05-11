//
//  DoctorPastDataAnalysisViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 6.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension DoctorPastDataAnalysisViewController: DoctorPastDataAnalysisDataSourceDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

class DoctorPastDataAnalysisViewController: UIViewController {
    
    var dataSource = DoctorPastDataAnalysisDataSource()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let FIBTEM_SECTION = 0
    let EXTEM_SECTION = 1
    let INTEM_SECTION = 2
    let ORDER_SECTION = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Past µTem Data Analysis".localized
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
        dateLabel.text = dataSource.testDate
        dataSource.getDataAnalysisByID()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        tableView.reloadData()
    }
}

extension DoctorPastDataAnalysisViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == ORDER_SECTION {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PATIENT_SPECIFIC_BLOOD_ORDER_CELL, for: indexPath) as! PatientSpecificPastBloodOrderTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            // orderVal = indexPath.section - intemvalues.count
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_DATA_CELL, for: indexPath) as! DataTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            var val: SingleTestResult?
            switch (segmentedControl.selectedSegmentIndex) {
            case FIBTEM_SECTION:
                val = dataSource.getOrderInfo(testName: .Fibtem, forIndex: indexPath.section)
                break
            case EXTEM_SECTION:
                val = dataSource.getOrderInfo(testName: .Extem, forIndex: indexPath.section)
                break
            case INTEM_SECTION:
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
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch (segmentedControl.selectedSegmentIndex) {
        case FIBTEM_SECTION:
            return dataSource.getTableViewCount(testName: .Fibtem)
        case EXTEM_SECTION:
            return dataSource.getTableViewCount(testName: .Extem)
        case INTEM_SECTION:
            return dataSource.getTableViewCount(testName: .Intem)
        case ORDER_SECTION:
            // TODO get order
            return 1
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
        switch (segmentedControl.selectedSegmentIndex) {
        case FIBTEM_SECTION:
            return HEIGHT_FOR_DATA_CELL
        case EXTEM_SECTION:
            return HEIGHT_FOR_DATA_CELL
        case INTEM_SECTION:
            return HEIGHT_FOR_DATA_CELL
        case ORDER_SECTION:
            return CGFloat(122) // height of ordered blood cell
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //(view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.systemPink
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
        //(view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
}

extension DoctorPastDataAnalysisViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

