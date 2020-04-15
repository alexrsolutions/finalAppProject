//
//  GiveReviewViewController.swift
//  savedTech
//
//  Created by Alex Ramirez on 3/21/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth

class GiveReviewViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var reviewInput: UITextView!
    @IBOutlet weak var warningLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.warningLbl.isHidden = true
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        
        reviewInput.layer.borderColor = #colorLiteral(red: 0.6118932424, green: 0.6118932424, blue: 0.6118932424, alpha: 1)
        reviewInput.layer.borderWidth = 1.0
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addReview(_ sender: Any) {
        self.warningLbl.isHidden = true
        
        if checkForExceptions() == false {
            let users = self.db.collection("reviews")
            users.document().setData(["id_Review" : randomString(length: 7), "id_User" : ModelData.shared.id_User, "review" : self.reviewInput.text ?? ""])
            self.dismiss(animated: true, completion: nil)
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
    
    func checkForExceptions() -> Bool {
        var returnValue = false
        
        if ((reviewInput.text == "") || (reviewInput.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Please write a quick review"
            warningLbl.textColor = UIColor.red
            returnValue = true
        }
        
        return returnValue
    }

}
