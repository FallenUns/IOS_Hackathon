import Foundation
import UserNotifications

// This class manages all notification-related logic.
class NotificationManager {
    
    static let shared = NotificationManager()
    private init() {}
    
    /// Requests authorization from the user to send notifications.
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            // Call the completion handler on the main thread.
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    /// Schedules a daily repeating notification at a specific time chosen by the user.
    /// - Parameter time: The Date object containing the desired hour and minute for the reminder.
    func scheduleDailyReminder(at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Daily Check-in Reminder"
        content.body = "Just a gentle reminder to take a moment for yourself and check in today."
        content.sound = .default
        
        // Extract the hour and minute from the user's selected time.
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyCheckInReminder", content: content, trigger: trigger)
        
        // First, cancel any existing notifications to avoid duplicates.
        cancelNotifications()
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Daily reminder scheduled successfully for \(dateComponents.hour ?? 0):\(dateComponents.minute ?? 0).")
            }
        }
    }
    
    /// Cancels all scheduled notifications for the app.
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All pending notifications have been cancelled.")
    }
}
