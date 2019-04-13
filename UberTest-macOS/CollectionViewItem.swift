//
//  CollectionViewItem.swift
//  UberTest-macOS
//
//  Created by Constantine Fry on 13.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Cocoa
import BusinessLogicKit

class CollectionViewItem: NSCollectionViewItem {

    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.image = nil
    }
    
}
