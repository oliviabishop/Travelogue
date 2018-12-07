//
//  TripsViewController.swift
//  Travelogue
//
//  Created by Olivia Bishop on 12/6/18.
//  Copyright © 2018 Olivia Bishop. All rights reserved.
//

import UIKit
import CoreData

class TripsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

    var entries = [Entry]()
    var dateFormatter = DateFormatter()
    
    
    @IBOutlet weak var tripsTableView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchEntries()
        tripsTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        
        let entry = Entry[indexPath.row]
        cell.textLabel?.text = entry.title
        if let addDate = entry.addDate {
            cell.detailTextLabel?.text = dateFormatter.string(from: addDate)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            self.deleteNote(indexPath: indexPath)
        }
        
        return [deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? NoteDetailTableViewController else {
            return
        }
        
        if let segueIdentifier = segue.identifier, segueIdentifier == "entry", let indexPathForSelectedRow = tripsTableView.indexPathForSelectedRow {
            destination.entry = entries[indexPathForSelectedRow.row]
        }
    }
    
    func fetchEntries() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            entries = [Entry]()
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rawAddDate", ascending: true)]
        
        do {
            notes = try managedContext.fetch(fetchRequest)
        } catch {
            alertNotifyUser(message: "Fetch for entries failed.")
        }
    }
    
    func deleteEntry(indexPath: IndexPath) {
        let entry = entries[indexPath.row]
        
        if let managedObjectContext = entry.managedObjectContext {
            managedObjectContext.delete(entry)
            
            do {
                try managedObjectContext.save()
                self.entry.remove(at: indexPath.row)
                tripsTableView.reloadData()
            } catch {
                alertNotifyUser(message: "Could not delete entry")
                tripsTableView.reloadData()
            }
        }
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


    


