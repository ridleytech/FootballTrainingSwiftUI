//
//  NotificationService.swift
//  NotificationService
//
//  Created by Randall Ridley on 5/15/25.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        print("NotificationService didReceive")

        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent else {
            return
        }

        if let mediaUrlString = request.content.userInfo["media-url"] as? String,
           let mediaUrl = URL(string: mediaUrlString)
        {
            downloadImage(from: mediaUrl) { attachment in
                if let attachment = attachment {
                    bestAttemptContent.attachments = [attachment]
                }
                contentHandler(bestAttemptContent)
            }
        } else {
            contentHandler(bestAttemptContent)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension is terminated.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    private func downloadImage(from url: URL, completion: @escaping (UNNotificationAttachment?) -> Void) {
        print("NotificationService downloadImage")
        let task = URLSession.shared.downloadTask(with: url) { downloadedUrl, _, _ in
            guard let downloadedUrl = downloadedUrl else {
                completion(nil)
                return
            }

            let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
            let uniqueURL = tempDirectory.appendingPathComponent(UUID().uuidString + ".jpg")

            try? FileManager.default.moveItem(at: downloadedUrl, to: uniqueURL)

            let attachment = try? UNNotificationAttachment(identifier: "image", url: uniqueURL, options: nil)
            completion(attachment)
        }
        task.resume()
    }
}
