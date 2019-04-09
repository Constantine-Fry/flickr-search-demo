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

public final class ImagesInteractor: ImagesUseCase {

    private let cache = NSCache<NSString, CGImage>()
    private var tasks = [String: TaskProtocol]()
    private let repository: ImagesRepositoring
    private let queue: DispatchQueue
    private var completionBlocks = [String: [(CGImage?) -> Void]]()

    public init(repository: ImagesRepositoring, queue: DispatchQueue) {
        self.cache.countLimit = 30
        self.repository = repository
        self.queue = queue
    }


    public func cachedImage(for photo: Photo) -> CGImage? {
        var image: CGImage?
        self.queue.sync {
            image = self.cache.object(forKey: photo.identifier as NSString)
        }
        return image
    }

    public func loadImage(for photo: Photo, completion: @escaping (CGImage?) -> Void) {
        let identifier = photo.identifier
        self.queue.async {

            var blocks = self.completionBlocks[identifier] ?? []
            blocks.append(completion)
            self.completionBlocks[identifier] = blocks

            let task = self.repository.loadData(photo.url) { [weak self] (data) in
                self?.queue.async {
                    self?.tasks[identifier] = nil
                    var result: CGImage?
                    if let data = data, let dataProvider = CGDataProvider(data: data as CFData),
                        let image = CGImage(jpegDataProviderSource: dataProvider, decode: nil,
                                            shouldInterpolate: true, intent: .defaultIntent) {
                        result = image
                        self?.cache.setObject(image, forKey: identifier as NSString)
                    }
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
