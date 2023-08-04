//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by hong on 2023/07/31.
//

import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging

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
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                print("Permission granted: \(granted)")
                guard granted else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
//            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
//            }
        }
        
    }
    
    func subscribeNotification()  {
        //        dispatchQueue.async { [weak self] in
        //            guard let self,
        Messaging.messaging().subscribe(toTopic: "eLTZI6fngkrojXU_anGHM2:APA91bGfu5itSGjDmV9d1pTWOOH4UtXic_Ra5CCbtPZNpXKNR0o9Cnm3V2WQMYaQb0dHrfDttXyZT1sfvTqKDRu8uPMj8eiSesuvnG2TkF7m0EC4QSagp1KoTXqnvWecPwum_M_Z_59N") { error in
            if let error {
                print("구독 오류", error)
            } else {
                print("구독 성공")
            }
        }
        //        }
    }
}



extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 노티 등록 성공
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    // 노티 등록 실패
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner])
    }
}

extension AppDelegate: MessagingDelegate {
    // fcmToken 값 받음
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else {return}
//        self.fcmToken = fcmToken
        print("FCM Token: \(fcmToken)")
             subscribeNotification()
    }

}
