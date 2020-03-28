//
//  SceneDelegate.swift
//  FeedsSandbox
//
//  Created by Kazuki Yamamoto on 2019/10/14.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import UIKit
import SwiftUI
import SomariSandboxKit
import SomariFoundation
@testable import Feeds

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let accountService = DummyAccountService()
        let feedService = DummyFeedService()
        let storageService = DummyStorageService()
        let feedItemCacheService = DummyFeedItemCacheService()

        let feeds = { FeedsRouter.assembleModules(dependency: .init(
            feedService: feedService,
            storageService: storageService,
            accountService: accountService,
            feedItemCacheService: feedItemCacheService
            ))
        }

        let bufferFeeds = { FeedsRouter.assembleModules(dependency: .init(
            feedService: feedService,
            storageService: storageService,
            accountService: accountService,
            feedItemCacheService: DummyFeedItemCacheService(
                initialBuffer: Array(0..<10).map { FeedItem(
                    title: "Buffer Feed - \($0)",
                    id: "\($0)",
                    feedID: "$0",
                    source: "",
                    link: "https://google.com",
                    date: Date()
                )}
            )))
        }

        let listView = MockListView(viewControllerList: [
            ViewControllerListItem(title: "Simple Feeds", builder: feeds),
            ViewControllerListItem(title: "Buffer Feeds", builder: bufferFeeds)
        ])

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: listView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
