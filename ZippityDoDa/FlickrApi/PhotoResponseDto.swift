//
//  Created by Constantine Fry on 08.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation

struct PhotoResponseDto: Decodable {

    struct PhotoDto: Decodable {
        let `id`: String
        let farm: UInt
        let secret: String
        let server: String
        let title: String
    }

    struct PhotosDto: Decodable {
        let page: UInt
        let pages: UInt
        let perpage: UInt
        let photo: [PhotoDto]
    }

    let photos: PhotosDto
    let stat: String
}
