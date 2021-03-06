//
//  Created by Constantine Fry on 08.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation
import BusinessLogicKit

public struct FlickrApiUrlFactory {

    private let apiKey: String

    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    // https://www.flickr.com/services/api/flickr.photos.search.html
    func makeSearchRequest(query: SearchQuery) -> URLRequest {
        var components = URLComponents(string: "https://api.flickr.com/services/rest")
        components?.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: self.apiKey),
            URLQueryItem(name: "text", value: query.text),
            URLQueryItem(name: "page", value: "\(query.page)"),

            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "safe_search", value: "1"),
        ]
        guard let url = components?.url else {
            fatalError()
        }
        return URLRequest(url: url)
    }

    // https://www.flickr.com/services/api/misc.urls.html
    func makePhotoUrl(photo: PhotoResponseDto.PhotoDto) -> URL {
        var farm = photo.farm
        if farm == 0 {
            farm = 1
        }
        // It seems there is an issue with static.flickr.com https://www.flickr.com/help/forum/en-us/72157677738897767/
        return URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_m.jpg")!
    }

}
