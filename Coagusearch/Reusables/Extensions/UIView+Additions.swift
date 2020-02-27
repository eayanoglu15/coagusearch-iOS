//
//  UIView+Additions.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 27.02.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    enum Constants {
        static let cornerRadius: CGFloat = 6
        static let shadowOpacity: Float = 0.5
        static let shadowRadius: CGFloat = 4
    }
    
    func stylize() {
        addCorner()
        addShadow()
    }
    
    func addCorner() {
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowOffset = .zero
        layer.shadowRadius = Constants.shadowRadius
    }
    
}
