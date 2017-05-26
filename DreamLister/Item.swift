//
//  Item.swift
//  DreamLister
//
//  Created by JAY PATEL on 5/25/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import Foundation

extension Item {
    
    // Called when an entity (Item) is created/inserted into the NSManagedObjectContext
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
    
}
