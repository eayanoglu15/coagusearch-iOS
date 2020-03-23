//
//  LoginDataSource.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 19.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

protocol LoginDataSourceDelegate {
    func showErrorMessage(title: String, message: String)
    func hideLoading()
    func routeToHome()
}

class LoginDataSource {
    var delegate: LoginDataSourceDelegate?
    var coagusearchService: CoagusearchService?
    
    // id: "13243546234", password: "913147"
    func loginUser(id: String, password: String, rememberUser: Bool) {
        coagusearchService?.loginUser(id: id, password: password, completion: { (user, error) in
            if let error = error {
                DispatchQueue.main.async {
                     self.delegate?.hideLoading()
                     self.delegate?.showErrorMessage(title: ERROR_MESSAGE.localized, message: error.localizedDescription)
                }
            } else {
                if let user = user {
                    Manager.sharedInstance.currentUser = user
                    if rememberUser {
                        UserDefaults.standard.setValue(true, forKey: "RememberUser")
                    }
                    DispatchQueue.main.async {
                         self.delegate?.hideLoading()
                         self.delegate?.routeToHome()
                    }
                } else {
                    DispatchQueue.main.async {
                         self.delegate?.hideLoading()
                         self.delegate?.showErrorMessage(title: ERROR_MESSAGE.localized, message: UNEXPECTED_ERROR_MESSAGE.localized)
                    }
                }
            }
        })
    }
}
