//
//  MedicalTeamPrepareViewController.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 29.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import UIKit

extension MedicalTeamPrepareViewController: GeneralBloodOrderInfoTableViewCellDelegate {
    func setReadyButtonClicked(bloodOrderId: Int) {
        dataSource.setOrderReady(bloodOrderId: bloodOrderId)
    }
}

extension MedicalTeamPrepareViewController: MedicalTeamPrepareDataSourceDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
}

class MedicalTeamPrepareViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var dataSource = MedicalTeamPrepareDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.coagusearchService = CoagusearchServiceFactory.createService()
        dataSource.delegate = self
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
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = .blueBlue
        } else {
            // Fallback on earlier versions
        }
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.getToDoList()
    }
    
    private func setupTableView() {
        let infoCellNib = UINib(nibName: CELL_IDENTIFIER_COLORED_LABEL_CELL, bundle: nil)
        tableView.register(infoCellNib, forCellReuseIdentifier: CELL_IDENTIFIER_COLORED_LABEL_CELL)
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

    let TODO_SECTION = 0
    let DONE_SECTION = 1
}

extension MedicalTeamPrepareViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch (segmentedControl.selectedSegmentIndex) {
        case TODO_SECTION:
            let count = dataSource.getTableViewCount(list: .TODO)
            if count > 0 {
                return count
            } else {
                return 1
            }
        case DONE_SECTION:
            let count = dataSource.getTableViewCount(list: .DONE)
            if count > 0 {
                return count
            } else {
                return 1
            }
        default:
            return 1
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
        if segmentedControl.selectedSegmentIndex == TODO_SECTION {
            if dataSource.getTableViewCount(list: .TODO) == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_COLORED_LABEL_CELL, for: indexPath) as! ColoredLabelTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                cell.setTitle(title: "There is no request to prepare".localized)
                return cell
            }
        } else {
            if dataSource.getTableViewCount(list: .DONE) == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_COLORED_LABEL_CELL, for: indexPath) as! ColoredLabelTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.backgroundView?.backgroundColor = UIColor.clear
                cell.setTitle(title: "There is no request you have prepared yet".localized)
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER_GENERAL_BLOOD_ORDER_INFO_CELL, for: indexPath) as! GeneralBloodOrderInfoTableViewCell
        cell.delegate = self
        cell.backgroundColor = UIColor.clear
        cell.backgroundView?.backgroundColor = UIColor.clear
        var order: OrderToDo?
        switch (segmentedControl.selectedSegmentIndex) {
        case TODO_SECTION:
            if let order = dataSource.getOrderInfo(list: .TODO, forIndex: indexPath.section) {
                cell.setOrder(list: .TODO, order: order)
            }
        case DONE_SECTION:
            if let order = dataSource.getOrderInfo(list: .DONE, forIndex: indexPath.section) {
                cell.setOrder(list: .DONE, order: order)
            }
        default:
            print()
        }
        return cell
    }
}

extension MedicalTeamPrepareViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
