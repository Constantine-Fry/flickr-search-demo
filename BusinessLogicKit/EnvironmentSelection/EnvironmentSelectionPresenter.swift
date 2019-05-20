//
//  Created by Constantine Fry on 20.05.19.
//  Copyright © 2019 lololo. All rights reserved.
//

public struct SelectionItem {
    public let title: String
    public let action: () -> ()
}

public struct EnvironmentSelectionState {
    public let title: String
    public let items: [SelectionItem]
}

public protocol EnvironmentSelectionViewing: class {
    func set(state: EnvironmentSelectionState)
}

public enum Environment {
    // Uses Flick API to search images.
    case flickr
    // Uses Picsum API to return mocked images.
    case picsum
    // Uses Placekitten API to return mocked images.
    case placekittens
}

public protocol EnvironmentSelectionPresenting {
    func ready()
}

public final class EnvironmentSelectionPresenter: EnvironmentSelectionPresenting {

    public weak var view: EnvironmentSelectionViewing?
    private let didChange: (Environment?) -> ()

    public init(didChange: @escaping (Environment?) -> ()) {
        self.didChange = didChange
    }

    public func ready() {
        let items = [
            SelectionItem(title: "Flickr API", action: { [weak self] in self?.didChange(.flickr) }),
            SelectionItem(title: "Picsum API", action: { [weak self] in self?.didChange(.picsum) }),
            SelectionItem(title: "Cute Kittens API", action: { [weak self] in self?.didChange(.placekittens) }),
            SelectionItem(title: "Remove window.rootViewController", action: { [weak self] in self?.didChange(nil) }),
        ]
        self.view?.set(state: EnvironmentSelectionState(title: "Select Environment", items: items))
    }

}
