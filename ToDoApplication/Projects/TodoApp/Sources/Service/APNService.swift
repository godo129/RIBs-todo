//
//  APNService.swift
//  ToDoApp
//
//  Created by hong on 2023/08/04.
//

import UIKit
import UserNotifications
import FirebaseMessaging
import FirebaseCore

final class APNService: NSObject {
    
    private let messaging = Messaging.messaging()
    private let dispatchQueue = DispatchQueue(label: "APNService", qos: .background)
    
    override init() {
        super.init()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }
    
    private var fcmToken: String? = nil
    
    /// 노티 보내기
    func sendNotification() {
        
    }
    
    func subscribeNotification(topic name: String) {
        dispatchQueue.async { [weak self] in
            guard let self,
                  let fcmToken = self.fcmToken else {return}
            Messaging.messaging().subscribe(toTopic: name) { error in
                if let error {
                    print("fcm 구독 오류 : ", error)
                } else {
                    print("fcm 구독 성공 : ", name)
                }
            }
        }
 
    }
    
    func unsubscribeNotification(topic name: String) {
        dispatchQueue.async { [weak self] in
            guard let self,
                  let fcmToken = self.fcmToken else {return}
            self.messaging.unsubscribe(fromTopic: fcmToken) { error in
                if let error {
                    print("fcm 구독 해지 오류 : ", error)
                } else {
                    print("fcm 구독 해지 성공 : ", name)
                }
                
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
 
}

extension APNService: UNUserNotificationCenterDelegate {

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
    
    // 포그라운드에서 나올 때 보이는 것
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner])
    }
}

extension APNService: MessagingDelegate {
    // fcmToken 값 받음
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else {return}
        self.fcmToken = fcmToken
        print("FCM Token: \(fcmToken)")
//        subscribeNotification(topic: <#T##String#>)
    }
}

private extension UNUserNotificationCenter {
    func requestAuthorization() async -> Bool {
        do {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            return try await requestAuthorization(options: authOptions)
        } catch {
            print(error)
            return false
        }
    }
}
