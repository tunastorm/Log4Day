//
//  Log4DayApp.swift
//  Log4Day
//
//  Created by 유철원 on 9/10/24.
//

import SwiftUI
import UIKit
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        //원격 알림 등록
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
}


extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        // 현재 등록 토큰 가져오기
        Messaging.messaging().token { token, error in
          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
          }
        }
        
        // 토큰 갱신 모니터링
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
         NotificationCenter.default.post(
           name: Notification.Name("FCMToken"),
           object: nil,
           userInfo: dataDict
         )
        
    }
    
}


@main
struct Log4DayApp: App {

    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
