//
//  AppDelegate.swift
//  ZippityDoDa
//
//  Created by Constantine Fry on 07.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import UIKit

import BusinessLogicKit
import FlickrKit

enum Environment {
    case nothing
    case flickr
    case picsum
    case placekittens
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var environment: Environment = .nothing {
        didSet {
            self.window?.rootViewController = UINavigationController(rootViewController: self.makeMainViewController(for: self.environment))
        }
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.environment = .picsum
        // Testing memory leaks
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            self.environment = .nothing
//        }

        return true
    }

    private func makeMainViewController(for environment: Environment) -> UIViewController {

        let searchRepository: ImageSearchRepositoring
        let session = URLSession(configuration: .default)

        switch environment {
        case .nothing:
            return UIViewController()
        case .picsum:
            searchRepository = LoremImageSearchRepository(url: URL(string: "https://picsum.photos/400")!)
        case .placekittens:
            searchRepository = LoremImageSearchRepository(url: URL(string: "https://placekitten.com/g/400/400")!)
        case .flickr:
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
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC") as! ViewController
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }

}

