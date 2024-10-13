//
//  NotificationManager.swift
//  Log4Day
//
//  Created by 유철원 on 10/13/24.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager() // Singleton
    
    /// 제일 처음에 알림 설정을 하기 위한 함수 -> 앱이 열릴 때나 button 클릭시에 함수 호출 되도록!
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { suceess, error in
            if let error {
//                print("ERROR: \(error)")
            } else {
//                print("SUCCESS")
            }
        }
    }

}
