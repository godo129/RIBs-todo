//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by hong on 2023/08/31.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "NiddleKit",
    platform: .iOS,
    product: .staticLibrary,
    organizationName: "co.godo",
    resources: ["Sources/**"]
)
