//
//  AppDelegate.swift
//  UberTest-macOS
//
//  Created by Constantine Fry on 12.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Cocoa
import BusinessLogicKit
import FlickrKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // This is raw bytes of Flickr API key. It doesn't add much of security, because one can anyway use
        // MITM to see all the request app sends, but anyway at least the key wouldn't be visible with strings command line.
        let keyData: [UInt8] = [51, 101, 55, 99, 99, 50, 54, 54, 97, 101, 50, 98, 48, 101, 48,
                                100, 55, 56, 101, 50, 55, 57, 99, 101, 56, 101, 51, 54, 49, 55, 51, 54]

        let session = URLSession(configuration: .default)
        let searchRepository = FlickrImageSearchRepository(
            session: session,
            requestFactory: FlickrApiUrlFactory(apiKey: String(bytes: keyData, encoding: .utf8)!),
            deserializer: JsonDataDeserializer(),
            queue: DispatchQueue(label: "com.app.flickr-repository.queue"))
        let loadingRepository = ImageRepository(session: session)
        let loadingInteractor = LoadImagesInteractor(repository: loadingRepository,
                                                     decoder: DefaultJPEGImageDecoder(),
                                                     cacheLimit: 60*1024*1024)
        let presenter = ImageSearchPresenter(interactor: ImageSearchInteractor(repository: searchRepository),
                                             imageLoadingInteractor: loadingInteractor)
        let viewController = NSApplication.shared.windows.first?.contentViewController as! ViewController
        presenter.view = viewController
        viewController.presenter = presenter

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

