//
//  Manager.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 10.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation
import UIKit

class Manager {
    static let sharedInstance = Manager()
    
    var loadingVC: LoadingViewController?
    
    // MARK: Properties
    var currentUser: User? {
        didSet {
            if let user = self.currentUser {
                if let encodedUser = try? JSONEncoder().encode(user) {
                    if let encodedObjectJsonString = String(data: encodedUser, encoding: .utf8) {
                        UserDefaults.standard.setValue(encodedObjectJsonString, forKey: "CurrentUser")
                    }
                }
            } else {
                UserDefaults.standard.setValue(nil, forKey: "CurrentUser")
            }
        }
    }
    
    // MARK: Functions
    func userDidLogin() {
        
    }

    func userDidLogout() {
        Manager.sharedInstance.currentUser?.accessToken = nil
        Manager.sharedInstance.currentUser?.refreshToken = nil
        Manager.sharedInstance.currentUser = nil
    }
    
    func getCurrentuser() -> User? {
        if let user = self.currentUser {
            return user
        } else {
            if let returnedUserJSONString = UserDefaults.standard.value(forKey: "CurrentUser") as? String {
                if let jsonData = returnedUserJSONString.data(using: .utf8) {
                    if var user = try? JSONDecoder().decode(User.self, from: jsonData) {
                        user.accessToken = user.getAccessToken()
                        user.refreshToken = user.getRefreshToken()
                        return user
                    }
                }
            }
            return nil
        }
    }
}
