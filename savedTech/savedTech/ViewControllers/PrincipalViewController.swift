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

class PrincipalViewController: UIViewController {

    @IBOutlet weak var nombreLbl: UILabel!
    @IBOutlet weak var userTypeLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    
    var typeOfUser = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func homeButton(_ sender: Any) {
        let LeftMenuNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! SideMenuNavigationController
        
        LeftMenuNavigationController.leftSide = true
        LeftMenuNavigationController.statusBarEndAlpha = 0
        
        present(LeftMenuNavigationController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        
        let docRef = db.collection("users").document(userID ?? "")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let email = document.data()?["email"] as? String
                self.typeOfUser = document.data()?["type_user"] as? String ?? ""
                let name = document.data()?["username"] as? String
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                self.nombreLbl.text = name
                self.emailLbl.text = email
                self.userTypeLbl.text = self.typeOfUser
                
                if self.typeOfUser != "admin" { self.registerBtn.isHidden = true }
                
            } else {
                print("Document does not exist")
            }
        }
    }

}

extension PrincipalViewController: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}
