//
//  DiaryTableViewController.swift
//  DiaryApp
//
//  Created by Bryan Ayllon on 7/19/16.
//  Copyright © 2016 Bryan Ayllon. All rights reserved.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    

    var managedContextOfObjects :NSManagedObjectContext!
    
    var fetchedResultsController :NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        
        let fetchRequest = NSFetchRequest(entityName: "GroceryCategory")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "grocerytitle", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContextOfObjects, sectionNameKeyPath: nil, cacheName: nil)
        
        self.fetchedResultsController.delegate = self
        
        try! self.fetchedResultsController.performFetch()
    }

    @IBAction func addButtonPressed(){
        let notification = UIAlertController(title: "Add Grocery Category", message: nil, preferredStyle: .Alert)
        notification.addTextFieldWithConfigurationHandler({ (textField) -> Void in
        })
        
        notification.addAction(UIAlertAction(title: "Add Category", style: .Default, handler: { (action) -> Void in
            let textField = notification.textFields![0] as UITextField
            print(textField.text!)
            
            let groceryCategory = NSEntityDescription.insertNewObjectForEntityForName("GroceryCategory", inManagedObjectContext: self.managedContextOfObjects)
            
            groceryCategory.setValue(textField.text, forKey: "grocerytitle")
            
            try! self.managedContextOfObjects.save()

        }))
        self.presentViewController(notification, animated: true, completion: nil)

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
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("Invalid IndexPath")
        }
        
        let groceryCategory = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        
        
        guard let groceryItemsTableViewController = segue.destinationViewController as? GroceryItemsTableViewController else {
            fatalError("Destination controller not found")
        }
        
        groceryItemsTableViewController.groceryCategory = groceryCategory
        groceryItemsTableViewController.managedContextOfObjects = self.managedContextOfObjects
        
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
        
        
        
        let groceryItems = groceryList.valueForKey("groceryItems") as? NSSet
        

        cell.detailTextLabel?.text = "\(groceryItems!.count)"
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
