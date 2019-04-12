//
//  Created by Constantine Fry on 09.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation
import BusinessLogicKit

public final class ImageRepository: ImagesRepositoring {

    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    public func loadData(_ url: URL) -> TaskProtocol {
        let task = DataTask()
        task.task = self.session.dataTask(with: url) { [weak task] data, _, error in
            if let error = error as? URLError, error.code == .cancelled {
                return
            }
            task?.completions.forEach({ $0(data )})
            task?.completions = []
        }
        return task
    }

}


