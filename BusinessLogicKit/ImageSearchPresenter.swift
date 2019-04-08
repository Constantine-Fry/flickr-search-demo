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

public protocol ImageSearchPresenting {
    func search(term: String)
}

public struct ImageViewItem {
    public let url: URL
}

public struct ImageSearchViewItem {
    public let images: [ImageViewItem]
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
    private var term = ""

    public init(interactor: ImageSearchUseCase) {
        self.interactor = interactor
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
                    self.view?.update(.set(ImageSearchViewItem(images: page.photos.map( { ImageViewItem(url: $0.url) }),
                                                              hasMore: page.page < page.pages)))
                }
            }
        }
    }

    func loadMore() {

    }



}
