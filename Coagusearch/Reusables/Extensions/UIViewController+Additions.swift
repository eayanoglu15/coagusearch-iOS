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
    
}
