//
//  TicketMantenimientoViewController.swift
//  savedTech
//
//  Created by Alex Ramirez on 2/23/20.
//  Copyright © 2020 Alex Ramirez. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseFirestore
import FirebaseAuth

class TicketMantenimientoViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    let db = Firestore.firestore()
    
    @IBOutlet weak var pcIdText: UITextField!
    
    @IBOutlet weak var descriptionTickey: UITextView!
    @IBOutlet weak var nameView: UIView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    let idOfTech = ModelData.shared.user_type
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameView.layer.zPosition = 2
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is contains at least one object.
        if metadataObjects.count == 0 {
            return
        }
        
        //self.captureSession?.stopRunning()
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if let outputString = metadataObj.stringValue {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                DispatchQueue.main.async {
                    print(outputString)
                    self.pcIdText.text = outputString
                }
            }
        }
        
        captureSession.stopRunning()
    }
    
    @IBAction func genTicket(_ sender: Any) {
        let date = getCurrentDateTime()
        let tickets = self.db.collection("tickets")
        tickets.document().setData(["id_Number" : self.pcIdText.text ?? "", "id_Ticket" : randomString(length: 9), "Date of Serviec" : date, "id_Tech" : idOfTech, "descriptionTicket" : descriptionTickey.text ?? ""])
        print("Se registro dispositivo")
        dismiss(animated: true)
    }
    
    func getCurrentDateTime() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "EEEE, MMMM,dd,yyyy HH:mm a"
        let str = formatter.string(from: Date())
        print("Date: \(str)")
        return str
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
