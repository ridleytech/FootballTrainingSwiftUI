//
//  NotificationManager.swift
//  FootballTraining
//
//  Created by Randall Ridley on 6/2/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private let notificationCenter = UNUserNotificationCenter.current()

    func requestPermission(completion: @escaping () -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    completion()
                }
            }
        }
    }

    func scheduleDailyNotifications() {
        cancelScheduledNotifications()

//        let calendar = Calendar.current
        let baseHour = 7
        let baseMinute = 30

        for i in 0..<5 {
            var dateComponents = DateComponents()
            let offsetHour = baseHour + (i * 3)
            dateComponents.hour = offsetHour
            dateComponents.minute = baseMinute

            let content = UNMutableNotificationContent()
            content.title = "Drink water"
            content.body = "This is glass \(i + 1) of 5 for today."
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(
                identifier: "daily_reminder_\(i)",
                content: content,
                trigger: trigger
            )

            notificationCenter.add(request) { error in
                if let error = error {
                    print("Error scheduling notification \(i + 1): \(error.localizedDescription)")
                }
            }
        }
    }

    func cancelScheduledNotifications() {
        let ids = (0..<5).map { "daily_reminder_\($0)" }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
    }
}
