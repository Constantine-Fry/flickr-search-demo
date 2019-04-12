//
//  Created by Constantine Fry on 09.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation

public protocol TaskProtocol: class {
    var completions: [(Data?) -> Void] { get set }
    func resume()
    func cancel()
}

public protocol ImagesRepositoring {
    func loadData(_ url: URL) -> TaskProtocol
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
    private var tasks = [NSString: TaskProtocol]()
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
        let identifier = photo.identifier as NSString
        self.queue.async {
            let task = self.tasks[identifier] ?? self.repository.loadData(photo.url)
            task.completions.append({ [weak self] (data) in
                self?.queue.async {
                    var result: Image?
                    if let data = data, let image = self?.cache.object(forKey: identifier) ?? self?.decoder.decode(data) {
                        self?.cache.setObject(image, forKey: identifier, cost: data.count)
                        result = image
                    }
                    completion(result)
                    self?.tasks[identifier] = nil
                }
            })
            self.tasks[identifier] = task
            task.resume()
        }
    }

    public func stopLoadImage(for photo: Photo) {
        self.queue.sync {
            self.tasks.removeValue(forKey: photo.identifier as NSString)?.cancel()
        }
    }

}

