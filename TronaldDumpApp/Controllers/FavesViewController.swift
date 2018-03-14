//
//  FavesViewController.swift
//  TronaldDumpApp
//
//  Created by Žan Fras on 14/03/2018.
//  Copyright © 2018 Žan Fras. All rights reserved.
//

import UIKit
import CoreData

class FavesViewController: UITableViewController {
    
    var faves = [Fave]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadFaves()
    }
    
    //MARK: - TableView Datasource Methods
    /***************************************************************/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return faves.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaveCell", for: indexPath)
        
        cell.textLabel?.text = faves[indexPath.row].quote
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    /***************************************************************/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        context.delete(faves[indexPath.row])
        faves.remove(at: indexPath.row)
        
        tableView.reloadData()
        
    }
    
    //MARK: - Back Bar Button
    /***************************************************************/
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func loadFaves() {
        
        let request: NSFetchRequest<Fave> = Fave.fetchRequest()
        
        do {
            faves = try context.fetch(request)
        } catch {
            print("Error loading faves, \(error)")
        }
        
    }
    
    
}
