//
//  Created by Constantine Fry on 12.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//
import Foundation

public final class DefaultJPEGImageDecoder: ImageDecoding {

    public init() {}

    public func decode(_ data: Data) -> Image? {
        if let dataProvider = CGDataProvider(data: data as CFData),
            let image = CGImage(jpegDataProviderSource: dataProvider, decode: nil,
                                shouldInterpolate: true, intent: .defaultIntent) {
            return Image(image)
        }
        return nil
    }
    
}
