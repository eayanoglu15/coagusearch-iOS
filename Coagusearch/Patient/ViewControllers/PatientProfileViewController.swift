//
//  ProfileViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 27.02.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

class PatientProfileViewController: UIViewController {
    @IBOutlet weak var medicineTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
        title = "Profile"
        // Do any additional setup after loading the view.
        medicineTableView.tableFooterView = UIView()
        medicineTableView.delegate = self
        medicineTableView.dataSource = self
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

extension PatientProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "medicineCell", for: indexPath) as! MedicineTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.backgroundView?.backgroundColor = UIColor.clear
            
            return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //(view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.systemPink
        (view as! UITableViewHeaderFooterView).backgroundView = UIView()
        //(view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
}

extension PatientProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
}
