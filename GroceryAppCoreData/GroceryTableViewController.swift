//
//  DiaryTableViewController.swift
//  DiaryApp
//
//  Created by Bryan Ayllon on 7/19/16.
//  Copyright © 2016 Bryan Ayllon. All rights reserved.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController,NSFetchedResultsControllerDelegate,GroceryCateTitle {
    
    var managedContextOfObjects :NSManagedObjectContext!
    
    var fetchedResultsController :NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "GroceryCategory")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "grocerytitle", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContextOfObjects, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController.delegate = self
        
        try! self.fetchedResultsController.performFetch()
        
        
        
    }
    
    
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type) {
            
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            break
            
        case .Delete:
            break
            
        case .Update:
            break
            
        case .Move:
            break
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let addDiaryController = segue.destinationViewController as? GroceryCateAdderViewController
        addDiaryController!.delegate = self
        
    }
    
    
    func newTitleWasCreated(title :String!){
    
        let groceryList = NSEntityDescription.insertNewObjectForEntityForName("GroceryCategory", inManagedObjectContext: self.managedContextOfObjects)
        
        groceryList.setValue(title, forKey: "grocerytitle")
        
        try! self.managedContextOfObjects.save()
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("Featched Results Error")
        }
        
        return sections[section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let groceryList = self.fetchedResultsController.objectAtIndexPath(indexPath)
        
        
        
        cell.textLabel?.text = groceryList.valueForKey("grocerytitle") as? String
        print()
        // Configure the cell...
        print()
        return cell
    }
    
    
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let entryData: NSManagedObject = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
            
            self.managedContextOfObjects.deleteObject(entryData)
            
            try! self.managedContextOfObjects.save()
            
            self.tableView.reloadData()
        }
    }
    
    
    
    
}
