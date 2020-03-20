//
//  PatientInfoViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 16.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class PatientInfoViewController: BaseScrollViewController {
    
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
    @IBOutlet weak var genderFemaleButton: UIButton!
    @IBOutlet weak var genderMaleButton: UIButton!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var heightLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var weightLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var typeAButton: UIButton!
    @IBOutlet weak var typeBButton: UIButton!
    @IBOutlet weak var typeABButton: UIButton!
    @IBOutlet weak var typeOButton: UIButton!
    
    @IBOutlet weak var rhTypeLabel: UILabel!
    @IBOutlet weak var typePositiveButton: UIButton!
    @IBOutlet weak var typeNegativeButton: UIButton!
    
    private var genderTypeSelection = [false, false]
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
        birthDateTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        
        genderLabel.textColor = .dodgerBlue
        
        heightLabel.textColor = .dodgerBlue
        heightTextField.delegate = self
        heightTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        
        weightLabel.textColor = .dodgerBlue
        weightTextField.delegate = self
        weightTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        
        bloodTypeLabel.textColor = .dodgerBlue
        
        rhTypeLabel.textColor = .dodgerBlue
        
        buttonArray.append(typeAButton)
        buttonArray.append(typeBButton)
        buttonArray.append(typeABButton)
        buttonArray.append(typeOButton)
        
        for i in 0...(bloodTypeSelection.count - 1) {
            if bloodTypeSelection[i] {
                stylizeButtonSelected(button: buttonArray[i])
            } else {
                stylizeButtonUnselected(button: buttonArray[i])
            }
        }
        
        if rhTypeSelection[0] {
            stylizeButtonSelected(button: typePositiveButton)
        } else {
            stylizeButtonUnselected(button: typePositiveButton)
        }
        
        if rhTypeSelection[1] {
            stylizeButtonSelected(button: typeNegativeButton)
        } else {
            stylizeButtonUnselected(button: typeNegativeButton)
        }
        
        if genderTypeSelection[0] {
            stylizeButtonSelected(button: genderFemaleButton)
        } else {
            stylizeButtonUnselected(button: genderFemaleButton)
        }
        
        if genderTypeSelection[1] {
            stylizeButtonSelected(button: genderMaleButton)
        } else {
            stylizeButtonUnselected(button: genderMaleButton)
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
    
    @objc func tapDone() {
        if let datePicker = self.birthDateTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.birthDateTextField.text = dateformatter.string(from: datePicker.date)
        }
        self.birthDateTextField.resignFirstResponder() 
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
    
    @IBAction func typeATapped(_ sender: Any) {
        checkAndSetButton(button: typeAButton, ind: 0)
    }
    
    @IBAction func typeBTapped(_ sender: Any) {
        checkAndSetButton(button: typeBButton, ind: 1)
    }
    
    @IBAction func typeABTapped(_ sender: Any) {
        checkAndSetButton(button: typeABButton, ind: 2)
    }
    
    @IBAction func typeOTapped(_ sender: Any) {
        checkAndSetButton(button: typeOButton, ind: 3)
    }
    
    @IBAction func typePositiveTapped(_ sender: Any) {
        if rhTypeSelection[0] {
            rhTypeSelection[0] = false
            stylizeButtonUnselected(button: typePositiveButton)
        } else {
            if rhTypeSelection[1] {
                rhTypeSelection[1] = false
                stylizeButtonUnselected(button: typeNegativeButton)
            }
            rhTypeSelection[0] = true
            stylizeButtonSelected(button: typePositiveButton)
        }
    }
    
    @IBAction func typeNegativeTapped(_ sender: Any) {
        if rhTypeSelection[1] {
            rhTypeSelection[1] = false
            stylizeButtonUnselected(button: typeNegativeButton)
        } else {
            if rhTypeSelection[0] {
                rhTypeSelection[0] = false
                stylizeButtonUnselected(button: typePositiveButton)
            }
            rhTypeSelection[1] = true
            stylizeButtonSelected(button: typeNegativeButton)
        }
    }
    
    @IBAction func genderFemaleButtonTapped(_ sender: Any) {
        if genderTypeSelection[0] {
            genderTypeSelection[0] = false
            stylizeButtonUnselected(button: genderFemaleButton)
        } else {
            if genderTypeSelection[1] {
                genderTypeSelection[1] = false
                stylizeButtonUnselected(button: genderMaleButton)
            }
            genderTypeSelection[0] = true
            stylizeButtonSelected(button: genderFemaleButton)
        }
    }
    
    @IBAction func genderMaleButtonTapped(_ sender: Any) {
        if genderTypeSelection[1] {
            genderTypeSelection[1] = false
            stylizeButtonUnselected(button: genderMaleButton)
        } else {
            if genderTypeSelection[0] {
                genderTypeSelection[0] = false
                stylizeButtonUnselected(button: genderFemaleButton)
            }
            genderTypeSelection[1] = true
            stylizeButtonSelected(button: genderMaleButton)
        }
    }
    
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
            // TODO: make label text font light for all texk fields
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
