//
//  Created by Constantine Fry on 07.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation
import BusinessLogicKit

final class FlickrImageSearchRepository: ImageSearchRepositoring {

    private let session: URLSession
    private let requestFactory: FlickrApiUrlFactory
    private let queue: DispatchQueue

    init(session: URLSession, requestFactory: FlickrApiUrlFactory, queue: DispatchQueue) {
        self.session = session
        self.requestFactory = requestFactory
        self.queue = queue
    }

    public func search(term: String, completion: @escaping (Result<Page, Error>) -> Void) {
        let request = self.requestFactory.makeSearchRequest(text: term)
        let requestFactory = self.requestFactory
        self.getData(with: request) { (result) in
            self.queue.async {
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(PhotoResponseDto.self, from: data)
                        guard response.stat == "ok" else {
                            throw RepositoryError.failedToLoad
                        }
                        let photos = response.photos.photo.map({ (dto) -> Photo in
                            let url = requestFactory.makePhotoUrl(photo: dto)
                            return Photo(identifier: dto.id, url: url, title: dto.title)
                        })
                        completion(.success(Page(page: response.photos.page,
                                                 pages: response.photos.pages,
                                                 photos: photos)))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    public func getData(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = self.session.dataTask(with: request) { (data, response, error) in
            let response = response as? HTTPURLResponse
            if let data = data, response?.statusCode == 200 {
                completion(.success(data))
            } else {
                completion(.failure(RepositoryError.failedToLoad))
            }
        }
        task.resume()
    }

}
