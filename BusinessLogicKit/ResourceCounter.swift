//
//  Created by Constantine Fry on 21.05.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation

private let weakArray = NSHashTable<AnyObject>.weakObjects()

public struct ResourceCounter {

    private static let queue = DispatchQueue(label: "com.uber.test.object.counter.queue")

    public static func countResource(_ any: AnyObject) {
        #if DEBUG
        self.queue.sync {
            weakArray.add(any)
        }
        #endif
    }

    public static func count() -> Int {
        var result = 0
        self.queue.sync {
            result = weakArray.allObjects.count
        }
        return result
    }

}
