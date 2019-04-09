//
//  Created by Constantine Fry on 07.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

public protocol ImageSearchViewing: class {
    func update(_ update: ImageViewUpdate)
}

public protocol ImageSearchUseCase {
    func search(term: String, completion: @escaping (Result<Page, Error>) -> Void)
}

public protocol ImagesUseCase {
    func cachedImage(for photo: Photo) -> CGImage?
    func loadImage(for photo: Photo, completion: @escaping (CGImage?) -> Void)
    func stopLoadImage(for photo: Photo)
}

public protocol ImageSearchPresenting {
    func search(term: String)
    func cachedImage(for photo: Photo) -> CGImage?
    func loadImage(for photo: Photo, completion: @escaping (CGImage?) -> Void)
    func stopLoadImage(for photo: Photo)
}

public struct ImageSearchViewItem {
    public let photos: [Photo]
    public let hasMore: Bool
}

public enum ImageViewUpdate {
    case showEmpty
    case presentError(String)
    case set(ImageSearchViewItem)
    case append(ImageSearchViewItem)
}

public final class ImageSearchPresenter: ImageSearchPresenting {

    public weak var view: ImageSearchViewing?
    private let interactor: ImageSearchUseCase
    private let imageLoadingInteractor: ImagesUseCase
    private var term = ""

    public init(interactor: ImageSearchUseCase, imageLoadingInteractor: ImagesUseCase) {
        self.interactor = interactor
        self.imageLoadingInteractor = imageLoadingInteractor
    }

    public func search(term: String) {
        self.view?.update(.showEmpty)
        self.term = term
        if term.isEmpty {
            return
        }
        self.interactor.search(term: term) { (result) in
            guard self.term == term else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    self.view?.update(.presentError(NSLocalizedString("Failed", comment: "")))
                case .success(let page):
                    self.view?.update(.set(ImageSearchViewItem(photos: page.photos,
                                                               hasMore: page.page < page.pages)))
                }
            }
        }
    }

    public func cachedImage(for photo: Photo) -> CGImage? {
        return self.imageLoadingInteractor.cachedImage(for: photo)
    }

    public func loadImage(for photo: Photo, completion: @escaping (CGImage?) -> Void) {
        self.imageLoadingInteractor.loadImage(for: photo) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }

    public func stopLoadImage(for photo: Photo) {
        self.imageLoadingInteractor.stopLoadImage(for: photo)
    }

    func loadMore() {

    }



}
