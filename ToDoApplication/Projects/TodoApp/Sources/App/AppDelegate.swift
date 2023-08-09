//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by hong on 2023/07/31.
//

import UIKit
import UserNotifications
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        //        listStoryboardFiles()
        
        FirebaseApp.configure()
        let apnService = APNService()
        apnService.registerForPushNotifications()
//                Messaging.messaging().delegate = self
//                UNUserNotificationCenter.current().delegate = self
//        registerForPushNotifications()
        return true
    }
    
    
    func listStoryboardFiles() {
        // 현재 번들의 메인 번들을 가져옵니다.
        let mainBundle = Bundle.main
        // 스토리보드 파일들의 경로를 가져옵니다.
        if let storyboardURLs = mainBundle.urls(forResourcesWithExtension: "storyboardc", subdirectory: nil) {
            // 각 스토리보드 파일들의 이름을 출력합니다.
            for url in storyboardURLs {
                print(url)
            }
        }
    }
    
}

