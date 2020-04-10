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
import iOSDropDown

class RegisterUserViewController: UIViewController {
    
    let db = Firestore.firestore()

    @IBOutlet weak var emailReg: UITextField!
    @IBOutlet weak var nameReg: UITextField!
    @IBOutlet weak var typeReg: UITextField!
    @IBOutlet weak var enterpriseReg: UITextField!
    @IBOutlet var cityButtons: [UIButton]!
    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var phoneReg: UITextField!
    @IBOutlet weak var addressReg: UITextField!
    @IBOutlet weak var warningLbl: UILabel!
    
    var type_user: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        
        warningLbl.isHidden = true;

        // The list of array to display. Can be changed dynamically
        dropDown.optionArray = ["Client", "Technician", "Administrator"]
        dropDown.layer.borderWidth = 1.0
        dropDown.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        //Its Id Values and its optional
        dropDown.optionIds = [1,23,54,22]

        // The the Closure returns Selected Index and String
        dropDown.didSelect{(selectedText , index ,id) in
            switch(index){
            case 0:
                self.type_user = "client"
                break
            case 1:
                self.type_user = "tech"
                break
            case 2:
                self.type_user = "admin"
                break
            default:
                self.type_user = ""
                break
            }
        }
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func regsiterBtn(_ sender: Any) {
        self.warningLbl.isHidden = true
        if checkForExceptions() == false {
            if let email = emailReg.text {
                
                Auth.auth().createUser(withEmail: email, password: "savedTech", completion: { user, error in
                    
                    if let firebaseError = error{
                        print(firebaseError.localizedDescription)
                        return
                    }
                    
                    let users = self.db.collection("users")
                    
                    users.document().setData(["email" : self.emailReg.text ?? "", "password" : "savedTech", "type_user" : self.type_user, "username" : self.nameReg.text ?? "", "empresa" : self.enterpriseReg.text ?? "", "id_User" : self.randomString(length: 7), "phone" : self.phoneReg.text ?? "", "address" : self.addressReg.text ?? ""])
                    
                    self.warningLbl.isHidden = false;
                    self.warningLbl.text = "User created"
                    self.warningLbl.textColor = UIColor.green
                    
                    self.dismiss(animated: true, completion: nil)
                })
            }
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
    

    func checkForExceptions() -> Bool {
        var returnValue = false
        
        if ((emailReg.text == "") || (emailReg.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Email is empty, please complete the input"
            warningLbl.textColor = UIColor.red
            returnValue = true
        } else if ((nameReg.text == "") || (nameReg.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Name is missing, complete the input"
            warningLbl.textColor = UIColor.red
            returnValue = true
        } else if ((enterpriseReg.text == "") || (enterpriseReg.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Enterprise is missing, complete the input"
            warningLbl.textColor = UIColor.red
            returnValue = true
        } else if (type_user == "") {
            warningLbl.isHidden = false;
            warningLbl.text = "User Type is missing, please select one"
            warningLbl.textColor = UIColor.red
            returnValue = true
        } else if ((phoneReg.text == "") || (phoneReg.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Phone is missing, complete the input"
            warningLbl.textColor = UIColor.red
            returnValue = true
        } else if ((addressReg.text == "") || (emailReg.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Address is missing, complete the input"
            warningLbl.textColor = UIColor.red
            returnValue = true
        }
        
        return returnValue
    }
}
