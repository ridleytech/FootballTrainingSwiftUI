//
//  FootballTrainingApp.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import AVFoundation
import SwiftData
import SwiftUI
import UserNotifications

struct ModelContextView<Content: View>: View {
    @Environment(\.modelContext) private var modelContext
    let content: (ModelContext) -> Content

    var body: some View {
        content(modelContext)
    }
}

@main
struct FootballTrainingApp: App {
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .ambient, // or .playback if you need background audio
                mode: .default,
                options: [.mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session:", error)
        }

        requestPushNotificationPermission()
    }

    private func requestPushNotificationPermission() {
        UNUserNotificationCenter.current().delegate = UNUserNotificationCenterDelegateProxy.shared

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("🚫 Notification permission error: \(error)")
                return
            }

            print("✅ Notification permission granted: \(granted)")

            if granted {
//                print("try to register")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        let tokenParts = deviceToken.map { String(format: "%02.2hhx", $0) }
        let token = tokenParts.joined()
        print("📱 Device Token: \(token)")
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("❌ Failed to register: \(error)")
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            MaxIntensityRecord.self,
            PhaseRecord.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var navigationManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            ModelContextView { modelContext in
                let phaseManager = PhaseManager(modelContext: modelContext)

                return ContentView()
                    .environmentObject(navigationManager)
                    .environmentObject(phaseManager)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

// Optional: Shared delegate to handle foreground display
class UNUserNotificationCenterDelegateProxy: NSObject, UNUserNotificationCenterDelegate {
    static let shared = UNUserNotificationCenterDelegateProxy()

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print("UNUserNotificationCenterDelegateProxy userNotificationCenter")

        completionHandler([.banner, .sound, .badge])
    }
}
