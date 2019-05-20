//
//  Created by Constantine Fry on 11.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

public struct ImageSearchViewItem {
    public let photos: [Photo]
    public let hasMore: Bool

    let page: UInt
    let text: String
}

public enum ImageViewState {
    case showEmpty
    case showLoading
    case presentError(String)
    case set(ImageSearchViewItem)
}

public struct SearchQuery {
    public let text: String
    public let page: UInt
}
