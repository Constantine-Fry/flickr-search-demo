//
//  AppDelegate.swift
//  ZippityDoDa
//
//  Created by Constantine Fry on 07.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var repo: FlickrImageSearchRepository!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // This is raw bytes of Flickr API key. It doesn't add much of security, because one can anyway use
        // MITM to see all the request app sends, but anyway at least the key wouldn't be visible with strings command line.
        let keyData: [UInt8] = [51, 101, 55, 99, 99, 50, 54, 54, 97, 101, 50, 98, 48, 101, 48,
                                100, 55, 56, 101, 50, 55, 57, 99, 101, 56, 101, 51, 54, 49, 55, 51, 54]

        self.repo = FlickrImageSearchRepository(
            session: URLSession(configuration: .default),
            requestFactory: FlickrApiUrlFactory(apiKey: String(bytes: keyData, encoding: .utf8)!),
            queue: DispatchQueue(label: "com.app.flickr-repository.queue"))

        self.repo.search(term: "kittens") { (result) in
            print(result)
        }

        return true
    }

}

