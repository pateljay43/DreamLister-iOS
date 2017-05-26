//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by JAY PATEL on 5/25/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: CustomTextField!
    @IBOutlet weak var lblPrice: CustomTextField!
    @IBOutlet weak var lblDetails: CustomTextField!
    @IBOutlet weak var picker: UIPickerView!

    var stores = [Store]()
    var itemToEdit: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeTitleFromBackButton()
        
        picker.delegate = self
        picker.dataSource = self
        
//        let store = Store(context: context)
//        store.name = "Apple"
//        let store2 = Store(context: context)
//        store2.name = "Best Buy"
//        let store3 = Store(context: context)
//        store3.name = "Costco"
//        let store4 = Store(context: context)
//        store4.name = "Tesla Dealership"
//        appDelegate.saveContext()
        
        fetchStores()
        loadItemData()
    }
    
    func removeTitleFromBackButton() {
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stores[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func fetchStores() {
        let fetchReq: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.stores = try context.fetch(fetchReq)
            self.picker.reloadAllComponents()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            lblTitle.text = item.title
            lblPrice.text = String(describing: item.price)
            lblDetails.text = item.details
            img.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                var x = 0
                while x < (stores.count) {
                    if stores[x].name == store.name {
                        picker.selectRow(x, inComponent: 0, animated: false)
                        break
                    }
                    x += 1
                }
            }
        }
    }
    
    @IBAction func saveItemPressed(_ sender: UIButton) {
        let item: Item = (itemToEdit == nil) ? Item(context: context) : itemToEdit!
        
        if let title = self.lblTitle.text {
            item.title = title
        }
        if let price = lblPrice.text {
            item.price = Double(price)!
        }
        if let details = lblDetails.text {
            item.details = details
        }
        
        // assigning store via 'toStore' relationship
        item.toStore = stores[picker.selectedRow(inComponent: 0)]
        
        appDelegate.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
}
