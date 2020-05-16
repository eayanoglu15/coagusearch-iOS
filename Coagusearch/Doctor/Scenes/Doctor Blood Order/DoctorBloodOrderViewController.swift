//
//  DoctorBloodOrderViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 26.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension DoctorBloodOrderViewController: DoctorBloodOrderDataSourceDelegate {
    func reloadTable() {
        tableView.reloadData()
    }
    
    func refreshOrderCardAndTable() {
        stylizeButtonUnselected(button: FFPButton)
        stylizeButtonUnselected(button: plateletButton)
        
        stylizeButtonUnselected(button: bloodTypeAButton)
        stylizeButtonUnselected(button: bloodTypeBButton)
        stylizeButtonUnselected(button: bloodTypeABButton)
        stylizeButtonUnselected(button: bloodTypeOButton)
        
        stylizeButtonUnselected(button: rhTypePositive)
        stylizeButtonUnselected(button: rhTypeNegative)
        
        unitTextField.text = nil
        
        tableView.reloadData()
    }
}

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
    @IBOutlet weak var unitTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var productTypeSelection = [false, false]
    private var bloodTypeSelection = [false, false, false, false]
    private var rhTypeSelection = [false, false]
    
    private var buttonArray: [UIButton] = []
    
    var dataSource = DoctorBloodOrderDataSource()
    var note: String?
    
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
        hideKeyboard()
        stylize()
        title = "Blood Order".localized
        setupTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.getPastOrders()
    }
    
    private func setupTableView() {
        let infoCellNib = UINib(nibName: CELL_IDENTIFIER_COLORED_LABEL_CELL, bundle: nil)
        tableView.register(infoCellNib, forCellReuseIdentifier: CELL_IDENTIFIER_COLORED_LABEL_CELL)
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
        let bloodType = getBloodType()
        let rhType = getRhType()
        
        if bloodType == nil && rhType == nil {
            showAlertMessage(title: "Missing Blood Information".localized, message: "Please enter blood type and rh type.".localized)
            return
        } else if bloodType == nil && rhType != nil {
            showAlertMessage(title: "Missing Blood Type".localized, message: "Please enter your blood type.".localized)
            return
        } else if bloodType != nil && rhType == nil {
            showAlertMessage(title: "Missing Rh Type".localized, message: "Please enter rh type.".localized)
            return
        }
        
        guard let orderBloodType = bloodType, let orderRhType = rhType else {
            return
        }
        
        guard let productType = getProductType() else {
            showAlertMessage(title: "Missing Product Type".localized, message: "Please enter product type.".localized)
            return
        }
        
        guard let unit = unitTextField.text, !unit.isEmpty, let unitAmount = Double(unit) else {
            showAlertMessage(title: "Missing Unit Amount".localized, message: "Please enter unit amount.".localized)
            return
        }
        
        // optional note
        
        dataSource.postBloodOrder(bloodType: orderBloodType, rhType: orderRhType, productType: productType, unit: unitAmount, additionalNote: note)
        note = nil
    }
    
    func getBloodType() -> BloodType? {
        for i in 0...(bloodTypeSelection.count-1) {
            if bloodTypeSelection[i] {
                if i == 0 {
                    return BloodType.A
                } else if i == 1 {
                    return BloodType.B
                } else if i == 2 {
                    return BloodType.AB
                } else if i == 3 {
                    return BloodType.O
                }
            }
        }
        return nil
    }
    
    func getRhType() -> RhType? {
        for i in 0...(rhTypeSelection.count-1) {
            if rhTypeSelection[i] {
                if i == 0 {
                    return RhType.Positive
                } else if i == 1 {
                    return RhType.Negative
                }
            }
        }
        return nil
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

extension DoctorBloodOrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataSource.getPastOrderCount() == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_COLORED_LABEL_CELL, for: indexPath) as! ColoredLabelTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            cell.setTitle(title: "No order has been made yet".localized)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_BLOOD_ORDER_CELL, for: indexPath) as! BloodOrderTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        if let order = dataSource.getPastOrder(index: indexPath.section) {
            cell.setCell(order: order)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = dataSource.getPastOrderCount()
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

extension DoctorBloodOrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
