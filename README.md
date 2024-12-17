# **feat_apns**

A **Swift Package** for managing APNs (Apple Push Notification Service) and handling push notifications on iOS.

---

## **Overview**

`feat_apns` is a lightweight Swift package that provides:
- APNs token registration and management.
- Push notification permission handling.
- Foreground and background push notification event handling.

This module is compatible with **iOS 16 and above** and designed for seamless integration via **Swift Package Manager (SPM)**.

---

## **Features**

- ✅ **APNs Token Management**: Automatically register, receive, and cache APNs device tokens.
- ✅ **Notification Handling**: Handle push notifications in both foreground and background states.
- ✅ **Permission Management**: Request and check notification permissions dynamically.
- ✅ **Modular Integration**: Easily integrate and extend push notification functionality.

---

## **Requirements**

| Requirement     | Minimum Version         |
|------------------|-------------------------|
| **iOS**         | 16.0                    |
| **Swift**       | 5.7                     |
| **Xcode**       | 14.0                    |

---

## **Installation**

### **Swift Package Manager (SPM)**

1. Open your project in **Xcode**.
2. Navigate to **File > Add Packages...**.
3. Enter the repository URL:  
   `https://github.com/netcanis/feat_apns.git`
4. Select the version and integrate the package into your project.

---

## **Usage**

### **1. Configure APNs Manager**

To set up and initialize APNs:

```swift
import feat_apns

// Configure APNs manager
HiAPNsManager.shared.configure()

// Token Received Callback
HiAPNsManager.shared.onTokenReceived = { token in
    print("Received APNs Token: \(token)")
}

// Push Notification Received Callback
HiAPNsManager.shared.onPushReceived = { notification in
    print("Push Notification Received: \(notification.request.content.userInfo)")
}
```

### **2. Handle APNs Token Registration**

Add the following in your AppDelegate to register for push notifications:

```swift
import UIKit
import feat_apns

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        HiAPNsManager.shared.setAPNsToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for APNs: \(error)")
    }
}
```

### **3. Request Notification Permissions**

You can request notification permissions at runtime:

```swift
HiAPNsManager.shared.requestNotificationAuthorization()
```

---

## **Permissions**

Add the following key to your Info.plist file to request camera permission:

```
<key>NSUserNotificationUsageDescription</key>
<string>We use notifications to keep you updated with important information.</string>
```

---

## **Example UI**

Here’s how to use HiAPNsManager to handle push notifications in a typical application:

```swift
import feat_apns
import SwiftUI

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        // Configure APNs
        HiAPNsManager.shared.configure()
        
        // Handle APNs token reception
        HiAPNsManager.shared.onTokenReceived = { token in
            print("Received APNs Token: \(token)")
        }

        // Handle push notification events
        HiAPNsManager.shared.onPushReceived = { notification in
            print("Received Push Notification: \(notification.request.content.userInfo)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                }
        }
    }
}

// AppDelegate.swift
import UIKit
import feat_apns

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        HiAPNsManager.shared.setAPNsToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for APNs: \(error)")
    }
}
```

---

## **License**

feat_qr is available under the MIT License. See the LICENSE file for details.

---

## **Contributing**

Contributions are welcome! To contribute:

1. Fork this repository.
2. Create a feature branch:
```
git checkout -b feature/your-feature
```
3. Commit your changes:
```
git commit -m "Add feature: description"
```
4. Push to the branch:
```
git push origin feature/your-feature
```
5. Submit a Pull Request.

---

## **Author**

### **netcanis**
GitHub: https://github.com/netcanis

---
