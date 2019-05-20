//
//  Created by Constantine Fry on 20.05.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation
import BusinessLogicKit

public final class JsonDataDeserializer: Deserializing {

    public init() {}

    public var contentTypes: Set<String> = ["application/json", "application/x-javascript",
                                            "text/javascript", "text/x-javascript", "text/x-json"]

    public func deserialize<T: Decodable>(data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw RepositoryError.failedToDeserialize
        }
    }
    
}
