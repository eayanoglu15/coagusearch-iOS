//
//  TextFieldViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 1.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class TextFieldViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TextFieldViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
           floatTitle()
           performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1))
       }
      
      // This is where we adjust constraint and the label will float to the top
      func floatTitle() {
           titleLabel.font = titleLabel.font?.withSize(12)
           labelTopConstraint.constant = -20
           labelLeadingConstraint.constant = -10
       }
    
       // By adding a little animation
       private func performAnimation(transform: CGAffineTransform) {
           UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
               self.titleLabel.transform = transform
               self.view.layoutIfNeeded()
           }, completion: nil)
       }
    
    // We need to check if the textfield is empty or not. If it's empty, we will unfloat the label meaning going back to the original position.
       func textFieldDidEndEditing(_ textField: UITextField) {
           if textField.text?.isEmpty ?? false {
               configureEndEditing()
           }
       }
    
      func unfloatTitle() {
           textField.placeholder = nil
           labelTopConstraint.constant = 20
           labelLeadingConstraint.constant = 10
           titleLabel.font = titleLabel.font?.withSize(16)
       }
    
       private func configureEndEditing() {
           unfloatTitle()
           performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1))
       }
}
