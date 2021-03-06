//
//  ProfileViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 27.02.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension PatientProfileViewController: MedicineTableViewCellDelegate {
    func updateMedicine(medicineIndex: Int) {
        dataSource.setSelectedMedicine(medicineId: medicineIndex)
        performSegue(withIdentifier: SEGUE_SHOW_PATIENT_MEDICINE_UPDATE, sender: nil)
    }
}

extension PatientProfileViewController: PatientProfileDataSourceDelegate {
    func reloadTableView() {
        medicineTableView.reloadData()
    }
}

class PatientProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var doctorViewButton: UIButton!
    
    var dataSource = PatientProfileDataSource()
    
    @IBAction func doctorViewButtonTapped(_ sender: Any) {
        if let user = Manager.sharedInstance.currentUser {
            if user.type == .Doctor {
                showDoctorHome()
            } else if user.type == .Medical {
                showMedicalHome()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Profile".localized
        dataSource.delegate = self
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        // Do any additional setup after loading the view.
        medicineTableView.tableFooterView = UIView()
        medicineTableView.delegate = self
        medicineTableView.dataSource = self
        setupTableView()
        
        let quitButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        quitButton.setImage(UIImage(named: IconNames.quitButton), for: UIControl.State.normal)
        quitButton.addTarget(self, action: #selector(quitButtonPressed), for: UIControl.Event.touchUpInside)
        let quitBarButton = UIBarButtonItem(customView: quitButton)
        self.navigationItem.rightBarButtonItem = quitBarButton
        
        if let user = Manager.sharedInstance.currentUser {
            if user.type == .Doctor {
                doctorViewButton.isHidden = false
                doctorViewButton.setTitle("SWITCH TO DOCTOR VIEW".localized, for: .normal)
            } else if user.type == .Medical {
                doctorViewButton.isHidden = false
                doctorViewButton.setTitle("SWITCH TO MEDICAL TEAM VIEW".localized, for: .normal)
            } else {
                doctorViewButton.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.getUserMedicineList()
        if let user = Manager.sharedInstance.currentUser {
            if let name = user.name, let surname = user.surname {
                nameLabel.text = "\(name) \(surname)"
            } else {
                nameLabel.text = "Not specified".localized
            }
            if let day = user.birthDay, let month = user.birthMonth, let year = user.birthYear {
                birthdateLabel.text = "\(day)/\(month)/\(year)"
            } else {
                birthdateLabel.text = "Not specified".localized
            }
            if let height = user.height {
                heightLabel.text = "\(height) cm"
            } else {
                heightLabel.text = "Not specified".localized
            }
            if let weight = user.weight {
                weightLabel.text = "\(weight) kg"
            } else {
                weightLabel.text = "Not specified".localized
            }
            if let bType = user.bloodType, let rhType = user.rhType {
                if rhType == RhType.Positive {
                    bloodTypeLabel.text = "\(bType) Rh+"
                } else {
                    bloodTypeLabel.text = "\(bType) Rh-"
                }
            } else {
                bloodTypeLabel.text = "Not specified".localized
            }
            
        } else {
            
        }
    }
    
    @objc
    private func quitButtonPressed() {
        Manager.sharedInstance.userDidLogout()
        showLoginVC()
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if segue.identifier == SEGUE_SHOW_PATIENT_MEDICINE_UPDATE {
            let destinationVc = segue.destination as! PatientMedicineUpdateViewController
            destinationVc.dataSource.medicine = dataSource.selectedMedicine
        }
     }
     
    
    private func setupTableView() {
        let cellNib = UINib(nibName: CELL_IDENTIFIER_MEDICINE_CELL, bundle: nil)
        medicineTableView.register(cellNib, forCellReuseIdentifier: CELL_IDENTIFIER_MEDICINE_CELL)
    }
}

extension PatientProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_MEDICINE_CELL, for: indexPath) as! MedicineTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        cell.delegate = self
        if let medInfo = dataSource.getMedicineInfo(index: indexPath.section) {
            cell.titleLabel.text = medInfo.title
            cell.frequencyLabel.text = medInfo.frequency
            cell.dosageLabel.text = medInfo.dosage
            cell.medicineIndex = indexPath.section
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.getUserDrugsCount()
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

extension PatientProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.setSelectedMedicine(medicineId: indexPath.section)
        performSegue(withIdentifier: SEGUE_SHOW_PATIENT_MEDICINE_UPDATE, sender: nil)
    }
}
