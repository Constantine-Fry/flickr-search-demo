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

    private var router: Router!
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.router = Router(window: self.window!)
        self.router.routeToMainViewController(with: .flickr)
        return true
    }

}

