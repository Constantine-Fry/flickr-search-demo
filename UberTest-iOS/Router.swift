//
//  Created by Constantine Fry on 20.05.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Foundation
import UIKit

import BusinessLogicKit
import FlickrKit


final class Router {

    private let window: UIWindow
    private let storyboard: UIStoryboard

    init(window: UIWindow, storyboard: UIStoryboard) {
        self.window = window
        self.storyboard = storyboard
    }

    func routeToMainViewController(with environment: Environment) {

        let searchRepository: ImageSearchRepositoring
        let session = URLSession(configuration: .default)
        var name = ""
        switch environment {
        case .picsum:
            name = "Picsum API"
            searchRepository = LoremImageSearchRepository(url: URL(string: "https://picsum.photos/400")!)
        case .placekittens:
            name = "PlaceKittens API"
            searchRepository = LoremImageSearchRepository(url: URL(string: "https://placekitten.com/g/300/300")!)
        case .flickr:
            name = "Flickr API"
            // This is raw bytes of Flickr API key. It doesn't add much of security, because one can anyway use
            // MITM to see all the request app sends, but anyway at least the key wouldn't be visible with strings command line.
            let keyData: [UInt8] = [51, 101, 55, 99, 99, 50, 54, 54, 97, 101, 50, 98, 48, 101, 48,
                                    100, 55, 56, 101, 50, 55, 57, 99, 101, 56, 101, 51, 54, 49, 55, 51, 54]

            searchRepository = FlickrImageSearchRepository(
                session: session,
                requestFactory: FlickrApiUrlFactory(apiKey: String(bytes: keyData, encoding: .utf8)!),
                deserializer: JsonDataDeserializer(),
                queue: DispatchQueue(label: "com.app.flickr-repository.queue"))
        }

        let loadingRepository = ImageRepository(session: session)
        let loadingInteractor = LoadImagesInteractor(repository: loadingRepository,
                                                     decoder: DefaultJPEGImageDecoder(),
                                                     cacheLimit: 60*1024*1024)
        let presenter = ImageSearchPresenter(interactor: ImageSearchInteractor(repository: searchRepository),
                                             imageLoadingInteractor: loadingInteractor)
        let viewController = self.storyboard.instantiateViewController(withIdentifier: "mainVC")
            as! SearchViewController
        presenter.view = viewController
        viewController.name = name
        viewController.presenter = presenter

        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .done, target: self,
                                                                          action: #selector(routeToEnvironmentSelectionViewController))
        self.window.rootViewController = navigationController
    }

    @objc func routeToEnvironmentSelectionViewController() {
        self.presentEnvironmentSelectionViewController(on: self.window.rootViewController!)
    }

    func presentEnvironmentSelectionViewController(on onViewController: UIViewController) {
        let viewController = self.storyboard.instantiateViewController(withIdentifier: "environmentSelectionVC")
            as! EnvironmentSelectionViewController
        let presenter = EnvironmentSelectionPresenter { [weak self, weak viewController] environment in
            viewController?.dismiss(animated: true, completion: {
                if let environment = environment {
                    self?.routeToMainViewController(with: environment)
                } else {
                    let viewController = self?.storyboard.instantiateViewController(withIdentifier: "memoryLeaksVC") as! TextViewController
                    self?.window.rootViewController = viewController
                    DispatchQueue.main.async {
                        viewController.label.text = "This ViewController is here to check the app for memory leaks.\nThere is \(ResourceCounter.count()) resources."
                    }
                }
            })
        }
        presenter.view = viewController
        viewController.presenter = presenter
        onViewController.present(UINavigationController(rootViewController: viewController),
                                 animated: true, completion: nil)
    }

}
