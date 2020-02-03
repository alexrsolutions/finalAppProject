//
//  ForgotViewController.swift
//  savedTech
//
//  Created by Alex Ramirez on 2/2/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ForgotViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var warningLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLbl.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updatePassword(_ sender: Any) {
        
        let email = emailField.text ?? ""
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if (error != nil) {
                print("\(String(describing: error))")
            } else {
                self.warningLbl.text = "An email was sent for you to reset your password"
            }
        }
            
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
