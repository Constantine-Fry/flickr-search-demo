//
//  Created by Constantine Fry on 07.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

public protocol ImageSearchViewing {

}

public protocol ImageSearchUseCase {

}

public final class ImageSearchPresenter {

    private let view: ImageSearchViewing
    private let interactor: ImageSearchUseCase

    public init(view: ImageSearchViewing, interactor: ImageSearchUseCase) {
        self.view = view
        self.interactor = interactor
    }

}
