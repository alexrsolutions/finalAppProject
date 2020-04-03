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
    var idComputer: String = ""
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
        
        let idString = randomString(length: 7)
        
        let image = generateQRCode(from: idString)
        if let dataFromImage = image?.pngData() {
            uploadToDatabase(data: dataFromImage)
        }
        
        users.document().setData(["id_Tech" : idString, "marca" : self.marcaInput.text ?? "", "modelo" : self.modeloInput.text ?? "", "procesador" : self.procesadorInput.text ?? "", "almacenamiento" : self.almacenamientoInput.text ?? "", "urlQr" : self.idComputer])
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
