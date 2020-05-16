//
//  DoctorBloodOrderForPatientViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 29.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension DoctorBloodOrderForPatientViewController: DoctorBloodOrderForPatientDataSourceDelegate {
    func refreshOrderCardandTable() {
        stylizeButtonUnselected(button: FFPButton)
        stylizeButtonUnselected(button: plateletButton)
        unitTextField.text = nil
        tableView.reloadData()
    }
}

class DoctorBloodOrderForPatientViewController: UIViewController {
    var dataSource = DoctorBloodOrderForPatientDataSource()
    
    @IBOutlet weak var FFPButton: UIButton!
    @IBOutlet weak var plateletButton: UIButton!
    
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var unitTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var productTypeSelection = [false, false]
    
    var note: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        stylize()
        title = "Blood Order for Patient".localized
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
        // Do any additional setup after loading the view.
        stylizeButtonUnselected(button: FFPButton)
        stylizeButtonUnselected(button: plateletButton)
    }
    
    func stylizeButtonUnselected(button: UIButton) {
        button.borderWidth = 1
        button.borderColor = .lightBlueGrey
        button.cornerRadius = 8
        button.tintColor = .coolBlue
        button.backgroundColor = .clear
    }
    
    func stylizeButtonSelected(button: UIButton) {
        button.borderWidth = 0
        button.tintColor = .white
        button.backgroundColor = .coolBlue
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func FFPButtonTapped(_ sender: Any) {
        if productTypeSelection[0] {
            productTypeSelection[0] = false
            stylizeButtonUnselected(button: FFPButton)
        } else {
            if productTypeSelection[1] {
                productTypeSelection[1] = false
                stylizeButtonUnselected(button: plateletButton)
            }
            productTypeSelection[0] = true
            stylizeButtonSelected(button: FFPButton)
        }
    }
    
    @IBAction func plateletButtonTapped(_ sender: Any) {
        if productTypeSelection[1] {
            productTypeSelection[1] = false
            stylizeButtonUnselected(button: plateletButton)
        } else {
            if productTypeSelection[0] {
                productTypeSelection[0] = false
                stylizeButtonUnselected(button: FFPButton)
            }
            productTypeSelection[1] = true
            stylizeButtonSelected(button: plateletButton)
        }
    }
    
    @IBAction func addNoteButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Note".localized, message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Save".localized, style: .default) { [unowned alertController] _ in
            let answer = alertController.textFields![0]
            self.note = answer.text
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) {
            (action) in
            // implement action if exists
        }
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    @IBAction func makeOrderButtonTapped(_ sender: Any) {
        guard let productType = getProductType() else {
            showAlertMessage(title: "Missing Product Type".localized, message: "Please enter product type.".localized)
            return
        }
        
        guard let unit = unitTextField.text, !unit.isEmpty, let unitAmount = Double(unit) else {
            showAlertMessage(title: "Missing Unit Amount".localized, message: "Please enter unit amount.".localized)
            return
        }
        
        // optional note
        
        dataSource.postBloodOrder(productType: productType, unit: unitAmount, additionalNote: note)
        note = nil
    }
    
    func getProductType() -> OrderProductType? {
        for i in 0...(productTypeSelection.count-1) {
            if productTypeSelection[i] {
                if i == 0 {
                    return OrderProductType.FFP
                } else if i == 1 {
                    return OrderProductType.PlateletConcentrate
                }
            }
        }
        return nil
    }
    
}

extension DoctorBloodOrderForPatientViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_PATIENT_SPECIFIC_BLOOD_ORDER_CELL, for: indexPath) as! PatientSpecificPastBloodOrderTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        if let order = dataSource.getOrderInfo(forIndex: indexPath.section) {
            cell.setup(order: order)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("dataSource.getTableViewCount(): ", dataSource.getTableViewCount())
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

extension DoctorBloodOrderForPatientViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

