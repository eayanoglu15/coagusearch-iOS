//
//  DoctorBloodOrderForPatientViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 29.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class DoctorBloodOrderForPatientViewController: UIViewController {
    @IBOutlet weak var FFPButton: UIButton!
       @IBOutlet weak var plateletButton: UIButton!
    
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!

    @IBOutlet weak var tableView: UITableView!
    
    private var productTypeSelection = [false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Blood Order for Patient".localized
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
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

    @IBAction func stepperValueChanged(_ sender: UIStepper) {
           let value = stepper.value
           if value <= 1 {
               unitLabel.text = "\(Int(stepper.value))" + " Unit".localized
           } else {
               unitLabel.text = "\(Int(stepper.value))" + " Units".localized
           }
       }
       
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
        
    }
    
    @IBAction func makeOrderButtonTapped(_ sender: Any) {
        
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
            
            return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
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

