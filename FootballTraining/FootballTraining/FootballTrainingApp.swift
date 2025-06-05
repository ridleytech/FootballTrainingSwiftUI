//
//  FootballTrainingApp.swift
//  FootballTraining
//
//  Created by Randall Ridley on 4/26/25.
//

import AVFoundation
// import Firebase
// import FirebaseMessaging
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

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate
//    MessagingDelegate, UNUserNotificationCenterDelegate
{
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        print("AppDelegate didFinishLaunchingWithOptions")
//        FirebaseApp.configure()
//
//        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        requestPushNotificationPermission(application: application)

        return true
    }

    private func requestPushNotificationPermission(application: UIApplication) {
//        UNUserNotificationCenter.current().delegate = UNUserNotificationCenterDelegateProxy.shared

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("🚫 Notification permission error: \(error)")
                return
            }

            print("✅ Notification permission granted: \(granted)")

            if granted {
                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
                    application.registerForRemoteNotifications()
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

//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        //        print("FCM token: \(fcmToken ?? "nil")")
//
//        print("Firebase registration token: \(String(describing: fcmToken))")
//        guard let fcmToken = fcmToken else { return }
//        UserDefaults.standard.set(fcmToken, forKey: "fcm_token")
//        print("FCM Token saved to UserDefaults: \(fcmToken)")
//    }

//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase registration token: \(String(describing: fcmToken))")
//
//        Messaging.messaging().token { token, error in
//            if let error = error {
//                print("Error fetching FCM registration token: \(error)")
//            } else if let token = token {
//                print("FCM registration token: \(token)")
    ////                self.fcmRegTokenMessage.text = "Remote FCM registration token: \(token)"
//            }
//        }
//    }
}

@main
struct FootballTrainingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

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

//        requestPushNotificationPermission()
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            MaxIntensityRecord.self,
            PhaseRecord.self,
            TrainingKPI.self,
            WeightRecord.self
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
