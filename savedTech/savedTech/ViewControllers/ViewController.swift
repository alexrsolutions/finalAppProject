//
//  ViewController.swift
//  savedTech
//
//  Created by Alex Ramirez on 2/2/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var loginAction: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginAction.layer.borderWidth = 2
        loginAction.layer.cornerRadius = loginAction.frame.height/2
        loginAction.layer.borderColor = UIColor.white.cgColor
        loginAction.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        errorLabel.isHidden = true
    }

    @IBAction func logInAction(_ sender: Any) {
        
        let username = usernameField.text ?? ""
        let password = passField.text ?? ""
        
        Auth.auth().signIn(withEmail: username, password: password) { (users, error) in
            if users != nil{
                // Safe Present
                self.performSegue(withIdentifier: "login", sender: self)
            }else{
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Email or Password Incorrect. Try Again."
            }
        }
    }
    
    @IBAction func forgotPass(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "forgotView") as? ForgotViewController
        {
            vc.modalPresentationStyle = .popover
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

