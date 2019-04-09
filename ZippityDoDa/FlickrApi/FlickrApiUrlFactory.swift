//
//  Created by Constantine Fry on 08.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation

struct FlickrApiUrlFactory {

    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func makeSearchRequest(text: String) -> URLRequest {
        var components = URLComponents(string: "https://api.flickr.com/services/rest")
        components?.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: self.apiKey),
            URLQueryItem(name: "text", value: text),

            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "safe_search", value: "1"),
        ]
        guard let url = components?.url else {
            assert(false)
        }
        return URLRequest(url: url)
    }

    func makePhotoUrl(photo: PhotoResponseDto.PhotoDto) -> URL {
        return URL(string: "https://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg")!
    }

}
