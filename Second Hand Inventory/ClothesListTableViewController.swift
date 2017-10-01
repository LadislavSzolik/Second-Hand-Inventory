//
//  ClothesListTableViewController.swift
//  Second Hand Inventory
//
//  Created by Ladislav Szolik on 30.09.17.
//  Copyright © 2017 Ladislav Szolik. All rights reserved.
//

import UIKit

protocol ClothesListDelegate {
    func didAdded(clothes: Clothes)
    func didChanged(clothes:Clothes, at index: Int)
    func didRemoved(index: Int)
}

class ClothesListTableViewController: UITableViewController {
    
    var clothesList = [Clothes]()
    var delegate:ClothesListDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return clothesList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothesCell", for: indexPath)

        let clothes = clothesList[indexPath.row]
        cell.textLabel?.text = clothes.category.name
        cell.detailTextLabel?.text = "\(clothes.price) CHF"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.didRemoved(index: indexPath.row)
            clothesList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func unwindFromClothes(segue: UIStoryboardSegue) {
        guard let clothesViewController = segue.source as? AddEditClothesTableViewController, let clothes = clothesViewController.clothes else {return}
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            clothesList[selectedIndexPath.row] = clothes
            delegate?.didChanged(clothes: clothes, at: selectedIndexPath.row)
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            clothesList.append(clothes)
            delegate?.didAdded(clothes: clothes)
            tableView.reloadData()
        }
    }

    
   
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditClothes" {
            let editClothesViewController = segue.destination as? AddEditClothesTableViewController
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let clothes = clothesList[selectedIndexPath.row]
                editClothesViewController?.clothes = clothes
            }
        }
    }
    

}
