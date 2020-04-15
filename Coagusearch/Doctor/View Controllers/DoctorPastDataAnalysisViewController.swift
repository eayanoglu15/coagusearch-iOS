//
//  DoctorPastDataAnalysisViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 6.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class DoctorPastDataAnalysisViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Past µTem Data Analysis".localized
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        dateLabel.text = "10 February 2020"
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
               segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blueBlue], for: UIControl.State.normal)
               segmentedControl.borderColor = .white
               segmentedControl.borderWidth = 1
               //segmentedControl.backgroundColor = .dodgerBlue
               segmentedControl.selectedSegmentTintColor = .blueBlue
    }
    
    let values = [(30.0, 10.0, 200.0, 60.0, 90.0), (170, 100, 200, 110, 120), (50, 40, 60, 50, 55)]
    let fibtemvalues = [(30.0, 10.0, 200.0, 60.0, 90.0), (170, 100, 200, 110, 120), (50, 40, 60, 50, 55)]
    let extemvalues = [(30.0, 10.0, 200.0, 60.0, 90.0)]
    let intemvalues = [(30.0, 10.0, 200.0, 60.0, 90.0), (170, 100, 200, 110, 120)]
    
    let numberOfOrders = 1

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
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            if indexPath.section >= fibtemvalues.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PATIENT_SPECIFIC_BLOOD_ORDER_CELL, for: indexPath) as! PatientSpecificPastBloodOrderTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                // orderVal = indexPath.section - fibtemvalues.count
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_DATA_CELL, for: indexPath) as! DataTableViewCell
                    cell.backgroundColor = UIColor.clear
                    cell.backgroundView?.backgroundColor = UIColor.clear
                let val = fibtemvalues[indexPath.section]
                cell.setValues(val: val.0, min: val.1, max: val.2, optMin: val.3, optMax: val.4)
                return cell
            }
        case 1:
            if indexPath.section >= extemvalues.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PATIENT_SPECIFIC_BLOOD_ORDER_CELL, for: indexPath) as! PatientSpecificPastBloodOrderTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                // orderVal = indexPath.section - extemvalues.count
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_DATA_CELL, for: indexPath) as! DataTableViewCell
                    cell.backgroundColor = UIColor.clear
                    cell.backgroundView?.backgroundColor = UIColor.clear
                let val = extemvalues[indexPath.section]
                cell.setValues(val: val.0, min: val.1, max: val.2, optMin: val.3, optMax: val.4)
                return cell
            }
        case 2:
            if indexPath.section >= intemvalues.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PATIENT_SPECIFIC_BLOOD_ORDER_CELL, for: indexPath) as! PatientSpecificPastBloodOrderTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                // orderVal = indexPath.section - intemvalues.count
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_DATA_CELL, for: indexPath) as! DataTableViewCell
                    cell.backgroundColor = UIColor.clear
                    cell.backgroundView?.backgroundColor = UIColor.clear
                let val = intemvalues[indexPath.section]
                cell.setValues(val: val.0, min: val.1, max: val.2, optMin: val.3, optMax: val.4)
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PATIENT_SPECIFIC_BLOOD_ORDER_CELL, for: indexPath) as! PatientSpecificPastBloodOrderTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            // orderVal = indexPath.section - intemvalues.count
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            return fibtemvalues.count + numberOfOrders
        case 1:
            return extemvalues.count + numberOfOrders
        case 2:
            return intemvalues.count + numberOfOrders
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
        case 0:
            if indexPath.section >= fibtemvalues.count {
                return CGFloat(122) // height of ordered blood cell
            } else {
                return HEIGHT_FOR_DATA_CELL
            }
        case 1:
            if indexPath.section >= extemvalues.count {
                return CGFloat(122) // height of ordered blood cell
            } else {
                return HEIGHT_FOR_DATA_CELL
            }
        case 2:
            if indexPath.section >= intemvalues.count {
                return CGFloat(122) // height of ordered blood cell
            } else {
                return HEIGHT_FOR_DATA_CELL
            }
        default:
            return CGFloat(122) // height of ordered blood cell
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

