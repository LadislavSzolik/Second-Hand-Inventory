//
//  ClientListTableViewController.swift
//  Second Hand Inventory
//
//  Created by Ladislav Szolik on 01.10.17.
//  Copyright © 2017 Ladislav Szolik. All rights reserved.
//

import UIKit

class ClientListTableViewController: UITableViewController {

    var clients = [Client]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let clients = Client.loadClients() {
            self.clients = clients
        } else {
            self.clients = Client.loadSampleClients()
        }

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath)

        let client = clients[indexPath.row]
        cell.textLabel?.text = "\(client.firstName) \(client.lastName)"
        
        if let clothesList = client.clothesList {
            let numberOfClothes = clothesList.count
            cell.detailTextLabel?.text = "Kleder Stück: \(numberOfClothes)"
        } else {
         cell.detailTextLabel?.text = "Keine Kleider"
        }
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            clients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        Client.saveClients(clients)
    }
    

 
    @IBAction func unwindFromClientDetails(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveClientSegue" else {return}
        
        let clientDetailViewController = segue.source as? ClientDetailTableViewController
        
        if let client = clientDetailViewController?.client {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                clients[selectedIndexPath.row] = client
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: clients.count, section: 0)
                 clients.append(client)
                 tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            Client.saveClients(clients)
        }
        
        
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowClientDetailSegue" {
            let clientDetailViewController = segue.destination as? ClientDetailTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let client = clients[indexPath.row]
            clientDetailViewController?.client = client
            clientDetailViewController?.navigationItem.title = "Ändern Kunde"
        }
    }


}
