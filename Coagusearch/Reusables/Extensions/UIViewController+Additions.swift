//
//  UIViewController+Additions.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 27.02.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
     
    func stylize() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.twilightBlue.cgColor, UIColor.clearBlue.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self , action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showLoadingVC() {
        if let loadingVC = UIStoryboard(name: STORYBOARD_NAME_MAIN, bundle: nil).instantiateViewController(withIdentifier: STORYBOARD_ID_LOADING) as? LoadingViewController {
            Manager.sharedInstance.loadingVC = loadingVC
            let window = UIApplication.shared.keyWindow!
            window.addSubview(loadingVC.view);
        }
    }
    
    func hideLoadingVC() {
        if let loadingVC = Manager.sharedInstance.loadingVC {
            loadingVC.view.removeFromSuperview()
            Manager.sharedInstance.loadingVC = nil
        }
    }
    
    func showAlertMessage(title: String, message: String){
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Okey".localized, style: .cancel) {
          (action) in
          // implement action if exists
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showLoginVC() {
        let loginVC = UIStoryboard(name: STORYBOARD_NAME_MAIN, bundle: nil).instantiateViewController(withIdentifier: STORYBOARD_ID_LOGIN)
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true) {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func showPatientHome() {
        let tabBarVC = UIStoryboard(name: STORYBOARD_NAME_PATIENT, bundle: nil).instantiateInitialViewController() as! PatientTabBarController
        let navigationVC = tabBarVC.viewControllers?.first as! UINavigationController
        let homeVC = navigationVC.viewControllers.first as! PatientHomeViewController
        homeVC.loadViewIfNeeded()
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: true) {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func showDoctorHome() {
        let tabBarVC = UIStoryboard(name: STORYBOARD_NAME_DOCTOR, bundle: nil).instantiateInitialViewController() as! DoctorTabBarController
        let navigationVC = tabBarVC.viewControllers?.first as! UINavigationController
        let homeVC = navigationVC.viewControllers.first as! DoctorHomeViewController
        homeVC.loadViewIfNeeded()
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: true) {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func showMedicalHome() {
        let tabBarVC = UIStoryboard(name: STORYBOARD_NAME_MEDICAL_TEAM, bundle: nil).instantiateInitialViewController() as! MedicalTeamTabBarViewController
        let navigationVC = tabBarVC.viewControllers?.first as! UINavigationController
        let homeVC = navigationVC.viewControllers.first as! MedicalTeamHomeViewController
        homeVC.loadViewIfNeeded()
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: true) {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
}
