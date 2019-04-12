//
//  Created by Constantine Fry on 07.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation

public final class ImageSearchPresenter {

    public weak var view: ImageSearchViewing?
    private let interactor: ImageSearchUseCase
    private let imageLoadingInteractor: ImagesUseCase
    private var term = ""

    public init(interactor: ImageSearchUseCase, imageLoadingInteractor: ImagesUseCase) {
        self.interactor = interactor
        self.imageLoadingInteractor = imageLoadingInteractor
    }

}

extension ImageSearchPresenter: ImageSearchPresenting {

    public func search(term: String) {
        self.view?.update(.showLoading)
        self.term = term
        if term.isEmpty {
            return
        }
        self.interactor.search(query: SearchQuery(text: term, page: 1)) { (result) in
            guard self.term == term else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    self.view?.update(.presentError(NSLocalizedString("Failed", comment: "")))
                case .success(let page):
                    self.view?.update(.set(ImageSearchViewItem(photos: page.photos,
                                                               hasMore: page.page < page.pages,
                                                               page: page.page, text: term)))
                }
            }
        }
    }

    public func loadMore(for item: ImageSearchViewItem) {
        if !item.hasMore {
            return
        }
        let nextPage = item.page + 1
        self.interactor.search(query: SearchQuery(text: item.text, page: nextPage)) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    break
                case .success(let page):
                    self.view?.update(.set(ImageSearchViewItem(photos: item.photos + page.photos,
                                                               hasMore: page.page < page.pages,
                                                               page: nextPage,
                                                               text: item.text)))
                }
            }
        }
    }

}

extension ImageSearchPresenter: ImageLoadPresenting {

    public func cachedImage(for photo: Photo) -> CGImage? {
        return self.imageLoadingInteractor.cachedImage(for: photo)?.image
    }

    public func loadImage(for photo: Photo, completion: @escaping (CGImage?) -> Void) {
        self.imageLoadingInteractor.loadImage(for: photo) { image in
            DispatchQueue.main.async {
                completion(image?.image)
            }
        }
    }

    public func stopLoadImage(for photo: Photo) {
        self.imageLoadingInteractor.stopLoadImage(for: photo)
    }

}
