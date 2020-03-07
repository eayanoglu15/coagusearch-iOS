//
//  UITextField+Additions.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 7.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    @IBInspectable var bottomBorderColor: UIColor? {
        get {
            return self.bottomBorderColor
        }
        set {
            self.borderStyle = UITextField.BorderStyle.none;
            let border = CALayer()
            let width = CGFloat(2)
            border.borderColor = newValue?.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)

            border.borderWidth = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true

        }
    }
    
    
}
