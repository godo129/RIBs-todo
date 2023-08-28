//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by hong on 2023/08/28.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "And",
    platform: .iOS,
    product: .staticLibrary,
    organizationName: "co.godo",
    resources: ["Sources/**"]
)
