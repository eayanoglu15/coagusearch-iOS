//
//  DataTableViewCell.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 5.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    
    @IBOutlet weak var optMinLabel: UILabel!
    @IBOutlet weak var optMaxLabel: UILabel!
    
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var optimalLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var optimalWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rangeView: UIView!
    @IBOutlet weak var optimalView: UIView!
    @IBOutlet weak var indicatorView: UIView!
    
    private var val: Double?
    private var min: Double?
    private var max: Double?
    private var optMin: Double?
    private var optMax: Double?
    
    func setValues(val: Double, min: Double, max: Double, optMin: Double, optMax: Double) {
        self.val = val
        self.min = min
        self.max = max
        self.optMin = optMin
        self.optMax = optMax
        
        setView()
    }
    
    func setView() {
        if let val = val, let min = min, let max = max,
            let optMin = optMin, let optMax = optMax {
            let width = Double(rangeView.frame.size.width)
            let viewRatio = width / (max - min)
            
            // value
            valueLabel.text = getStr(value: val)
            
            // set max - min value
            minValueLabel.text = getStr(value: min)
            maxValueLabel.text = getStr(value: max)
            
            // set indicator constaint
            indicatorLeadingConstraint.constant = CGFloat(-viewRatio * (val - min))
            
            // set opt values
            optMinLabel.text = getStr(value: optMin)
            optMaxLabel.text = getStr(value: optMax)
            
            // set opt view
            optimalLeadingConstraint.constant = CGFloat(viewRatio * (optMin - min))
            optimalWidthConstraint.constant = CGFloat(viewRatio * (optMax - optMin))
            
            if val >= optMin && val <= optMax {
                // Normal values
                alertImageView.image = UIImage(named: IMAGE_NAME_NORMAL)
                titleLabel.textColor = .azulThree
                indicatorView.backgroundColor = .dodgerBlue
            } else {
                // Warning
                indicatorView.backgroundColor = .orangeyRed
                if val < optMin {
                    alertImageView.image = UIImage(named: IMAGE_NAME_LOW)
                    titleLabel.textColor = .salmon
                    if val < min {
                        // TODO: Exception, lower than boundary
                    } else {
                        
                    }
                } else if val > optMax {
                    alertImageView.image = UIImage(named: IMAGE_NAME_HIGH)
                    titleLabel.textColor = .salmon
                    if val > max {
                        // TODO: Exception, higher than boundary
                    } else {
                        
                    }
                }
            }
            
            optimalView.layoutIfNeeded()
            indicatorView.layoutIfNeeded()
        }
    }
    
    func getStr(value: Double) -> String {
        var str = ""
        // set max - min value
        if floor(value) == value {
            str = "\(Int(value))"
        } else {
            str = "\(value)"
        }
        return str
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
