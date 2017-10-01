//
//  AddEditClothesTableViewController.swift
//  Second Hand Inventory
//
//  Created by Ladislav Szolik on 30.09.17.
//  Copyright © 2017 Ladislav Szolik. All rights reserved.
//

import UIKit

class AddEditClothesTableViewController: UITableViewController, QRScannerDelegate, ClothesCategoryDelegate {

    @IBOutlet weak var qrCodeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sizeLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var qrcode:String?
    var category: Category?
    var clothes: Clothes?
    var dateOfCreation: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let clothes = clothes {
            qrcode = clothes.qrcode
            category = clothes.category
            sizeLabel.text = String(clothes.size)
            priceLabel.text = String(clothes.price)
            dateOfCreation = clothes.dateOfCreation
        }
        
        updateQRCode()
        updateCategory()
        updateDate()
        updateSaveButton()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Private functions
    
    // Delegate from QRScanner
    func didScanned(qrcode: String) {
        self.qrcode = qrcode
        updateQRCode()
        updateSaveButton()
    }
    // Delegate from Category
    func didSelect(category: Category) {
        self.category = category
        updateCategory()
        updateSaveButton()
    }

    func updateQRCode() {
        if let qrcode = qrcode {
            qrCodeLabel.text = qrcode
        } else  {
            qrCodeLabel.text = "Nicht gesetzt"
        }
    }
    
    func updateCategory() {
        if let category = category {
            categoryLabel.text = category.name
        } else {
            categoryLabel.text = "Nicht gesetzt"
        }
    }
    
    func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateOfCreation = Date()
        dateLabel.text = dateFormatter.string(from: dateOfCreation!)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func   updateSaveButton(){
        if let _ = qrcode, let _ = category, let price = priceLabel.text, !price.isEmpty, let size = sizeLabel.text, !size.isEmpty {
            
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
          updateSaveButton()
    }
    
    @IBAction func priceEditingChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScanQRCode" {
            let destinationViewController = segue.destination as? QRScannerViewController
            destinationViewController?.delegate = self
            destinationViewController?.qrcode = qrcode
        } else if segue.identifier == "SelectCategory" {
            let destinationViewController = segue.destination as? ClothesCategoryTableViewController
            destinationViewController?.delegate = self
            destinationViewController?.category = category
        } else if segue.identifier == "SaveClothes" {
            guard let priceText = priceLabel.text, let sizeText = sizeLabel.text else {return}
            if let price = Double(priceText), let size = Double(sizeText) {
                clothes = Clothes(qrcode: qrcode!, category: category!, price: price , size: size, dateOfCreation: dateOfCreation!)
            }
        }
    }
    

}
