//
//  MedicalTeamPrepareViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 29.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class MedicalTeamPrepareViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Prepare".localized
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blueBlue], for: UIControl.State.normal)
        segmentedControl.borderColor = .white
        segmentedControl.borderWidth = 1
        segmentedControl.selectedSegmentTintColor = .blueBlue
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        tableView.reloadData()
    }

}

extension MedicalTeamPrepareViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            return 3
        case 1:
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return HEIGHT_FOR_HEADER
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            
        case 1:
            
        default:
            
        }
         */
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_GENERAL_BLOOD_ORDER_INFO_CELL, for: indexPath) as! GeneralBloodOrderInfoTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        return cell
    }
}

extension MedicalTeamPrepareViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
