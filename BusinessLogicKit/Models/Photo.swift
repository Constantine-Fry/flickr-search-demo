//
//  Created by Constantine Fry on 08.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation

public struct Photo {

    public let identifier: String
    let url: URL
    let title: String

    public init(identifier: String, url: URL, title: String) {
        self.identifier = identifier
        self.url = url
        self.title = title
    }

}
