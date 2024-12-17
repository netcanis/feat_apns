//
//  HiAPNsManager.swift
//  feat_apns
//
//  Created by netcanis on 11/21/24.
//

import Foundation
import UIKit
import UserNotifications

/// A manager class for handling Apple Push Notification Service (APNs)
public class HiAPNsManager: NSObject, @unchecked Sendable {
    /// Shared singleton instance of HiAPNsManager
    public static let shared = HiAPNsManager()

    /// Callback triggered when the APNs token is received
    public var onTokenReceived: ((String) -> Void)?

    /// Callback triggered when a push notification is received
    public var onPushReceived: ((UNNotification) -> Void)?

    /// Key used to cache the last APNs token in UserDefaults
    private let cachedAPNsTokenKey = "HiLastAPNsToken"

    /// Private initializer to enforce singleton usage
    private override init() {
        super.init()
    }

    /// Configures APNs by setting up the notification delegate and checking notification authorization status
    public func configure() {
        UNUserNotificationCenter.current().delegate = self
        checkNotificationAuthorization()
    }

    /// Checks the current notification authorization status
    public func checkNotificationAuthorization() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("Notification permissions are granted. Registering for remote notifications.")
                Task { @MainActor in
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .denied:
                print("Notification permissions are denied. Notifications must be enabled in Settings.")
            case .notDetermined:
                print("Notification permissions are not determined. Requesting permissions.")
                self.requestNotificationAuthorization()
            default:
                print("Unknown notification permission status.")
            }
        }
    }

    /// Requests notification authorization from the user
    public func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Failed to request notification permissions: \(error.localizedDescription)")
            } else if granted {
                print("Notification permissions granted.")
                Task { @MainActor in
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permissions were denied.")
            }
        }
    }

    /// Sets and caches the APNs device token
    /// - Parameter deviceToken: The device token received from APNs
    public func setAPNsToken(_ deviceToken: Data) {
        let apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs Device Token: \(apnsToken)")
        UserDefaults.standard.set(apnsToken, forKey: cachedAPNsTokenKey)
        onTokenReceived?(apnsToken)
    }

    /// Retrieves the cached APNs device token
    /// - Returns: The cached APNs token as a String
    public func getCachedAPNsToken() -> String {
        return UserDefaults.standard.string(forKey: cachedAPNsTokenKey) ?? ""
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension HiAPNsManager: UNUserNotificationCenterDelegate {
    /// Called when a push notification is received while the app is in the foreground
    /// - Parameters:
    ///   - center: Notification center
    ///   - notification: The received notification
    ///   - completionHandler: Completion handler with presentation options
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("Foreground Push Notification Received: \(userInfo)")
        onPushReceived?(notification) // Pass the push notification event to the app
        completionHandler([.banner, .sound, .badge]) // Display the notification as a banner with sound and badge
    }

    /// Called when the user interacts with (clicks) a push notification
    /// - Parameters:
    ///   - center: Notification center
    ///   - response: The user's response to the notification
    ///   - completionHandler: Completion handler to indicate processing is complete
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Push Notification Clicked: \(userInfo)")
        onPushReceived?(response.notification) // Handle push notification click events
        completionHandler()
    }
}
