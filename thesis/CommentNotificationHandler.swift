//
//  CommentNotificationHandler.swift
//  thesis
//
//  Created by Constantine Shterev on 31.03.24.
//

import FirebaseDatabase
import UserNotifications
import FirebaseDatabase


class CommentNotificationHandler {
    private let commentsRootRef: DatabaseReference
    private let currentUserId: String
    private var observationStartTimeStamp: TimeInterval

    init(currentUserId: String) {
        self.currentUserId = currentUserId
        self.commentsRootRef = Database.database().reference().child("apartments")
        self.observationStartTimeStamp = Date().timeIntervalSince1970
    }

    func startObservingComments() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification Authorization Status:", settings.authorizationStatus.rawValue)
        }

        commentsRootRef.observe(.childAdded, with: { [weak self] apartmentSnapshot in
            guard let apartmentData = apartmentSnapshot.value as? [String: Any],
                  let landlordId = apartmentData["landlordID"] as? String,
                  landlordId == self?.currentUserId else { return }

            let apartmentCommentsRef = apartmentSnapshot.ref.child("comments")

            apartmentCommentsRef.observe(.childAdded) { commentSnapshot in
                guard let commentData = commentSnapshot.value as? [String: Any],
                      let username = commentData["username"] as? String,
                      let text = commentData["text"] as? String,
                      let commentTimestamp = commentData["timestamp"] as? TimeInterval else {
                    print("Error extracting comment data")
                    return
                }

                if commentTimestamp > self!.observationStartTimeStamp * 1000{ // Filter based on timestamp
                    print("New comment detected: Username:", username, "Text:", text)
                    self?.showLocalNotification(title: "New Comment from \(username)", body: text)
                }

            }
        })
    }

    private func showLocalNotification(title: String, body: String) {
        print("showLocalNotification called")  // Check if this function is reached
        // Request Authorization
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.") // Add this
                self.sendLocalNotification(title: title, body: body)
            } else {
                print("Notification permission denied.")
            }
        }
    }

    private func sendLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let identifier = UUID().uuidString
        print("Notification Title:", content.title, "Body:", content.body) // Add this line
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully") // Add this
            }
        }
    }
}
