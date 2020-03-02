//
//  SideMenuTableViewController.swift
//  SideMenu
//
//  Created by Jon Kent on 4/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import SideMenu
import UIKit

class SideMenuTableViewController: UITableViewController {
    
    var arrayAdmin: [String] = ["Registrar Usuarios", "Ver Tickets", "Registrar Nuevos Equipos", "Ver Clientes", "Generar Ticket", "Ver Reportes", "Generar Reporte"]
    //let delegationData: controlData
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // refresh cell blur effect in case it changed
        tableView.delegate = self
        tableView.reloadData()
        
        guard let menu = navigationController as? SideMenuNavigationController, menu.blurEffectStyle == nil else {
            return
        }
        
        // Set up a cool background image for demo purposes
    }
    
    override func viewDidLoad() {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.backgroundColor = #colorLiteral(red: 0, green: 0.02853855363, blue: 0.3646980246, alpha: 0.7923085387)
        print("Type User: \(ModelData.shared.user_type)")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAdmin.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = super.tableView(tableView, cellForRowAt: indexPath) as! UITableViewVibrantCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideIdentifier", for: indexPath)
        
        if arrayAdmin.count > 0 {
            cell.textLabel?.text = "\(arrayAdmin[indexPath.row])"
        }
        
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)!
        let textInCell = currentCell.textLabel?.text
        
        if textInCell == "Ver Tickets" {
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("ver_Tickets"), object: nil)
        }
        
        if textInCell == "Ver Clientes" {
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("ver_Clientes"), object: nil)
        }
        
        if textInCell == "Registrar Usuarios" {
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("registerUsers"), object: nil)
        }
        
        if textInCell == "Registrar Nuevos Equipos" {
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("registerMachine"), object: nil)
        }
        
        if textInCell == "Ver Reportes" {
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("seeReports"), object: nil)
        }
        
        if textInCell == "Generar Reporte" {
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("generateReports"), object: nil)
        }
    }
}
