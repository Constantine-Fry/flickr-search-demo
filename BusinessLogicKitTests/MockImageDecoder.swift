//
//  Created by Constantine Fry on 12.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation
@testable import BusinessLogicKit

public final class MockImageDecoder: ImageDecoding {

    public init() {}

    var decodeCount = 0
    public func decode(_ data: Data) -> Image? {
        if let dataProvider = CGDataProvider(data: data as CFData),
            let image = CGImage(pngDataProviderSource: dataProvider, decode: nil,
                                shouldInterpolate: true, intent: .defaultIntent) {
            self.decodeCount += 1
            return Image(image)
        }
        return nil
    }

}
