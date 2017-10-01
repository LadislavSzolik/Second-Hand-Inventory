//
//  ClothesCategoryTableViewController.swift
//  Second Hand Inventory
//
//  Created by Ladislav Szolik on 30.09.17.
//  Copyright © 2017 Ladislav Szolik. All rights reserved.
//

import UIKit

protocol ClothesCategoryDelegate {
    func didSelect(category: Category)
}

class ClothesCategoryTableViewController: UITableViewController {

    var delegate: ClothesCategoryDelegate?
    var category: Category?
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return Category.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clothesCategoryCell", for: indexPath)
        
        let category = Category.all[indexPath.row]
        cell.textLabel?.text = category.name
        
        if category == self.category {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        category = Category.all[indexPath.row]
        delegate?.didSelect(category: category!)
        tableView.reloadData()
    }
    

}
