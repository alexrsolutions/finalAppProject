//
//  SideMenuTableViewController.swift
//  SideMenu
//
//  Created by Jon Kent on 4/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import SideMenu
import UIKit
import FirebaseAuth

class SideMenuTableViewController: UITableViewController {
    
    var arrayControl: [String] = ["Registrar Usuarios", "Ver Tickets", "Registrar Nuevos Equipos", "Ver Clientes", "Generar Ticket", "Ver Reportes", "Generar Reporte", "Dar Reseña", "Ver Tecnicos", "Ver Tecnicos", "Perfil"]
    var arrayAdmin: [String] = ["Perfil", "Ver Tickets", "Ver Clientes", "Ver Reportes", "Ver Tecnicos", "Registrar Usuarios", "Registrar Nuevos Equipos", "Cerrar Sesion"]
    var arrayUser: [String] = ["Perfil", "Dar Reseña", "Ver Reportes", "Generar Reporte", "Cerrar Sesion"]
    var arrayTech: [String] = ["Perfil", "Ver Reportes", "Ver Clientes", "Generar Ticket", "Ticket Generados", "Registrar Nuevos Equipos", "Cerrar Sesion"]
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
        if ModelData.shared.user_type == "admin" {
            return arrayAdmin.count
        } else if ModelData.shared.user_type == "tech" {
            return arrayTech.count
        } else if ModelData.shared.user_type == "client" {
            return arrayUser.count
        } else {
            return arrayControl.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = super.tableView(tableView, cellForRowAt: indexPath) as! UITableViewVibrantCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideIdentifier", for: indexPath)
        
        if ModelData.shared.user_type == "admin" {
            if arrayAdmin.count > 0 {
                cell.textLabel?.text = "\(arrayAdmin[indexPath.row])"
            }
        } else if ModelData.shared.user_type == "tech" {
            if arrayTech.count > 0 {
                cell.textLabel?.text = "\(arrayTech[indexPath.row])"
            }
        } else if ModelData.shared.user_type == "client" {
            if arrayUser.count > 0 {
                cell.textLabel?.text = "\(arrayUser[indexPath.row])"
            }
        } else {
            if arrayControl.count > 0 {
                cell.textLabel?.text = "\(arrayControl[indexPath.row])"
            }
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
        
        if textInCell == "Ver Tecnicos" {
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("ver_Tecnicos"), object: nil)
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
        
        if textInCell == "Ver Tecnicos" {
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("seeTechies"), object: nil)
        }
        
        if textInCell == "Generar Reporte" {
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("generateReports"), object: nil)
        }
        
        if textInCell == "Generar Ticket" {
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("ticketMaintain"), object: nil)
        }
        
        if textInCell == "Dar Reseña" {
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("giveReview"), object: nil)
        }
        
        if textInCell == "Perfil" {
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("profile"), object: nil)
        }
        
        if textInCell == "Ticket Generados" {
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name("ticketsByTechie"), object: nil)
        }
        
        if textInCell == "Cerrar Sesion" {
            NotificationCenter.default.post(name: Notification.Name("closeSession"), object: nil)
            dismiss(animated: true, completion: nil)
        }
    }
}
