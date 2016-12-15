//
//  ItemManager.swift
//  Preserve
//
//  Created by The Atlanta Goat on 12/10/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//



import UIKit

//The ItemManager class is what keeps up with the to do list items in regards to whats been saved and whats been checked off.
//There will be an array for the ToDoItems and
//an array for the checked off ToDoItems
//This is the model that will be feed into the tableview controller for both sections


class ItemManager: NSObject {
    
    //variable is a computed variable that returns the number of items in the toDoItems array
    var toDoCount: Int {return toDoItems.count}
    
    //variable is a computed property that returns the number of items in the doneItems array
    var doneCount: Int {return doneItems.count}
    
    //variable available to only this class
    //this variable is an array that holds
    //children ToDoItems
    
    private var toDoItems = [ToDoItem]()
    
    private var doneItems = [ToDoItem]()
    
    var toDoPathURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let documentURL = fileURLs.first else {
            print("Something went wrong.  Documents url could not be found")
            fatalError()
        }
        
        return documentURL.appendingPathComponent("toDoItems.plist")
    }
    
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: .UIApplicationWillResignActive, object: nil)
        
        if let nsToDoItems = NSArray(contentsOf: toDoPathURL){
            
            for dict in nsToDoItems{
                if let toDoItem = ToDoItem(dict: dict as! [String:Any]){
                    toDoItems.append(toDoItem)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }
    
    //this method appends the passed parameter which is a ToDoItem type into the toDoItems array

    func addItem(item: ToDoItem){
        
        if !toDoItems.contains(item){
            
            toDoItems.append(item)
        }
        
        //toDoItems.append(item)
    }
    
    //this method takes the provided parameter from the toDoItems array, locates it, and then returns the item that was
    //at the specified index
    
    func itemAtIndex(index: Int)->ToDoItem{
        
        return toDoItems[index]
        
    }
    
   
    //This method takes the passed parameter index and removes that ToDoItem from the  toDoItems array and then appends it onto the doneItems array
    
    func checkItemAtIndex(index: Int){
        
        let item = toDoItems.remove(at: index)
        
        doneItems.append(item)
        
        
    }
    
    //this method takes the doneItems array and its specified index as a parameter, locates the item, and then returns the item
    //at the specified index
    
    func doneItemAtIndex(index: Int)->ToDoItem{
        
        return doneItems[index]
    }
    
    //this method removes items from both the toDoItems array and the doneItems array if they are holding ToDoItem children
    func removeAllItems(){
        
        toDoItems.removeAll()
        
        doneItems.removeAll()
    }
    
    func uncheckItemAtIndex(index: Int){
        
        let item = doneItems.remove(at: index)
        
        toDoItems.append(item)
    }
    
    func save(){
        
        let nsToDoItems = toDoItems.map { $0.plistDict }
        
        guard nsToDoItems.count > 0 else {
            try? FileManager.default.removeItem(at: toDoPathURL)
            return
        }
        
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: nsToDoItems, format: PropertyListSerialization.PropertyListFormat.xml, options: PropertyListSerialization.WriteOptions(0)
            )
            try plistData.write(to: toDoPathURL, options: Data.WritingOptions.atomic)
        } catch {
            print(error)
        }
        
    }
}


