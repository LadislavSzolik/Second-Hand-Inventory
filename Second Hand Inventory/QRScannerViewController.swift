//
//  QRScannerViewController.swift
//  Second Hand Inventory
//
//  Created by Ladislav Szolik on 30.09.17.
//  Copyright © 2017 Ladislav Szolik. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRScannerDelegate {
    func didScanned(qrcode: String)
}

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var previewLayer = AVCaptureVideoPreviewLayer()
    var delegate: QRScannerDelegate?
    var qrcode:String?
    var session:AVCaptureSession!
    @IBOutlet weak var videoViewHolder: UIView!
    @IBOutlet weak var scannedLabel: UILabel!
    @IBOutlet weak var scanAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannedLabel.isHidden = true
        scanAgainButton.isHidden = true
        //Creating session
        self.session = AVCaptureSession()
        
        //Define capture devcie
        let captureDevice = AVCaptureDevice.default(for: .video)
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch
        {
            print ("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        self.session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = videoViewHolder.bounds
        videoViewHolder.layer.addSublayer(previewLayer)
        session.startRunning()
    }

    @IBAction func scanAgainTapped(_ sender: Any) {
        scannedLabel.isHidden = true
        scanAgainButton.isHidden = true
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    qrcode = object.stringValue
                    scannedLabel.isHidden = false
                    scanAgainButton.isHidden = false
                    if let qrcode = qrcode {
                       scannedLabel.text = "Scan Fertig: \(qrcode)"
                        delegate?.didScanned(qrcode: qrcode)
                    }
                    session.stopRunning()
                }
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
