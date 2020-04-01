//
//  RegisterUserViewController.swift
//  savedTech
//
//  Created by Alex Ramirez on 2/2/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth

class RegisterUserViewController: UIViewController {
    
    let db = Firestore.firestore()

    @IBOutlet weak var emailReg: UITextField!
    @IBOutlet weak var nameReg: UITextField!
    @IBOutlet weak var typeReg: UITextField!
    @IBOutlet weak var enterpriseReg: UITextField!
    @IBOutlet var cityButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton

        // Do any additional setup after loading the view.
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func regsiterBtn(_ sender: Any) {
        if let email = emailReg.text {
            
            Auth.auth().createUser(withEmail: email, password: "savedTech", completion: { user, error in
                
                if let firebaseError = error{
                    print(firebaseError.localizedDescription)
                    return
                }
                
                let users = self.db.collection("users")
                
                users.document().setData(["email" : self.emailReg.text ?? "", "password" : "savedTech", "type_user" : self.typeReg.text ?? "", "username" : self.nameReg.text ?? "", "empresa" : self.enterpriseReg.text ?? "", "id_User" : self.randomString(length: 7)])
                
            })
        }
    }
    
    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    
    @IBAction func handleSelection(_ sender: Any) {
    }
    

}
