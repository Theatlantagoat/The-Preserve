//
//  InputViewController.swift
//  Preserve
//
//  Created by The Atlanta Goat on 12/13/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import UIKit
import CoreLocation


class InputViewController: UIViewController {
    
    var itemManager: ItemManager?
    
    lazy var geocoder = CLGeocoder()
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var transparentDismissKeyboardButton: UIButton!
    
    let dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter
        
    }()
    
    
    @IBAction func dismissKeyboard(_ sender: UIButton) {
        
       titleTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        

    }
    @IBAction func save(){
        
        guard let titleString = titleTextField.text, titleString.characters.count > 0 else { return }
        
        let date: Date?
        if let dateText = self.dateTextField.text, dateText.characters.count > 0 {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil
        }
        
        let descriptionString: String?
        if (descriptionTextField.text?.characters.count)! > 0 {
            descriptionString = descriptionTextField.text
        } else {
            descriptionString = nil
        }
        
        if let locationName = locationTextField.text, locationName.characters.count > 0 {
            if let address = addressTextField.text, address.characters.count > 0 {
                
                geocoder.geocodeAddressString(address) {
                    [unowned self] (placeMarks, error) -> Void in
                    
                    let placeMark = placeMarks?.first
                    
                    let item = ToDoItem(title: titleString,
                                        itemDescription: descriptionString,
                                        timestamp: date?.timeIntervalSince1970,
                                        location: Location(name: locationName,
                                                           coordinate: placeMark?.location?.coordinate))
                    
                    DispatchQueue.main.async(execute: {
                        self.itemManager?.addItem(item: item)
                        self.dismiss(animated: true)
                    })
                }
            } else {
                let item = ToDoItem(title: titleString,
                                    itemDescription: descriptionString,
                                    timestamp: date?.timeIntervalSince1970,
                                    location: Location(name: locationName))
                
                itemManager?.addItem(item: item)
                dismiss(animated: true, completion: nil)
            }
        } else {
            let item = ToDoItem(title: titleString,
                                itemDescription: descriptionString,
                                timestamp: date?.timeIntervalSince1970,
                                location: nil)
            
            itemManager?.addItem(item: item)
            dismiss(animated: true, completion: nil)
        }

    }
    
    @IBAction func cancelEnteringToDo(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
