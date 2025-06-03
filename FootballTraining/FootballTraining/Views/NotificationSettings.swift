//
//  NotificationSettings.swift
//  FootballTraining
//
//  Created by Randall Ridley on 6/2/25.
//

import SwiftUI

struct NotificationSettings: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false

    var body: some View {
        VStack(spacing: 20) {
            Toggle("Enable Daily Notifications", isOn: $notificationsEnabled)
                .padding()
                .onChange(of: notificationsEnabled) { isEnabled in
                    if isEnabled {
                        NotificationManager.shared.requestPermission {
                            NotificationManager.shared.scheduleDailyNotifications()
                        }
                    } else {
                        NotificationManager.shared.cancelScheduledNotifications()
                    }
                }

            Text(notificationsEnabled ? "Notifications are ON" : "Notifications are OFF")
                .foregroundColor(notificationsEnabled ? .green : .red)
        }
    }
}

#Preview {
    NotificationSettings()
}
