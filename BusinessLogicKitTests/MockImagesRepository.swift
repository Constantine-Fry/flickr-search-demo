//
//  Created by Constantine Fry on 12.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation
@testable import BusinessLogicKit

final class MockImagesRepository: ImagesRepositoring {

    final class MockDataTask: TaskProtocol {

        var didCancel = false
        var didResume = false

        var completions: [(Data?) -> Void] = []

        func cancel() {
            self.didCancel = true
        }

        func resume() {
            self.didResume = true
        }

    }

    var tasks = [MockDataTask]()
    func loadData(_ url: URL) -> TaskProtocol {
        let task = MockDataTask()
        DispatchQueue.main.async {
            if !task.didCancel {
                let url = Bundle(for: MockImagesRepository.self).url(forResource: "download", withExtension: "png")!
                task.completions.forEach({ $0( try? Data(contentsOf: url)) })
            }
        }
        self.tasks.append(task)
        return task
    }

}
