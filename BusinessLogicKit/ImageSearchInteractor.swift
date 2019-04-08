//
//  Created by Constantine Fry on 07.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

public protocol ImageSearchRepositoring {

}

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

public struct Photo {

    let identifier: String
    let url: URL
    let title: String

    public init(identifier: String, url: URL, title: String) {
        self.identifier = identifier
        self.url = url
        self.title = title
    }

}

public enum RepositoryError: Error {
    case failedToCreateUrl
    case failedToLoad
}

public final class ImageSearchInteractor: ImageSearchUseCase {

    private let repository: ImageSearchRepositoring

    public init(repository: ImageSearchRepositoring) {
        self.repository = repository
    }

}
