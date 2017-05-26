//
//  ItemCell.swift
//  DreamLister
//
//  Created by JAY PATEL on 5/25/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!

    func configCell(_ item: Item) {
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
        img.image = item.toImage?.image as? UIImage
    }
}
