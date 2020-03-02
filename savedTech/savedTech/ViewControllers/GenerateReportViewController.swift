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
    @IBOutlet weak var inputDescription: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func genReport(_ sender: Any) {
        let users = self.db.collection("reportes")
        users.document().setData(["id_Report" : randomString(length: 7), "descripcion" : self.inputDescription.text ?? ""])
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
