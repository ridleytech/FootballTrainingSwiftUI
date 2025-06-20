//
//  NotificationSettings.swift
//  FootballTraining
//
//  Created by Randall Ridley on 6/2/25.
//

import SwiftUI

struct NotificationSettings: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack {
            ZStack {
                Text("Settings")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(AppConfig.greenColor)
            }

            Spacer().frame(height: 50)

            Button(action: {
                navigationManager.path.append(Route.kpi)

            }) {
                Text("Training KPIs")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color(hex: "7FBF30"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .padding([.leading, .trailing], 16)

            Spacer()

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

            Spacer().frame(height: 50)
        }
    }
}

#Preview {
    NotificationSettings()
}
