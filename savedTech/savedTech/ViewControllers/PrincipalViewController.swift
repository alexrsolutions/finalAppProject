//
//  PrincipalViewController.swift
//  savedTech
//
//  Created by Alex Ramirez on 2/2/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import SideMenu

class ModelData: NSObject {
    static let shared: ModelData = ModelData()
    var user_type = ""
    var id_User = ""
}

struct Clientes {
    var nombre_empresa: String
    var id_Empresa: String
}

class PrincipalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    var userID = Auth.auth().currentUser?.uid
    var clientes: [Clientes] = []
    var tickets: [String] = []
    var reportes: [String] = []
    
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLbl: UILabel!
    
    var typeOfUser = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(openMenu))
        
        NotificationCenter.default.addObserver(self, selector: #selector(verTickets), name: Notification.Name("ver_Tickets"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(verClientes), name: Notification.Name("ver_Clientes"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(verTecnicos), name: Notification.Name("ver_Tecnicos"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(registerUsers), name: Notification.Name("registerUsers"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(registerMachine), name: Notification.Name("registerMachine"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ticketMaintain), name: Notification.Name("ticketMaintain"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(seeReports), name: Notification.Name("seeReports"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(generateReports), name: Notification.Name("generateReports"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(giveReview), name: Notification.Name("giveReview"), object: nil)
        /*generateReports*/
    }
    
    @objc func openMenu(){
        let LeftMenuNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! SideMenuNavigationController
        
        LeftMenuNavigationController.leftSide = true
        LeftMenuNavigationController.statusBarEndAlpha = 0
        
        present(LeftMenuNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func homeButton(_ sender: Any) {
        let LeftMenuNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! SideMenuNavigationController
        
        LeftMenuNavigationController.leftSide = true
        LeftMenuNavigationController.statusBarEndAlpha = 0
        
        present(LeftMenuNavigationController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userdata = db.collection("users").document(userID ?? "")
        userdata.addSnapshotListener({ (snapshot, error ) in
            if error != nil {
                print("Error: \(error!)")
            }else if let doc = snapshot {
                ModelData.shared.user_type = doc.get("type_user") as! String
                let idUser = doc.get("id_user") ?? ""
                ModelData.shared.id_User = idUser as! String
                print("id_User: \(String(describing: idUser))")
                let welcomeName = doc.get("username") ?? "No Name"
                self.welcomeLbl.text = "WELCOME: \(welcomeName as? String ?? "")"
            }
        })
    }
    
    //Functions for basic activities Admin
    
    @objc func ticketMaintain(notification: NSNotification){
        guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ticketMaintain") as? TicketMantenimientoViewController else {
            print("View controller could not be instantiated")
            return
        }
        
        VC.modalPresentationStyle = .popover
        self.present(VC, animated: true, completion: nil)
    }
    
    @objc func registerMachine(notification: NSNotification){
        welcomeView.isHidden = true
        guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registerMachine") as? TicketRegisterViewController else {
            print("View controller could not be instantiated")
            return
        }
        
        VC.modalPresentationStyle = .popover
        self.present(VC, animated: true, completion: nil)
    }
    
    @objc func registerUsers(notification: NSNotification){
        welcomeView.isHidden = true
        guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registerUser") as? RegisterUserViewController else {
            print("View controller could not be instantiated")
            return
        }
        
        VC.modalPresentationStyle = .popover
        self.present(VC, animated: true, completion: nil)
    }
    
    @objc func verTickets (notification: NSNotification){
        clientes = []
        tickets = []
        reportes = []
        welcomeView.isHidden = true
        let docRef = db.collection("tickets")
        docRef.getDocuments(completion: { (documents, error) in
            if error != nil{
                print(error!)
            } else {
                for document in (documents?.documents)!{
                    if let id_Number = document.data()["id_Number"] as? String{
                        self.tickets.append(id_Number)
                    }
                }
            }
            self.tableView.reloadData()
           })
    }
    
    @objc func verClientes (notification: NSNotification){
        clientes = []
        tickets = []
        reportes = []
        welcomeView.isHidden = true
        let docRef = db.collection("users")
        docRef.getDocuments(completion: { (documents, error) in
            if error != nil{
                print(error!)
            } else {
                for document in (documents?.documents)!{
                    print("Documents: \(document.data())")
                    let userType = document.data()["type_user"] as? String
                    if userType == "user" {
                        if let username = document.data()["username"] as? String {
                            let idUser = document.data()["id_User"] as? String
                            self.clientes.append(Clientes(nombre_empresa: username, id_Empresa: idUser ?? ""))
                        }
                    }
                    
                }
                print("clientes: \(self.clientes.debugDescription)")
            }
            self.tableView.reloadData()
        })
    }
    
    @objc func verTecnicos (notification: NSNotification){
        clientes = []
        tickets = []
        reportes = []
        welcomeView.isHidden = true
        let docRef = db.collection("users")
        docRef.getDocuments(completion: { (documents, error) in
            if error != nil{
                print(error!)
            } else {
                for document in (documents?.documents)!{
                    let userType = document.data()["type_user"] as? String
                    if userType == "tech" {
                        if let username = document.data()["username"] as? String {
                            let idUser = document.data()["id_User"] as? String
                            self.clientes.append(Clientes(nombre_empresa: username, id_Empresa: idUser ?? ""))
                        }
                    }
                    
                }
            }
            self.tableView.reloadData()
        })
    }
    
    @objc func seeReports(notification: NSNotification){
        clientes = []
        tickets = []
        reportes = []
        welcomeView.isHidden = true
        let docRef = db.collection("reportes")
        docRef.getDocuments(completion: { (documents, error) in
            if error != nil{
                print(error!)
            } else {
                for document in (documents?.documents)!{
                    if let id_Number = document.data()["descripcion"] as? String{
                        self.reportes.append(id_Number)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    @objc func generateReports(notification: NSNotification){
        welcomeView.isHidden = true
        guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "genReport") as? GenerateReportViewController else {
            print("View controller could not be instantiated")
            return
        }
        
        VC.modalPresentationStyle = .popover
        self.present(VC, animated: true, completion: nil)
    }
    
    @objc func giveReview(notification: NSNotification){
        guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "giveReview") as? GiveReviewViewController else {
            print("View controller could not be instantiated")
            return
        }
        
        VC.modalPresentationStyle = .popover
        self.present(VC, animated: true, completion: nil)
    }
    
    //Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if clientes.count > 0 {
            numberOfRows = clientes.count
        }
        
        if tickets.count > 0 {
            numberOfRows = tickets.count
        }
        
        if reportes.count > 0 {
            numberOfRows = reportes.count
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if clientes.count > 0 {
            cell.textLabel?.text = "\(clientes[indexPath.row].nombre_empresa)"
        }
        
        if tickets.count > 0 {
            cell.textLabel?.text = "\(tickets[indexPath.row])"
        }
        
        if reportes.count > 0 {
            cell.textLabel?.text = "\(reportes[indexPath.row])"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if clientes.count > 0 {
            print("Seccion Clientes")
            
            guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "showDetails") as? DetailsViewController else {
                print("View controller could not be instantiated")
                return
            }
            
            print(clientes[indexPath.row].id_Empresa)
            db.collection("reportes").whereField("id_Empresa", isEqualTo: clientes[indexPath.row].id_Empresa)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            VC.exampleOfReports.append(document.data()["descripcion"] as! String)
                        }
                        
                        VC.modalPresentationStyle = .popover
                        self.present(VC, animated: true, completion: nil)
                    }
            }
            
            
        } else if tickets.count > 0 {
            print("Seccion Tickets")
            
        } else if reportes.count > 0 {
            print("Seccion Reportes")
            
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete"){ (action, view, completion) in
            
            let docRef = self.db.collection("users")
            var documentIds: String = ""
            docRef.whereField("id_User", isEqualTo: self.clientes[indexPath.row].id_Empresa).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            documentIds = document.documentID
                        }
                        
                        docRef.document(documentIds).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    }
            }
            
            self.clientes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        action.backgroundColor = #colorLiteral(red: 0.824714467, green: 0.2022622079, blue: 0, alpha: 1)
        return action
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete"){ (action, view, completion) in
            
            let docRef = self.db.collection("users")
            var documentIds: String = ""
            docRef.whereField("id_User", isEqualTo: self.clientes[indexPath.row].id_Empresa).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            documentIds = document.documentID
                        }
                    }
            }
            
            self.clientes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        action.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        return action
    }


}
