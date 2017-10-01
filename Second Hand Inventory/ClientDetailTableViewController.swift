//
//  ClientDetailTableViewController.swift
//  Second Hand Inventory
//
//  Created by Ladislav Szolik on 01.10.17.
//  Copyright © 2017 Ladislav Szolik. All rights reserved.
//

import UIKit

class ClientDetailTableViewController: UITableViewController, ClothesListDelegate {
    
    var client: Client?
    var clothesList: [Clothes]?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var numberOfClothesLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the selected client from client list
        if let client = client {
            firstNameTextField.text = client.firstName
            lastNameTextField.text = client.lastName
            addressTextField.text = client.adress
            telephoneTextField.text = client.Telephone
            emailAddressTextField.text = client.emailAddress
            clothesList = client.clothesList
        } else {
            clothesList = [Clothes]()
        }
        
        updateNumberOfClothes()
        updateSaveButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func firstNameEditingChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    @IBAction func lastNameEditingChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    
    // MARK: - Private functions
    
    func updateSaveButton() {
        let lastName = lastNameTextField.text ?? ""
        let firstName = firstNameTextField.text ?? ""        
        saveButton.isEnabled = !(lastName.isEmpty || firstName.isEmpty)
    }
    
    func updateNumberOfClothes() {
        if let clothesList = clothesList {
            numberOfClothesLabel.text = "\(clothesList.count)"
        } else {
            numberOfClothesLabel.text = "Keine Kleider"
        }
    }
    
    // MARK: - Delegate from Clothes list
    
    func didAdded(clothes: Clothes) {
        clothesList?.append(clothes)
    }
    
    func didChanged(clothes: Clothes, at index: Int) {
        clothesList?[index] = clothes
    }
    
    func didRemoved(index: Int) {
        clothesList?.remove(at: index)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowClothesSegue" {
            let clothesListViewController = segue.destination as? ClothesListTableViewController
            clothesListViewController?.delegate = self
            if let clothesList = clothesList {
                clothesListViewController?.clothesList = clothesList
            }
        } else if segue.identifier == "SaveClientSegue" {            
            client = Client(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, adress: addressTextField?.text, Telephone: telephoneTextField?.text, emailAddress: emailAddressTextField?.text, clothesList: clothesList)
        }
    }
 

}
