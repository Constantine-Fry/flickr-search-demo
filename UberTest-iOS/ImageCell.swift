//
//  Created by Constantine Fry on 09.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import UIKit
import BusinessLogicKit

final class ImageCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!

    var photo: Photo?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
}
