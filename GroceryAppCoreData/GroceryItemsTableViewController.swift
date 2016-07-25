//
//  GroceryItemsTableViewController.swift
//  GroceryAppCoreData
//
//  Created by Bryan Ayllon on 7/23/16.
//  Copyright © 2016 Bryan Ayllon. All rights reserved.
//

import UIKit
import CoreData

class GroceryItemsTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {

    var managedContextOfObjects :NSManagedObjectContext!
    var groceryCategory :NSManagedObject!

    var fetchedResultsController :NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)

        
        self.title = groceryCategory.valueForKey("grocerytitle") as? String
        
        let fetchRequest = NSFetchRequest(entityName: "GroceryItems")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "groceryItems", ascending: true)]
        
        let sorting = NSPredicate(format: "groceryCategory.grocerytitle = %@", self.title!)
        fetchRequest.predicate = sorting
        
        
        
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
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            break
            
        case .Update:
            break
            
        case .Move:
            break
            
        }
    }
    
    func newItemWasCreated(groceryItems :String!){
    
        let groceryList = NSEntityDescription.insertNewObjectForEntityForName("GroceryCategory", inManagedObjectContext: self.managedContextOfObjects)
        
        groceryList.setValue(title, forKey: "groceryItems")
        
        try! self.managedContextOfObjects.save()
        
    }
    
    
    
    @IBAction func addButtonPressed(){
        let notification = UIAlertController(title: "Add Grocery Item", message: nil, preferredStyle: .Alert)
        notification.addTextFieldWithConfigurationHandler({ (textField) -> Void in
        })
        
        notification.addAction(UIAlertAction(title: "Add Item", style: .Default, handler: { (action) -> Void in
            let textField = notification.textFields![0] as UITextField
            print(textField.text!)
            
            let groceryItem = NSEntityDescription.insertNewObjectForEntityForName("GroceryItems", inManagedObjectContext: self.managedContextOfObjects)
            groceryItem.setValue(textField.text, forKey: "groceryItems")
            
            
            let groceryItems = self.groceryCategory.mutableSetValueForKey("groceryItems")
            
            groceryItems.addObject(groceryItem)
            
            
            try! self.managedContextOfObjects.save()
            
        }))
        
        self.presentViewController(notification, animated: true, completion: nil)
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cells", forIndexPath: indexPath)
        
        let groceryList = self.fetchedResultsController.objectAtIndexPath(indexPath)
        
        
        
        cell.textLabel?.text = groceryList.valueForKey("groceryItems") as? String
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
        }
    }
    
    
    
    

}
