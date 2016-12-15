//
//  DetailViewController.swift
//  Preserve
//
//  Created by The Atlanta Goat on 12/12/16.
//  Copyright © 2016 The Atlanta Goat. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var itemInfo: (ItemManager, Int)?
    
    
    //this is an excellent example of a computed variable
    let dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter
        
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        guard let itemInfo = itemInfo else { return }
        
        let item = itemInfo.0.itemAtIndex(index: itemInfo.1)
        
        titleLabel.text = item.title
        
        locationLabel.text = item.location?.name
        
        descriptionLabel.text = item.itemDescription
        
        if let timestamp = item.timestamp {
            
            let date = Date(timeIntervalSince1970: timestamp)
            
            dateLabel.text = dateFormatter.string(from: date)
        }
        
        if let coordinate = item.location?.coordinate {
            
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
            
            mapView.region = region
            
        }
    }
    
    func checkItem(){
        
        if let itemInfo = itemInfo {
            
            itemInfo.0.checkItemAtIndex(index: itemInfo.1)
        }
        
    }
    @IBAction func tappedCheckOffToDoItem(_ sender: UIButton) {
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
