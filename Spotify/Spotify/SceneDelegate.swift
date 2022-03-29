//
//  SceneDelegate.swift
//  Spotify
//
//  Created by Alperen Selçuk on 8.02.2022.
//  Copyright © 2022 Alperen Selçuk. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene         = windowScene
        window?.backgroundColor     = .spotifyBlack
        window?.makeKeyAndVisible()
        
        let navigationController    = UINavigationController(rootViewController: TitleBarController())
        window?.rootViewController  = navigationController
        
//        window?.rootViewController  = HomeController()
        
        UINavigationBar.appearance().isTranslucent  = false
        UINavigationBar.appearance().tintColor      = .spotifyBlack
    }
}

