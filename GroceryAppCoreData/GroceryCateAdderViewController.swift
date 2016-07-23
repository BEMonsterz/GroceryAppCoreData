//
//  DiaryAdderViewController.swift
//  DiaryApp
//
//  Created by Bryan Ayllon on 7/19/16.
//  Copyright © 2016 Bryan Ayllon. All rights reserved.
//

import UIKit
import CoreData

protocol GroceryCateTitle{
    func newTitleWasCreated(title :String!)
    
}

class GroceryCateAdderViewController: UIViewController,UIPageViewControllerDelegate{
    
    var managedContextOfObjects :NSManagedObjectContext!
    var delegate: GroceryCateTitle!
    
    
    @IBOutlet var categoryNameField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    
    
    
    @IBAction func addButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { _ in })
        
        self.delegate.newTitleWasCreated(self.categoryNameField.text)
    }
}
