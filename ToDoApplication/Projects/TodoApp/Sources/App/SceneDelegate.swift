//
//  SceneDelegate.swift
//  ToDoApp
//
//  Created by hong on 2023/07/31.
//

import UIKit
import RIBs
import LocalProvider
import NetworkProvider

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var launchRouter: LaunchRouting?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
//        guard let _ = (scene as? UIWindowScene) else { return }
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            let todoRepository = TodoRepository(
                todoProvider: TodoProvider.instance,
                plistProvider: PlistProvider<LocalTargetType>(),
                userDefaultsProvider: UserDefaultsProvider<LocalTargetType>(),
                nsCacheProvider: NSCacheProvider<LocalTargetType>()
            )
            let imageRepository = ImageRepository(
                imageProvider: ImageProvider(),
                catAndDogProvider: NetworkProvider<CatAndDogAPI>(),
                anyProvider: NetworkProvider<AnyAPI>(),
                nsChacheProvider: NSCacheProvider<LocalTargetType>(),
                plistProvider: PlistProvider<LocalTargetType>(),
                userdefaultsProvier: UserDefaultsProvider<LocalTargetType>()
            )
            let launchRouter = RootBuilder(dependency: AppComponent(
                todoRepository: todoRepository,
                imageRepository: imageRepository
            )).build()
            self.launchRouter = launchRouter
            // UIWindow의 rootViewController로 UINavigationController를 설정합니다.
            launchRouter.launch(from: window)
        }
        
    }
}
