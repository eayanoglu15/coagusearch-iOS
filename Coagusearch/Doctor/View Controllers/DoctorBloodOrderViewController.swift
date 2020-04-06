//
//  DoctorBloodOrderViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 26.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class DoctorBloodOrderViewController: UIViewController {
    @IBOutlet weak var FFPButton: UIButton!
    @IBOutlet weak var plateletButton: UIButton!
    
    @IBOutlet weak var bloodTypeAButton: UIButton!
    @IBOutlet weak var bloodTypeBButton: UIButton!
    @IBOutlet weak var bloodTypeABButton: UIButton!
    @IBOutlet weak var bloodTypeOButton: UIButton!
    
    @IBOutlet weak var rhTypePositive: UIButton!
    @IBOutlet weak var rhTypeNegative: UIButton!
    
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var productTypeSelection = [false, false]
    private var bloodTypeSelection = [false, false, false, false]
    private var rhTypeSelection = [false, false]
    
    private var buttonArray: [UIButton] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Blood Order".localized
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        buttonArray.append(bloodTypeAButton)
        buttonArray.append(bloodTypeBButton)
        buttonArray.append(bloodTypeABButton)
        buttonArray.append(bloodTypeOButton)
        
        for i in 0...(bloodTypeSelection.count - 1) {
            if bloodTypeSelection[i] {
                stylizeButtonSelected(button: buttonArray[i])
            } else {
                stylizeButtonUnselected(button: buttonArray[i])
            }
        }
        
        if rhTypeSelection[0] {
            stylizeButtonSelected(button: rhTypePositive)
        } else {
            stylizeButtonUnselected(button: rhTypePositive)
        }
        
        if rhTypeSelection[1] {
            stylizeButtonSelected(button: rhTypeNegative)
        } else {
            stylizeButtonUnselected(button: rhTypeNegative)
        }
        
        if productTypeSelection[0] {
            stylizeButtonSelected(button: FFPButton)
        } else {
            stylizeButtonUnselected(button: FFPButton)
        }
        
        if productTypeSelection[1] {
            stylizeButtonSelected(button: plateletButton)
        } else {
            stylizeButtonUnselected(button: plateletButton)
        }
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
            unitLabel.text = "\(stepper.value)" + " Unit".localized
        } else {
            unitLabel.text = "\(stepper.value)" + " Units".localized
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
    
    func checkAndSetButton(button: UIButton, ind: Int) {
        if bloodTypeSelection[ind] {
            stylizeButtonUnselected(button: button)
            bloodTypeSelection[ind] = false
        } else {
            for i in 0...(bloodTypeSelection.count-1) {
                if bloodTypeSelection[i] {
                    bloodTypeSelection[i] = false
                    stylizeButtonUnselected(button: buttonArray[i])
                }
            }
            stylizeButtonSelected(button: button)
            bloodTypeSelection[ind] = true
        }
    }
    
    @IBAction func typeAButtonTapped(_ sender: Any) {
        checkAndSetButton(button: bloodTypeAButton, ind: 0)
    }
    
    @IBAction func typeBButtonTapped(_ sender: Any) {
        checkAndSetButton(button: bloodTypeBButton, ind: 1)
    }
    
    @IBAction func typeABButtonTapped(_ sender: Any) {
        checkAndSetButton(button: bloodTypeABButton, ind: 2)
    }
    
    @IBAction func typeOButtonTapped(_ sender: Any) {
        checkAndSetButton(button: bloodTypeOButton, ind: 3)
    }
    
    @IBAction func rhPositiveButtonTapped(_ sender: Any) {
        if rhTypeSelection[0] {
            rhTypeSelection[0] = false
            stylizeButtonUnselected(button: rhTypePositive)
        } else {
            if rhTypeSelection[1] {
                rhTypeSelection[1] = false
                stylizeButtonUnselected(button: rhTypeNegative)
            }
            rhTypeSelection[0] = true
            stylizeButtonSelected(button: rhTypePositive)
        }
    }
    
    @IBAction func rhNegativeButtonTapped(_ sender: Any) {
        if rhTypeSelection[1] {
            rhTypeSelection[1] = false
            stylizeButtonUnselected(button: rhTypeNegative)
        } else {
            if rhTypeSelection[0] {
                rhTypeSelection[0] = false
                stylizeButtonUnselected(button: rhTypePositive)
            }
            rhTypeSelection[1] = true
            stylizeButtonSelected(button: rhTypeNegative)
        }
    }
    
    @IBAction func addNoteButtonTapped(_ sender: Any) {
    }
    
}

extension DoctorBloodOrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_BLOOD_ORDER_CELL, for: indexPath) as! BloodOrderTableViewCell
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

extension DoctorBloodOrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
