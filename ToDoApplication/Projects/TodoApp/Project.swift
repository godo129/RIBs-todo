import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "ToDoApp",
    platform: .iOS,
    product: .app,
    organizationName: "co.godo",
//    entitlements: "Projects/TodoApp/Derived/Sources/TodoApp.entitlements",
    dependencies: [
        .project(target: "ThirdPartyLib", path: .relativeToRoot("Projects/ThirdPartyLib")),
    ],
    resources: ["Resources/**"],
    //    infoPlist: .file(path: "Derived/InfoPlists/TodoApp-Info.plist")
    infoPlist: .extendingDefault(with: [
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                        "UISceneStoryboardFile": "HomeView"
                    ],
                ]
            ]
        ],
        "UIBackgroundModes": "remote-notification",
        "NSPhotoLibraryUsageDescription": "포토 라이브러리에 접근하기 위해 권한이 필요합니다."
    ]),
    additionalTargets: ["Resources"]
)
