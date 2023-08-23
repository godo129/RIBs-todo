//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by hong on 2023/08/09.
//

import ProjectDescription

public extension TargetDependency {
    enum SPM {}
}

public extension Package {
    
    static let Firebase = Package.remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "9.0.0"))
    
    static let Ribs = Package.remote(url: "https://github.com/uber/RIBs", requirement: .exact( "0.15.2"))
}

public extension TargetDependency.SPM {
    static let FirebaseMessaging = TargetDependency.package(product: "FirebaseMessaging")
    static let FirebaseAnalytics = TargetDependency.package(product: "FirebaseAnalytics")
    static let FirebaseCrashlytics = TargetDependency.package(product: "FirebaseCrashlytics")
    static let Ribs = TargetDependency.package(product: "RIBs")
}

