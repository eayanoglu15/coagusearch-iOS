//
//  PatientInfoViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 16.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class PatientInfoViewController: BaseScrollViewController {
    
    let fontLight = UIFont(name: "HelveticaNeue-Light", size: 14.0)!
    let fontRegular = UIFont(name: "HelveticaNeue", size: 16.0)!
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var surnameLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var birthDateLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var genderLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var heightLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var weightLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var bloodTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var rhTypeLabel: UILabel!
    @IBOutlet weak var rhTypeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Account Information"
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        nameLabel.textColor = .dodgerBlue
        nameTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        
        surnameLabel.textColor = .dodgerBlue
        surnameTextField.delegate = self
        surnameTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        
        birthDateLabel.textColor = .dodgerBlue
        birthDateTextField.delegate = self
        birthDateTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        
        genderLabel.textColor = .dodgerBlue
        genderTextField.delegate = self
        genderTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        
        heightLabel.textColor = .dodgerBlue
        heightTextField.delegate = self
        heightTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        
        weightLabel.textColor = .dodgerBlue
        weightTextField.delegate = self
        weightTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        
        bloodTypeLabel.textColor = .dodgerBlue
        bloodTypeSegmentedControl.selectedSegmentTintColor = .dodgerBlue
        
        rhTypeLabel.textColor = .dodgerBlue
        rhTypeSegmentedControl.selectedSegmentTintColor = .dodgerBlue
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

extension PatientInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        floatTitle(textField: textField)
        performAnimation(textField: textField, transform: CGAffineTransform(scaleX: 1, y: 1))
    }
    
    func floatTitle(textField: UITextField) {
        if textField == nameTextField {
            nameLabel.font = fontRegular
            nameLabelTopConstraint.constant = -30
            nameLabel.textColor = .dodgerBlue
            nameTextField.bottomBorderColor = UIColor.dodgerBlue.withAlphaComponent(0.5)
        }
        if textField == surnameTextField {
            surnameLabel.font = fontRegular
            surnameLabelTopConstraint.constant = -30
            surnameLabel.textColor = .dodgerBlue
            surnameTextField.bottomBorderColor = UIColor.dodgerBlue.withAlphaComponent(0.5)
        }
        if textField == birthDateTextField {
            birthDateLabel.font = fontRegular
            birthDateLabelTopConstraint.constant = -30
            birthDateLabel.textColor = .dodgerBlue
            birthDateTextField.bottomBorderColor = UIColor.dodgerBlue.withAlphaComponent(0.5)
        }
        if textField == genderTextField {
            genderLabel.font = fontRegular
            genderLabelTopConstraint.constant = -30
            genderLabel.textColor = .dodgerBlue
            genderTextField.bottomBorderColor = UIColor.dodgerBlue.withAlphaComponent(0.5)
        }
        if textField == heightTextField {
            heightLabel.font = fontRegular
            heightLabelTopConstraint.constant = -30
            heightLabel.textColor = .dodgerBlue
            heightTextField.bottomBorderColor = UIColor.dodgerBlue.withAlphaComponent(0.5)
        }
        if textField == weightTextField {
            weightLabel.font = fontRegular
            weightLabelTopConstraint.constant = -30
            weightLabel.textColor = .dodgerBlue
            weightTextField.bottomBorderColor = UIColor.dodgerBlue.withAlphaComponent(0.5)
        }
    }
    
    private func performAnimation(textField: UITextField, transform: CGAffineTransform) {
        if textField == nameTextField {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.nameLabel.transform = transform
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        if textField == surnameTextField {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.surnameLabel.transform = transform
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        if textField == birthDateTextField {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.birthDateLabel.transform = transform
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        if textField == genderTextField {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.genderLabel.transform = transform
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        if textField == heightTextField {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.heightLabel.transform = transform
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        if textField == weightTextField {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.weightLabel.transform = transform
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? false {
            configureEndEditing(textField: textField)
        } else {
            textField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        }
    }
    
    func unfloatTitle(textField: UITextField) {
        if textField == nameTextField {
            nameTextField.placeholder = nil
            nameLabelTopConstraint.constant = 0
            nameLabel.font = fontLight
            nameTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        }
        if textField == surnameTextField {
            surnameTextField.placeholder = nil
            surnameLabelTopConstraint.constant = 0
            surnameLabel.font = fontLight
            surnameTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        }
        if textField == birthDateTextField {
            birthDateTextField.placeholder = nil
            birthDateLabelTopConstraint.constant = 0
            birthDateLabel.font = fontLight
            birthDateTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        }
        if textField == genderTextField {
            genderTextField.placeholder = nil
            genderLabelTopConstraint.constant = 0
            genderLabel.font = fontLight
            genderTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        }
        if textField == heightTextField {
            heightTextField.placeholder = nil
            heightLabelTopConstraint.constant = 0
            heightLabel.font = fontLight
            heightTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        }
        if textField == weightTextField {
            weightTextField.placeholder = nil
            weightLabelTopConstraint.constant = 0
            weightLabel.font = fontLight
            weightTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        }
    }
    
    private func configureEndEditing(textField: UITextField) {
        unfloatTitle(textField: textField)
        performAnimation(textField: textField, transform: CGAffineTransform(scaleX: 1, y: 1))
    }
    
}
