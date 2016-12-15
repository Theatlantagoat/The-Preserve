//
//  ItemListViewController.swift
//  Preserve
//
//  Created by The Atlanta Goat on 12/11/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

//this class ItemLisViewController will serve as the view that is shown when The Preserve app starts.
//this class will have a table view property that is connected to the Item List View Controller scene in the main storyboard

import UIKit

class ItemListViewController: UIViewController {
    
    let itemManager = ItemManager()
    
   
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!
    
    override func viewDidLoad() {
        
        tableView.dataSource = dataProvider
        
        tableView.delegate = dataProvider
        
        dataProvider.itemManager = itemManager
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDetails(sender:)), name: NSNotification.Name("ItemSelectedNotification"), object: nil)
        
    }
    @IBAction func addItem(_ sender: UIBarButtonItem) {

        
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
            
            nextViewController.itemManager = self.itemManager
            
            present(nextViewController, animated: true, completion: nil)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func showDetails(sender: NSNotification) {
        
        guard let index = sender.userInfo?["index"] as? Int else { fatalError() }
        
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            
            nextViewController.itemInfo = (itemManager, index)
            
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}
