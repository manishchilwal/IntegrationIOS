import UIKit
import CleverTapSDK
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CleverTapInAppNotificationDelegate, CleverTapURLDelegate, UNUserNotificationCenterDelegate {

    var pendingDeeplinkURL: URL?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CleverTap.autoIntegrate()
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)

        // Delegates
        CleverTap.sharedInstance()?.setUrlDelegate(self)
        CleverTap.sharedInstance()?.setInAppNotificationDelegate(self)

        registerForPush()
        return true
    }

    func registerForPush() {
        let actions = [
            UNNotificationAction(identifier: "action_1", title: "Back", options: []),
            UNNotificationAction(identifier: "action_2", title: "Next", options: []),
            UNNotificationAction(identifier: "action_3", title: "View In App", options: [])
        ]
        let category = UNNotificationCategory(identifier: "CTNotification", actions: actions, intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("Push permission error: \(error.localizedDescription)")
            }
        }
    }

    func shouldHandleCleverTap(_ url: URL?, for channel: CleverTapChannel) -> Bool {
        guard let url = url else { return false }
        print("[CT] shouldHandleCleverTap triggered with URL: \(url) on channel: \(channel)")

        // Storeing URL for later use after in-app is dismissed
        pendingDeeplinkURL = url
        return true
    }

    func inAppNotificationButtonTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
        print("[CT] In-App Button tapped with custom extras: \(customExtras ?? [:])")
    }
    

    // Replacement for deprecated keyWindow property
    public var imvuKeyWindow: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })
        let keyWindow = windowScene?.windows.first(where: { $0.isKeyWindow })
        return keyWindow
    }

    func inAppNotificationDismissed(withExtras extras: [AnyHashable: Any]!, andActionExtras actionExtras: [AnyHashable: Any]!) {
        print("[CT] dismissed called", pendingDeeplinkURL ?? "no pending url", extras ?? "no extras", actionExtras ?? "no action extras")

        func getTopViewController(from rootVC: UIViewController?) -> UIViewController? {
            if let nav = rootVC as? UINavigationController {
                return getTopViewController(from: nav.topViewController)
            } else if let tab = rootVC as? UITabBarController {
                return getTopViewController(from: tab.selectedViewController)
            } else if let presented = rootVC?.presentedViewController {
                return getTopViewController(from: presented)
            } else {
                return rootVC
            }
        }

        DispatchQueue.main.async {
            if let initialTopVC = getTopViewController(from: self.imvuKeyWindow?.rootViewController) {
                print("[CT] Top View Controller (initial): \(type(of: initialTopVC))")
            } else {
                print("[CT] Top View Controller (initial): not found")
            }

            // Delay for 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                if let delayedTopVC = getTopViewController(from: self.imvuKeyWindow?.rootViewController) {
                    print("[CT] Top View Controller (after 5s): \(type(of: delayedTopVC))")
                } else {
                    print("[CT] Top View Controller (after 5s): not found")
                }

                if let pendingurl = self.pendingDeeplinkURL {
                    print("[CT] pending URL after delay:", pendingurl)
                }
            }
        }
    }






    // MARK: - Push Notification Delegates
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NSLog("Registered for remote notifications: %@", deviceToken.description)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("Failed to register for remote notifications: %@", error.localizedDescription)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NSLog("Foreground notification: %@", notification.request.content.userInfo)
        CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: notification.request.content.userInfo)
        completionHandler([.badge, .sound, .alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NSLog("Notification tapped: %@", response.notification.request.content.userInfo)
        CleverTap.sharedInstance()?.handleNotification(withData: response.notification.request.content.userInfo)
        completionHandler()
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSLog("Remote notification received (background): %@", userInfo)
        completionHandler(.noData)
    }

    // MARK: - Universal Links / Deep Links
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "mytestapplication" {
            NSLog("Handled custom URL scheme: \(url)")
            return true
        }
        NSLog("Unrecognized URL scheme: \(url)")
        return false
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            navigateToScreen(for: url)
            return true
        }
        return false
    }

    func navigateToScreen(for url: URL) {
        NSLog("Navigating to screen for URL: \(url)")
        // Implement your screen logic here based on the URL
    }

    func pushNotificationTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
        print("Push Notification Tapped with Custom Extras: \(customExtras ?? [:])")
    }
}
