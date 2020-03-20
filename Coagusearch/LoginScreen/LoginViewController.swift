//
//  ViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 20.02.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension LoginViewController: LoginDataSourceDelegate {
    func showErrorMessage(title: String, message: String) {
        showAlertMessage(title: title, message: message)
    }
    func hideLoading() {
        hideLoadingVC()
    }
    func routeToHome() {
        performSegue(withIdentifier: SEGUE_SHOW_PATIENT_HOME, sender: nil)
    }
}

class LoginViewController: BaseScrollViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var userLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordLabelTopConstraint: NSLayoutConstraint!
    
    var loginDataSource = LoginDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        loginDataSource.coagusearchService = CoagusearchServiceFactory.createService()
        loginDataSource.delegate = self
        
        userTextField.delegate = self
        userLabel.textColor = .lightBlueGrey
        userTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        
        passwordTextField.delegate = self
        passwordLabel.textColor = .lightBlueGrey
        passwordTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        
        userTextField.keyboardType = .numberPad
        passwordTextField.keyboardType = .numberPad
        
        rememberMeSwitch.isOn = false
        rememberMeSwitch.tintColor = .dodgerBlue
        rememberMeSwitch.layer.cornerRadius = rememberMeSwitch.frame.height / 2
        rememberMeSwitch.backgroundColor = .dodgerBlue
    }    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if self.isAllRequiredFieldsFilled() {
            loginUser()
        } else {
            showAlertMessage(title: "Missing Information".localized, message: "Please fill your id and password".localized)
        }
    }
    
    func loginUser() {
        guard let id = self.userTextField.text, !id.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty else {
                return
        }
        self.showLoadingVC()
        loginDataSource.loginUser(id: id, password: password, rememberUser: rememberMeSwitch.isOn)
    }
    
    private func isAllRequiredFieldsFilled() -> Bool {
        guard let id = self.userTextField.text, !id.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty else {
                return false
        }
        return true
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        floatTitle(textField: textField)
        performAnimation(textField: textField, transform: CGAffineTransform(scaleX: 1, y: 1))
    }
    
    func floatTitle(textField: UITextField) {
        if textField == userTextField {
            userLabel.font = userLabel.font?.withSize(18)
            userLabelTopConstraint.constant = -30
            userLabel.textColor = .dodgerBlue
            userTextField.bottomBorderColor = UIColor.dodgerBlue
        }
        if textField == passwordTextField {
            passwordLabel.font = passwordLabel.font?.withSize(18)
            passwordLabelTopConstraint.constant = -30
            passwordLabel.textColor = .dodgerBlue
            passwordTextField.bottomBorderColor = UIColor.dodgerBlue
        }
    }
    
    private func performAnimation(textField: UITextField, transform: CGAffineTransform) {
        if textField == userTextField {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.userLabel.transform = transform
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        if textField == passwordTextField {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.passwordLabel.transform = transform
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
        if textField == userTextField {
            userTextField.placeholder = nil
            userLabelTopConstraint.constant = 0
            userLabel.font = userLabel.font?.withSize(16)
            userLabel.textColor = .lightBlueGrey
            userTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        }
        if textField == passwordTextField {
            passwordTextField.placeholder = nil
            passwordLabelTopConstraint.constant = 0
            passwordLabel.font = passwordLabel.font?.withSize(16)
            passwordLabel.textColor = .lightBlueGrey
            passwordTextField.bottomBorderColor = UIColor.lightBlueGrey.withAlphaComponent(0.5)
        }
    }
    
    private func configureEndEditing(textField: UITextField) {
        unfloatTitle(textField: textField)
        performAnimation(textField: textField, transform: CGAffineTransform(scaleX: 1, y: 1))
    }

}

