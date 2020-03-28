//
//  SceneDelegate.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 20.02.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        self.initialize()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    private func initialize() {
        let rememberUser = UserDefaults.standard.bool(forKey: "RememberUser")
        if rememberUser {
            if let currentUser = Manager.sharedInstance.getCurrentuser() {
                Manager.sharedInstance.currentUser = currentUser
                self.fetchUser()
                routeUserToHomePage(hasLogedIn: true)
            } else {
                Manager.sharedInstance.userDidLogout()
                routeUserToHomePage(hasLogedIn: false)
            }
        } else {
            Manager.sharedInstance.userDidLogout()
            routeUserToHomePage(hasLogedIn: false)
        }
    }
    
    private func routeUserToHomePage(hasLogedIn: Bool) {
        var rootVC : UIViewController?
        if hasLogedIn {
            if let currentUser = Manager.sharedInstance.getCurrentuser() {
                switch currentUser.type {
                case .Patient:
                    let tabBarVC = UIStoryboard(name: STORYBOARD_NAME_PATIENT, bundle: nil).instantiateInitialViewController() as! PatientTabBarController
                    let navigationVC = tabBarVC.viewControllers?.first as! UINavigationController
                    let homeVC = navigationVC.viewControllers.first as! PatientHomeViewController
                    homeVC.loadViewIfNeeded()
                    self.window?.rootViewController = tabBarVC
                case .Doctor:
                    let tabBarVC = UIStoryboard(name: STORYBOARD_NAME_DOCTOR, bundle: nil).instantiateInitialViewController() as! DoctorTabBarController
                    let navigationVC = tabBarVC.viewControllers?.first as! UINavigationController
                    let homeVC = navigationVC.viewControllers.first as! DoctorHomeViewController
                    homeVC.loadViewIfNeeded()
                    self.window?.rootViewController = tabBarVC
                case .Medical:
                    // TODO: Change for medicial team
                    let tabBarVC = UIStoryboard(name: STORYBOARD_NAME_PATIENT, bundle: nil).instantiateInitialViewController() as! PatientTabBarController
                    let navigationVC = tabBarVC.viewControllers?.first as! UINavigationController
                    let homeVC = navigationVC.viewControllers.first as! PatientHomeViewController
                    homeVC.loadViewIfNeeded()
                    self.window?.rootViewController = tabBarVC
                }
            }
        } else {
            rootVC = UIStoryboard(name: STORYBOARD_NAME_MAIN, bundle: nil).instantiateViewController(withIdentifier: STORYBOARD_ID_LOGIN) as! LoginViewController
            if let rootViewController = rootVC {
                rootViewController.loadViewIfNeeded()
                self.window?.rootViewController = rootViewController
                self.window?.makeKeyAndVisible()
            }
        }
        
    }
    
    private func showLoginVC() {
        let loginVC = UIStoryboard(name: STORYBOARD_NAME_MAIN, bundle: nil).instantiateViewController(withIdentifier: STORYBOARD_ID_LOGIN)
        loginVC.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = loginVC
        self.window?.makeKeyAndVisible()
    }
    
    private func fetchUser() {
        let coagusearchService = CoagusearchServiceFactory.createService()
        
        coagusearchService.getUser { (user, error) in
            if let error = error {
                if error.code == UNAUTHORIZED_ERROR_CODE {
                    Manager.sharedInstance.userDidLogout()
                    self.showLoginVC()
                } else {
                    /*
                    if let splashVC = UIApplication.shared.keyWindow?.rootViewController as? SplashVC {
                        splashVC.showCustomAlertVC(NSLocalizedString("Error", comment: ""),
                                               message: error.localizedDescription,
                                               identifier: "ConfigError",
                                               objects: [],
                                               delegate: self,
                                               customPopoverDelegate: splashVC,
                                               type: .Single,
                                               buttonTitles: [NSLocalizedString("Try Again", comment: "")],
                                               popoverDelegate: splashVC)
                    }
                    */
                }
            } else {
                if let user = user {
                    Manager.sharedInstance.currentUser = user
                    //according to user type, show home screen
                    
                } else {
                    Manager.sharedInstance.userDidLogout()
                    self.showLoginVC()
                }
            }
        }
    }
    
}

