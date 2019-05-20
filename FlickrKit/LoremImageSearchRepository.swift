//
//  Created by Constantine Fry on 20.05.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation
import BusinessLogicKit

public final class LoremImageSearchRepository: ImageSearchRepositoring {

    public init() {}

    public func search(query: SearchQuery, completion: @escaping (Result<Page, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let photos = (1...200).map({ _ in
                return Photo(identifier: UUID().uuidString,
                             url: URL(string: "https://picsum.photos/400")!,
                             title: "")
            })
            completion(.success(Page(page: query.page, pages: 100, photos: photos)))
        }
    }
    
}
