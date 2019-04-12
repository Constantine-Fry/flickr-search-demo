//
//  Created by Constantine Fry on 12.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation

public protocol ImageSearchViewing: class {
    func update(_ state: ImageViewState)
}

public protocol ImageSearchUseCase {
    func search(query: SearchQuery, completion: @escaping (Result<Page, Error>) -> Void)
}

public protocol ImagesUseCase {
    func cachedImage(for photo: Photo) -> Image?
    func loadImage(for photo: Photo, completion: @escaping (Image?) -> Void)
    func stopLoadImage(for photo: Photo)
}

public protocol ImageSearchPresenting {
    func search(term: String)
    func loadMore(for item: ImageSearchViewItem)
}

public protocol ImageLoadPresenting {
    func cachedImage(for photo: Photo) -> CGImage?
    func loadImage(for photo: Photo, completion: @escaping (CGImage?) -> Void)
    func stopLoadImage(for photo: Photo)
}
