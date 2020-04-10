//
//  DoctorProfileViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 9.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class DoctorProfileViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Profile".localized
        // Do any additional setup after loading the view.
        let quitButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        quitButton.setImage(UIImage(named: IconNames.quitButton), for: UIControl.State.normal)
        quitButton.addTarget(self, action: #selector(quitButtonPressed), for: UIControl.Event.touchUpInside)
        let quitBarButton = UIBarButtonItem(customView: quitButton)
        self.navigationItem.rightBarButtonItem = quitBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    
    @IBAction func switchToPatientViewButtonTapped(_ sender: Any) {
        // TODO:
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
