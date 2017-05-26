//
//  ViewController.swift
//  DreamLister
//
//  Created by JAY PATEL on 5/25/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
//        generateTestData()
        attemptFetch()
    }

    func configCell(_ cell: ItemCell, for path: IndexPath) {
        cell.configCell(controller.object(at: path))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configCell(cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "oldItem", sender: item)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "oldItem" {
            if let dest = segue.destination as? ItemDetailsVC{
                if let item = sender as? Item {
                    dest.itemToEdit = item
                }
            }
        }
    }
    
    func attemptFetch() {
        let fetchReq: NSFetchRequest<Item> = Item.fetchRequest()
        
        // default in segment "Newest"
        // key : "created" field in the datamodel
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchReq.sortDescriptors = [dateSort]
        
        // In iOS 10: persistentContainer handles the NSManagedObjectContext
        // sectionNameKeyPath = nil -> return all the results
        controller = NSFetchedResultsController(fetchRequest: fetchReq, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    // whenever tableview is about to update, this will listen to changes and handle them
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // once content has changed, called to finish transaction on tableview
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // listen to an insert,deletion,modification,move
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configCell(cell, for: indexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    func generateTestData() {
        let item = Item(context: context)       // created inside the context (in memory)
        item.title = "MacBook Pro"
        item.price = 1599.99
        item.details = "Best developer laptop in the world"
        
        let item2 = Item(context: context)
        item2.title = "iPhone 7"
        item2.price = 659.99
        item2.details = "Everything is changed. But nothing is changed from iPhone 6"
        
        let item3 = Item(context: context)
        item3.title = "Tesla"
        item3.price = 80000
        item3.details = "Dream car coming soon"
        
        
        // make the data persistant (save in DB)
        appDelegate.saveContext()
    }
}

