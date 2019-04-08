//
//  Created by Constantine Fry on 07.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

public protocol ImageSearchRepositoring {

}

public struct Photo: Decodable {

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
