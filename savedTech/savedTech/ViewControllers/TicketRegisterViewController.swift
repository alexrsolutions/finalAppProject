//
//  TicketRegisterViewController.swift
//  savedTech
//
//  Created by Alex Ramirez on 2/17/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class TicketRegisterViewController: UIViewController {

    let db = Firestore.firestore()
    var idString: String = ""
    var idComputer: String = ""
    @IBOutlet weak var marcaInput: UITextField!
    @IBOutlet weak var modeloInput: UITextField!
    @IBOutlet weak var procesadorInput: UITextField!
    @IBOutlet weak var almacenamientoInput: UITextField!
    @IBOutlet weak var warningLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        warningLbl.text = "";
        warningLbl.isHidden = true;
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
            navigationItem.leftBarButtonItem = backButton

            // Do any additional setup after loading the view.
    }
        
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerMachine(_ sender: Any) {
        
        idString = self.randomString(length: 7)
        
        warningLbl.isHidden = true;
        
        if checkForExceptions() == false {
            let image = generateQRCode(from: idString)
            if let dataFromImage = image?.pngData() {
                uploadToDatabase(data: dataFromImage)
            }
        }
    }
    
    func uploadToDatabase(data: Data){
        let imageRef = Storage.storage().reference().child("QrCode/" + self.randomString(length: 20) + ".jpeg")
        imageRef.putData(data, metadata: nil){ (metadata, error) in
            if error != nil{
                print("Error")
            }else{
                imageRef.downloadURL{ url, error in
                    if let error = error {
                        print(error)
                    } else {
                        self.idComputer = url?.absoluteString ?? ""
                        print(self.idComputer)
                        
                        let users = self.db.collection("tech")
                        
                        users.document().setData(["id_Tech" : self.idString, "marca" : self.marcaInput.text ?? "", "modelo" : self.modeloInput.text ?? "", "procesador" : self.procesadorInput.text ?? "", "almacenamiento" : self.almacenamientoInput.text ?? "", "urlQr" : self.idComputer, "rented" : false])
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }
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
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    func checkForExceptions() -> Bool {
        var returnValue = false
        
        if ((marcaInput.text == "") || (marcaInput.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Brand is empty, please complete the input"
            warningLbl.textColor = UIColor.red
            returnValue = true
        } else if ((modeloInput.text == "") || (modeloInput.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Model Number is missing, complete the input"
            warningLbl.textColor = UIColor.red
            returnValue = true
        } else if ((procesadorInput.text == "") || (procesadorInput.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Processor is missing, complete the input"
            warningLbl.textColor = UIColor.red
            returnValue = true
        } else if ((almacenamientoInput.text == "") || (almacenamientoInput.text == " ")) {
            warningLbl.isHidden = false;
            warningLbl.text = "Storage is missing, complete the input"
            warningLbl.textColor = UIColor.red
            returnValue = true
        }
        
        return returnValue
    }

}
