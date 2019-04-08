//
//  Created by Constantine Fry on 08.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

public struct Page {
    
    let page: UInt
    let pages: UInt
    let photos: [Photo]

    public init(page: UInt, pages: UInt, photos: [Photo]) {
        self.page = page
        self.pages = pages
        self.photos = photos
    }

}
