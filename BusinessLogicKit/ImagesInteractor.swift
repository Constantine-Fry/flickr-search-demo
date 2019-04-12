//
//  Created by Constantine Fry on 09.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation

public protocol TaskProtocol {
    func resume()
    func cancel()
}

public protocol ImagesRepositoring {
    func loadData(_ url: URL, completion: @escaping (Data?) -> Void) -> TaskProtocol
}

public protocol ImageDecoding {
    func decode(_ data: Data) -> Image?
}

public final class Image {

    let image: CGImage

    init(_ image: CGImage) {
        self.image = image
    }

}

public final class ImagesInteractor: ImagesUseCase {

    private let cache = NSCache<NSString, Image>()
    private var tasks = [String: TaskProtocol]()
    private let repository: ImagesRepositoring
    private let decoder: ImageDecoding
    private let queue: DispatchQueue
    private var completionBlocks = [String: [(Image?) -> Void]]()

    public init(repository: ImagesRepositoring, decoder: ImageDecoding, cacheLimit: Int, queue: DispatchQueue) {
        self.cache.totalCostLimit = cacheLimit
        self.repository = repository
        self.queue = queue
        self.decoder = decoder
    }

    public func cachedImage(for photo: Photo) -> Image? {
        var image: Image?
        self.queue.sync {
            image = self.cache.object(forKey: photo.identifier as NSString)
        }
        return image
    }

    public func loadImage(for photo: Photo, completion: @escaping (Image?) -> Void) {
        let identifier = photo.identifier
        self.queue.async {

            var blocks = self.completionBlocks[identifier] ?? []
            blocks.append(completion)
            self.completionBlocks[identifier] = blocks

            let task = self.repository.loadData(photo.url) { [weak self] (data) in
                self?.queue.async {
                    var result: Image?
                    if let data = data, let image = self?.decoder.decode(data) {
                        self?.cache.setObject(image, forKey: identifier as NSString, cost: data.count)
                        result = image
                    }
                    self?.tasks[identifier] = nil
                    self?.completionBlocks[identifier]?.forEach({ $0(result) })
                    self?.completionBlocks[identifier] = nil
                }
            }
            
            self.tasks[identifier] = task
            task.resume()
        }
    }

    public func stopLoadImage(for photo: Photo) {
        self.queue.sync {
            self.tasks[photo.identifier]?.cancel()
            self.tasks[photo.identifier] = nil
            self.completionBlocks[photo.identifier] = nil
        }
    }

}
