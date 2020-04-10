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
        
        warningLbl.isHidden = false
        
        if email.isEmpty {
            self.warningLbl.textColor = UIColor.red
            self.warningLbl.text = "Input an email to send request"
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if (error != nil) {
                print("\(String(describing: error))")
            } else {
                self.warningLbl.textColor = UIColor.green
                self.warningLbl.text = "An email was sent for you to reset your password"
                
                self.dismiss(animated: true, completion: nil)
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
