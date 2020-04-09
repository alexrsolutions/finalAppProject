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
import MessageUI

class ModelData: NSObject {
    static let shared: ModelData = ModelData()
    var user_type = ""
    var id_User = ""
}

struct Users {
    var username: String
    var name_empresa: String
    var email: String
    var address: String
    var id_Empresa: String
    var type_user: String
}

struct Reportes {
    var descripcion: String
    var id_Empresa: String
    var id_Report: String
    var id_Tech: String
    var id_Techie: String
}

struct Tickets {
    var descripcion: String
    var date_generate: String
    var id_Tech: String
    var id_Techie: String
    var id_Ticket: String
}

class PrincipalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    let db = Firestore.firestore()
    var userID = Auth.auth().currentUser?.uid
    var clientes: [Users] = []
    var tickets: [Tickets] = []
    var reportes: [Reportes] = []
    var id_User: String = ""
    
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var enterpriseLbl: UILabel!
    @IBOutlet weak var adminBanner: UILabel!
    
    var typeOfUser = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(openMenu))
        
        NotificationCenter.default.addObserver(self, selector: #selector(verTickets), name: Notification.Name("ver_Tickets"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(verClientes), name: Notification.Name("ver_Clientes"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(registerUsers), name: Notification.Name("registerUsers"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(registerMachine), name: Notification.Name("registerMachine"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ticketMaintain), name: Notification.Name("ticketMaintain"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(seeReports), name: Notification.Name("seeReports"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(generateReports), name: Notification.Name("generateReports"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(giveReview), name: Notification.Name("giveReview"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(seeTechies), name: Notification.Name("seeTechies"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(profile), name: Notification.Name("profile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ticketsByTechie), name: Notification.Name("ticketsByTechie"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeSession), name: Notification.Name("closeSession"), object: nil)
        /*seeTechies*/
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
        let user_email = Auth.auth().currentUser?.email
        let docRef = self.db.collection("users")
        docRef.whereField("email", isEqualTo: user_email ?? "").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if querySnapshot!.documents.count == 1 {
                    for document in (querySnapshot?.documents)!{
                        print("Data: \(document.data())")
                        ModelData.shared.user_type = document.data()["type_user"] as! String
                        let idUser = document.data()["id_User"] ?? ""
                        ModelData.shared.id_User = idUser as! String
                        let welcomeName = document.data()["username"] ?? "No Name"
                        let emailAddress = document.data()["email"] ?? "No Name"
                        if ModelData.shared.user_type != "admin" {
                            let enterprise = document.data()["empresa"] ?? "No Name"
                            self.enterpriseLbl.isHidden = false
                            self.enterpriseLbl.text = "\(enterprise)"
                            if ModelData.shared.user_type == "user" {
                                self.adminBanner.text = "Client"
                            } else if ModelData.shared.user_type == "tech" {
                                self.adminBanner.text = "Techie"
                            }
                        } else {
                            self.adminBanner.text = "Admin"
                        }
                        self.welcomeLbl.text = "WELCOME: \(welcomeName as? String ?? "")"
                        self.emailLbl.text = "Email: \(emailAddress as? String ?? "")"
                    }
                }
            }
        }
    }
    
    //Functions for basic activities Admin
    
    @objc func ticketMaintain(notification: NSNotification){
        guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ticketMaintain") as? TicketMantenimientoViewController else {
            print("View controller could not be instantiated")
            return
        }
        
        VC.modalPresentationStyle = .popover
        let navController = UINavigationController(rootViewController: VC)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func registerMachine(notification: NSNotification){
        welcomeView.isHidden = true
        guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registerMachine") as? TicketRegisterViewController else {
            print("View controller could not be instantiated")
            return
        }
        
        VC.modalPresentationStyle = .popover
        let navController = UINavigationController(rootViewController: VC)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func registerUsers(notification: NSNotification){
        welcomeView.isHidden = true
        
        guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registerUser") as? RegisterUserViewController else {
            print("View controller could not be instantiated")
            return
        }
        
        VC.modalPresentationStyle = .popover
        let navController = UINavigationController(rootViewController: VC)
        self.present(navController, animated: true, completion: nil)
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
                    if let id_Ticket = document.data()["id_Ticket"] as? String{
                        let description = document.data()["descripcion"] as? String
                        let date = document.data()["fecha"] as? String
                        let techie = document.data()["id_Techie"] as? String
                        let tech = document.data()["id_Number"] as? String
                        self.tickets.append(Tickets(descripcion: description ?? "", date_generate: date ?? "", id_Tech: tech ?? "", id_Techie: techie ?? "", id_Ticket: id_Ticket))
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
                    if userType == "client" {
                        if let username = document.data()["username"] as? String {
                            let idUser = document.data()["id_User"] as? String
                            let type = document.data()["type_user"] as? String
                             let empresa = document.data()["empresa"] as? String
                            let emailUser = document.data()["email"] as? String
                           let addresUser = document.data()["address"] as? String
                            self.clientes.append(Users(username: username, name_empresa: empresa ?? "", email: emailUser ?? "", address: addresUser ?? "", id_Empresa: idUser ?? "", type_user: type ?? ""))
                        }
                    }
                    
                }
                print("clientes: \(self.clientes.debugDescription)")
            }
            self.tableView.reloadData()
        })
    }
    
    @objc func seeTechies (notification: NSNotification){
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
                            let type = document.data()["type_user"] as? String
                           let empresa = document.data()["empresa"] as? String
                           let emailUser = document.data()["email"] as? String
                           let addresUser = document.data()["address"] as? String
                            self.clientes.append(Users(username: username, name_empresa: empresa ?? "", email: emailUser ?? "", address: addresUser ?? "", id_Empresa: idUser ?? "", type_user: type ?? ""))
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
        
        if ModelData.shared.user_type == "tech" {
            let docRef = self.db.collection("reportes")
            docRef.whereField("id_Techie", isEqualTo: ModelData.shared.id_User).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            if let id_Report = document.data()["id_Report"] as? String{
                                let id_Techie = document.data()["id_Techie"] as? String
                                let id_Tech = document.data()["id_Tech"] as? String
                                let empresa = document.data()["id_Empresa"] as? String
                                let description = document.data()["descripcion"] as? String
                                self.reportes.append(Reportes(descripcion: description ?? "", id_Empresa: empresa ?? "", id_Report: id_Report, id_Tech: id_Tech ?? "", id_Techie: id_Techie ?? ""))
                            }
                        }
                    }
                self.tableView.reloadData()
            }
        } else if ModelData.shared.user_type == "client" {
            let docRef = self.db.collection("reportes")
            
            print(ModelData.shared.id_User)
            docRef.whereField("id_Empresa", isEqualTo: ModelData.shared.id_User).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            if let id_Report = document.data()["id_Report"] as? String{
                                let id_Techie = document.data()["id_Techie"] as? String
                                let id_Tech = document.data()["id_Tech"] as? String
                                let empresa = document.data()["id_Empresa"] as? String
                                let description = document.data()["descripcion"] as? String
                                self.reportes.append(Reportes(descripcion: description ?? "", id_Empresa: empresa ?? "", id_Report: id_Report, id_Tech: id_Tech ?? "", id_Techie: id_Techie ?? ""))
                            }
                        }
                    }
                self.tableView.reloadData()
            }
        } else {
            let docRef = db.collection("reportes")
            docRef.getDocuments(completion: { (documents, error) in
                if error != nil{
                    print(error!)
                } else {
                    for document in (documents?.documents)!{
                        if let id_Report = document.data()["id_Report"] as? String{
                            let id_Techie = document.data()["id_Techie"] as? String
                            let id_Tech = document.data()["id_Tech"] as? String
                            let empresa = document.data()["id_Empresa"] as? String
                            let description = document.data()["descripcion"] as? String
                            self.reportes.append(Reportes(descripcion: description ?? "", id_Empresa: empresa ?? "", id_Report: id_Report, id_Tech: id_Tech ?? "", id_Techie: id_Techie ?? ""))
                        }
                    }
                }
                self.tableView.reloadData()
            })
        }
    }
    
    @objc func closeSession(notification: NSNotification){
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    @objc func generateReports(notification: NSNotification){
        welcomeView.isHidden = true
        guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "genReport") as? GenerateReportViewController else {
            print("View controller could not be instantiated")
            return
        }
        VC.modalPresentationStyle = .popover
        let navController = UINavigationController(rootViewController: VC)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func giveReview(notification: NSNotification){
        guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "giveReview") as? GiveReviewViewController else {
            print("View controller could not be instantiated")
            return
        }
        VC.modalPresentationStyle = .popover
        let navController = UINavigationController(rootViewController: VC)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func profile(notification: NSNotification){
        welcomeView.isHidden = false
    }
    
    @objc func ticketsByTechie(notification: NSNotification){
        clientes = []
        tickets = []
        reportes = []
        welcomeView.isHidden = true
        
        let docRef = self.db.collection("tickets")
        docRef.whereField("id_Techie", isEqualTo: ModelData.shared.id_User).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let id_Ticket = document.data()["id_Ticket"] as? String{
                            let description = document.data()["descripcion"] as? String
                            let date = document.data()["fecha"] as? String
                            let techie = document.data()["id_Techie"] as? String
                            let tech = document.data()["id_Number"] as? String
                            self.tickets.append(Tickets(descripcion: description ?? "", date_generate: date ?? "", id_Tech: tech ?? "", id_Techie: techie ?? "", id_Ticket: id_Ticket))
                        }
                    }
                }
            self.tableView.reloadData()
        }
    }
    
    //MARK: TableView Delegates
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailsTableViewCell
        
        cell.empresaLbl.text = ""
        cell.imageDefault.image = UIImage(named: "blank-profile-picture")
        cell.emailLbl.text = ""
        cell.usernameLbl.text = ""
        
        if clientes.count > 0 {
            cell.empresaLbl.text = "Enterprise: \(clientes[indexPath.row].name_empresa)"
            cell.usernameLbl.text = "Client: \(clientes[indexPath.row].username)"
            cell.imageDefault.image = UIImage(named: "blank-profile-picture")
            cell.emailLbl.text = "Email: \(clientes[indexPath.row].email)"
            cell.addressLbl.text = "Address: \(clientes[indexPath.row].address)"
        }
        
        if tickets.count > 0 {
            cell.addressLbl.text = "Description: \(tickets[indexPath.row].descripcion)"
            cell.imageDefault.image = UIImage(named: "no_computer")
            cell.empresaLbl.text = "Id: \(tickets[indexPath.row].id_Ticket)"
            cell.emailLbl.text = "Date: \(tickets[indexPath.row].date_generate)"
            
            db.collection("users").whereField("id_User", isEqualTo: tickets[indexPath.row].id_Techie)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let username = document.data()["username"] as? String
                            cell.usernameLbl.text = "Techie: \(username ?? "")"
                        }
                    }
            }
        }
        
        if reportes.count > 0 {
            cell.imageDefault.image = UIImage(named: "no_computer")
            cell.usernameLbl.text = "Id Report: \(reportes[indexPath.row].id_Report)"
            cell.addressLbl.text = "Description: \(reportes[indexPath.row].descripcion)"
            
            db.collection("users").whereField("id_User", isEqualTo: reportes[indexPath.row].id_Empresa)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let username = document.data()["username"] as? String
                            cell.empresaLbl.text = "Enterprise: \(username ?? "")"
                        }
                    }
            }
            
            db.collection("users").whereField("id_User", isEqualTo: reportes[indexPath.row].id_Techie)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let username = document.data()["username"] as? String
                            cell.emailLbl.text = "Techie: \(username ?? "")"
                        }
                    }
            }
            
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
            
            if clientes[indexPath.row].type_user == "tech" {
                print(clientes[indexPath.row].id_Empresa)
                db.collection("tickets").whereField("id_Techie", isEqualTo: clientes[indexPath.row].id_Empresa)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                VC.exampleOfReports.append(document.data()["descripcion"] as! String)
                            }
                            VC.modalPresentationStyle = .popover
                            let navController = UINavigationController(rootViewController: VC)
                            self.present(navController, animated: true, completion: nil)
                        }
                }
            } else {
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
                            let navController = UINavigationController(rootViewController: VC)
                            self.present(navController, animated: true, completion: nil)
                        }
                }
            }
            
        } else if tickets.count > 0 {
            guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editInfo") as? EditInfoViewController else {
                print("View controller could not be instantiated")
                return
            }
            
            VC.titleFromBase = "Ticket Revision"
            VC.id_Info = self.tickets[indexPath.row].id_Ticket
            VC.isButtonHidden = true
            VC.modalPresentationStyle = .popover
            let navController = UINavigationController(rootViewController: VC)
            self.present(navController, animated: true, completion: nil)
            
        } else if reportes.count > 0 {
            
            guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editInfo") as? EditInfoViewController else {
                print("View controller could not be instantiated")
                return
            }
            
            VC.titleFromBase = "Report Revision"
            VC.id_Info = self.reportes[indexPath.row].id_Report
            VC.isButtonHidden = true
            VC.modalPresentationStyle = .popover
            let navController = UINavigationController(rootViewController: VC)
            self.present(navController, animated: true, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if ModelData.shared.user_type == "admin" {
            let delete = deleteAction(at: indexPath)
            let edit = editAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [delete, edit])
        } else if ModelData.shared.user_type == "tech" {
            let edit = editAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [edit])
        } else {
            return nil
        }
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete"){ (action, view, completion) in
            
            if self.clientes.count > 0 {
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
            
            if self.reportes.count > 0 {
                let docRef = self.db.collection("reportes")
                var documentIds: String = ""
                docRef.whereField("id_Report", isEqualTo: self.reportes[indexPath.row].id_Report).getDocuments() { (querySnapshot, err) in
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
                
                self.reportes.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if self.tickets.count > 0 {
                let docRef = self.db.collection("tickets")
                var documentIds: String = ""
                docRef.whereField("id_Ticket", isEqualTo: self.tickets[indexPath.row].id_Ticket).getDocuments() { (querySnapshot, err) in
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
                
                self.tickets.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        action.backgroundColor = #colorLiteral(red: 0.824714467, green: 0.2022622079, blue: 0, alpha: 1)
        return action
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction{
        
        let action = UIContextualAction(style: .destructive, title: "Edit"){ (action, view, completion) in
            
            if self.clientes.count > 0 {
                guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editUser") as? EditUserViewController else {
                    print("View controller could not be instantiated")
                    return
                }
                
                VC.headingTitle = "Edit Client Info"
                VC.id_Info = self.clientes[indexPath.row].id_Empresa
                
                VC.modalPresentationStyle = .popover
                let navController = UINavigationController(rootViewController: VC)
                self.present(navController, animated: true, completion: nil)
            }
            
            if self.reportes.count > 0 {
                guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editInfo") as? EditInfoViewController else {
                    print("View controller could not be instantiated")
                    return
                }
                
                VC.titleFromBase = "Edit Reports"
                VC.id_Info = self.reportes[indexPath.row].id_Report
                VC.isButtonHidden = false
                
                VC.modalPresentationStyle = .popover
                let navController = UINavigationController(rootViewController: VC)
                self.present(navController, animated: true, completion: nil)
            }
            
            if self.tickets.count > 0 {
                guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editInfo") as? EditInfoViewController else {
                    print("View controller could not be instantiated")
                    return
                }
                
                VC.titleFromBase = "Edit Ticket Info"
                VC.id_Info = self.tickets[indexPath.row].id_Ticket
                VC.isButtonHidden = false
                
                VC.modalPresentationStyle = .popover
                let navController = UINavigationController(rootViewController: VC)
                self.present(navController, animated: true, completion: nil)
            }
            
        }
        action.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        return action
    }

}
