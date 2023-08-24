//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by hong on 2023/08/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "NetworkProvider",
    platform: .iOS,
    product: .staticLibrary,
    organizationName: "co.godo",
    resources: ["Sources/**"]
)
