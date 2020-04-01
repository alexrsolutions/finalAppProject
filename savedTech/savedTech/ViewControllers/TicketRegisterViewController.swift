//
//  TicketRegisterViewController.swift
//  savedTech
//
//  Created by Alex Ramirez on 2/17/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class TicketRegisterViewController: UIViewController {

    let db = Firestore.firestore()
    @IBOutlet weak var marcaInput: UITextField!
    @IBOutlet weak var modeloInput: UITextField!
    @IBOutlet weak var procesadorInput: UITextField!
    @IBOutlet weak var almacenamientoInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
            navigationItem.leftBarButtonItem = backButton

            // Do any additional setup after loading the view.
    }
        
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerMachine(_ sender: Any) {
        let users = self.db.collection("tech")
        
        users.document().setData(["id_Tech" : randomString(length: 7), "marca" : self.marcaInput.text ?? "", "modelo" : self.modeloInput.text ?? "", "procesador" : self.procesadorInput.text ?? "", "almacenamiento" : self.almacenamientoInput.text ?? ""])
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
