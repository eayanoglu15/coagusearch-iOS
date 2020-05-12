//
//  DoctorTreatmentStatusViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 15.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension DoctorTreatmentStatusViewController: DoctorTreatmentStatusDataSourceDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

class DoctorTreatmentStatusViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource = DoctorTreatmentStatusDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Treatment Status".localized
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.getLastAnalysisData()
    }

    private func setupTableView() {
        let nextCellNib = UINib(nibName: CELL_IDENTIFIER_COLORED_LABEL_CELL, bundle: nil)
        tableView.register(nextCellNib, forCellReuseIdentifier: CELL_IDENTIFIER_COLORED_LABEL_CELL)
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

extension DoctorTreatmentStatusViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataSource.getTableViewCount() == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_COLORED_LABEL_CELL, for: indexPath) as! ColoredLabelTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            cell.label.text = "No order has been made yet".localized
            return cell
        }
        
        if let order = dataSource.getOrderInfo(forIndex: indexPath.section) {
            switch order.kind {
            case .Blood:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PATIENT_SPECIFIC_BLOOD_ORDER_CELL, for: indexPath) as! PatientSpecificPastBloodOrderTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                cell.setup(order: order)
                return cell
            case .Medicine:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_GIVEN_MEDICINE_CELL, for: indexPath) as! GivenMedicineTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                cell.setup(order: order)
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_COLORED_LABEL_CELL, for: indexPath) as! ColoredLabelTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        cell.label.text = "No order has been made yet".localized
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = dataSource.getTableViewCount()
        if count > 0 {
            return count
        } else {
            return 1
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //(view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.systemPink
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
        //(view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
}

extension DoctorTreatmentStatusViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

