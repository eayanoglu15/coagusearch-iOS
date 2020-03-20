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
    
    // Mark: Date Picker Input View
    func setInputViewDatePicker(target: Any, selector: Selector) {
           let screenWidth = UIScreen.main.bounds.width
           let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
           datePicker.datePickerMode = .date
           self.inputView = datePicker
           
           let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
           let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
           let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
           toolBar.setItems([cancel, flexible, barButton], animated: false)
           self.inputAccessoryView = toolBar
       }
       
       @objc func tapCancel() {
           self.resignFirstResponder()
       }
    
}
