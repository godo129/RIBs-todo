//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by hong on 2023/08/09.
//
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "ThirdPartyLib",
    platform: .iOS,
    product: .framework,
    organizationName: "co.godo",
    packages: [
        .Firebase
    ],
    dependencies: [
        .SPM.FirebaseMessaging,
        .SPM.FirebaseAnalytics,
        .SPM.FirebaseCrashlytics
    ],
    resources: ["Sources/**"]
)
