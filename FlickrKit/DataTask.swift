//
//  Created by Constantine Fry on 12.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation
import BusinessLogicKit

final class DataTask: TaskProtocol {

    var completions: [(Data?) -> Void] = []
    var didResume = false
    var task: URLSessionTask?

    func cancel() {
        self.task?.cancel()
    }

    func resume() {
        if !self.didResume {
            self.task?.resume()
            self.didResume = true
        }
    }

}
