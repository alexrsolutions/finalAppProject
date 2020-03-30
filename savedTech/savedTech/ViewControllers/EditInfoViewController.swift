//
//  EditInfoViewController.swift
//  savedTech
//
//  Created by Salvador Ramirez on 3/30/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit

class EditInfoViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    
    /*Techies*/
    
    
    /*Enterprises*/
    
    
    /*Report*/
    @IBOutlet weak var textEditDescription: UITextView!
    @IBOutlet weak var enterpriseName: UILabel!
    @IBOutlet weak var reportView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textEditDescription.layer.borderColor = #colorLiteral(red: 0.6118932424, green: 0.6118932424, blue: 0.6118932424, alpha: 1)
        textEditDescription.layer.borderWidth = 1.0
        // Do any additional setup after loading the view.
    }
    

    @IBAction func updateReport(_ sender: Any) {
        
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
