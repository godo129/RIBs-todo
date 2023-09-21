//
//  ProfileViewViewController.swift
//  ToDoApp
//
//  Created by hong on 2023/09/21.
//  Copyright © 2023 co.godo. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SwiftUI
import NeedleKit

protocol ProfileViewPresentableListener: AnyObject {
    
}

final class ProfileViewViewController: UIHostingController<ProfileView>, ProfileViewPresentable, ProfileViewViewControllable {

    weak var listener: ProfileViewPresentableListener?
    
    init(imageRepository: ImageRepositoryProtocol) {
        let profileView = ProfileView(imageRepository: imageRepository)
        super.init(rootView: profileView)
        title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "menubar.rectangle"), style: .plain, target: self, action: #selector(profileNavigationRightButtonTapped))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func profileNavigationRightButtonTapped() {
    }

}
