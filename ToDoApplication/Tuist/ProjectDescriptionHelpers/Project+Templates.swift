import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

public extension Project {
    static func makeModule(
        name: String,
        platform: Platform = .iOS,
        product: Product,
        organizationName: String = "YourOrganizationName",
//        entitlements: String? = nil,
        packages: [Package] = [],
        deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "15.0", devices: [.iphone, .ipad]),
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        infoPlist: InfoPlist = .default,
        additionalTargets: [String] = []
    ) -> Project {
        
//        let baseSetting: [String: SettingValue] = [
//            "MARKETING_VERSION": "1.0",
//            "CURRENT_PROJECT_VERSION": "1.0.0.0"
//        ]
        
        let dogConfiguration = Configuration.debug(
            name: "Dog",
            settings: [
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "Dog",
            ],
            xcconfig: .relativeToRoot("Projects/TodoApp/Configurations/todo.dog.xcconfig")
        )
        
        let catConfiguration = Configuration.debug(
            name: "Cat",
            settings: [
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "Cat",
            ],
            xcconfig: .relativeToRoot("Projects/TodoApp/Configurations/todo.cat.xcconfig")
        )
        
        let settings: Settings = .settings(
            configurations: [
                .debug(name: .debug),
                dogConfiguration,
                catConfiguration
            ])

        let appTarget = Target(
            name: name,
            platform: platform,
            product: product,
            bundleId: "\(organizationName).\(name)",
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
//            entitlements: .relativeToRoot(entitlements ?? ""),
            dependencies: dependencies + additionalTargets.map { .target(name: $0) }
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "\(organizationName).\(name)Tests",
            deploymentTarget: deploymentTarget,
            infoPlist: .default,
            sources: ["Tests/**"],
//            entitlements: .relativeToRoot(entitlements ?? ""),
            dependencies: [.target(name: name)]
        )
        
        let dogTarget = Target(
            name: "TodoApp-Dog",
            platform: platform,
            product: product,
            bundleId: "\(organizationName).\(name)-Dog",
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            dependencies: dependencies + additionalTargets.map { .target(name: $0) },
            settings: .settings(
                configurations: [
                    dogConfiguration
                ]
            )
        )
        
        let catTarget = Target(
            name: "TodoApp-Cat",
            platform: platform,
            product: product,
            bundleId: "\(organizationName).\(name)-Cat",
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            dependencies: dependencies + additionalTargets.map { .target(name: $0) },
            settings: .settings(configurations: [
                catConfiguration
            ])
        )

        let targets: [Target] = [appTarget, testTarget, dogTarget, catTarget] + additionalTargets.flatMap { makeFrameworkTargets(name: $0, platform: platform) }
        
        let schemes: [Scheme] = [
            Scheme.makeScheme(target: "Dog", name: "TodoApp-Dog"),
            Scheme.makeScheme(target: "Cat", name: "TodoApp-Cat")
        ]

        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes
        )
    }
    
    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
        let sources = Target(name: name,
                platform: platform,
                product: .framework,
                bundleId: "co.godo.\(name)",
                infoPlist: .default,
                sources: ["\(name)/Sources/**"],
                resources: [],
                dependencies: [])
        let tests = Target(name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: "co.godo.\(name)Tests",
                infoPlist: .default,
                sources: ["\(name)/Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        return [sources, tests]
    }
}

extension Scheme {
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
        return Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
//            testAction: .targets(
//                ["\(name)Tests"],
//                configuration: target,
//                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
//            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}
