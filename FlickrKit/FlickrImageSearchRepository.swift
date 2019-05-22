//
//  Created by Constantine Fry on 07.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation
import BusinessLogicKit

public protocol Deserializing {

    var contentTypes: Set<String> { get }

    func deserialize<T: Decodable>(data: Data) throws -> T

}

public final class FlickrImageSearchRepository: ImageSearchRepositoring {

    private let session: URLSession
    private let requestFactory: FlickrApiUrlFactory
    private let queue: DispatchQueue
    private var searchTask: URLSessionTask?
    private let deserializer: Deserializing

    public init(session: URLSession, requestFactory: FlickrApiUrlFactory, deserializer: Deserializing,
                queue: DispatchQueue) {
        self.session = session
        self.requestFactory = requestFactory
        self.queue = queue
        self.deserializer = deserializer
        ResourceCounter.countResource(self)
    }

    public func search(query: SearchQuery, completion: @escaping (Result<Page, Error>) -> Void) {
        let request = self.requestFactory.makeSearchRequest(query: query)
        self.searchTask?.cancel()
        self.searchTask = self.getData(with: request) { (result) in
            self.queue.async {
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let data):
                    do {
                        let page = try self.makePage(from: data)
                        completion(.success(page))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        self.searchTask?.resume()
    }

    private func makePage(from data: Data) throws -> Page {
        let response: PhotoResponseDto = try self.deserializer.deserialize(data: data)
        guard response.stat == "ok" else {
            throw RepositoryError.failedToLoad
        }
        let photos = response.photos.photo.map({ (dto) -> Photo in
            let url = self.requestFactory.makePhotoUrl(photo: dto)
            return Photo(identifier: dto.id, url: url, title: dto.title)
        })
        return Page(page: response.photos.page, pages: response.photos.pages, photos: photos)
    }

    private func getData(with request: URLRequest,
                         completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        return self.session.dataTask(with: request) { (data, response, error) in
            if let error = error as? URLError, error.code == .cancelled {
                return
            }
            let response = response as? HTTPURLResponse
            let contentType = (response?.allHeaderFields["Content-Type"] as? String) ?? ""
            if let data = data, response?.statusCode == 200, self.deserializer.contentTypes.contains(contentType) {
                completion(.success(data))
            } else {
                completion(.failure(RepositoryError.failedToLoad))
            }
        }
    }

}
