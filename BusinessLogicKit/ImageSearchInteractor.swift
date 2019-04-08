//
//  Created by Constantine Fry on 07.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

public protocol ImageSearchRepositoring {
    func search(term: String, completion: @escaping (Result<Page, Error>) -> Void)
}

public final class ImageSearchInteractor: ImageSearchUseCase {

    private let repository: ImageSearchRepositoring

    public init(repository: ImageSearchRepositoring) {
        self.repository = repository
    }

    public func search(term: String, completion: @escaping (Result<Page, Error>) -> Void) {
        self.repository.search(term: term) {
            completion($0)
        }
    }

}
