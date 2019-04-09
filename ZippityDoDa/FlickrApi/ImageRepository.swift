//
//  Created by Constantine Fry on 09.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import BusinessLogicKit

extension URLSessionTask: TaskProtocol { }

final class ImageRepository: ImagesRepositoring {

    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func loadData(_ url: URL, completion: @escaping (Data?) -> Void) -> TaskProtocol {
        return self.session.dataTask(with: url) { data, _, error in
            if let error = error as? URLError, error.code == .cancelled {
                return
            }
            completion(data)
        }
    }

}


