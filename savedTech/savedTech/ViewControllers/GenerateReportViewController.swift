//
//  GenerateReportViewController.swift
//  savedTech
//
//  Created by Alex Ramirez on 3/1/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class GenerateReportViewController: UIViewController {
    
    let db = Firestore.firestore()
    @IBOutlet weak var inputBigDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        
        inputBigDescription.layer.borderColor = #colorLiteral(red: 0.6118932424, green: 0.6118932424, blue: 0.6118932424, alpha: 1)
        inputBigDescription.layer.borderWidth = 1.0
        // Do any additional setup after loading the view.
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func genReport(_ sender: Any) {
        let users = self.db.collection("reportes")
        users.document().setData(["id_Report" : randomString(length: 7), "descripcion" : self.inputBigDescription.text ?? ""])
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

}
