//
//  ShareViewController.swift
//  NewReminderFromSharedText
//
//  Created by Oleg Koptev on 26.02.2021.
//

import UIKit
import Social
import MobileCoreServices

/*
 var sharedText: String = ""
 private func handleInputData() {
     let attachments = (extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
     let contentType = kUTTypeData as String
     for provider in attachments {
         if provider.hasItemConformingToTypeIdentifier(contentType) {
             provider.loadItem(forTypeIdentifier: contentType, options: nil) { (data, error) in
                 guard error == nil else { return }
                 if let text = data as? String {
                     self.sharedText = text
                 } else {
                     print("Impossible to extract text")
                 }
             }
         }
     }
 }
 */

/*
 let sharedDefault = UserDefaults(suiteName: "group.com.koptev.ToDoApp")!
 Write Data:
   sharedDefault.set("mySharableData", forKey: "keyForMySharableData")
 Read Data:
   let mySharableData = sharedDefault.object(forKey: "keyForMySharableData")
 */

class ShareViewController: SLComposeServiceViewController {
    let sharedDefault = UserDefaults(suiteName: "group.com.koptev.ToDoApp")!
    var sharedText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let attachments = (extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let contentType = kUTTypeData as String
        for provider in attachments {
            if provider.hasItemConformingToTypeIdentifier(contentType) {
                provider.loadItem(forTypeIdentifier: contentType, options: nil) { (data, error) in
                    guard error == nil else { return }
                    if let text = data as? String {
                        self.sharedText = text
                    } else {
                        print("Impossible to extract text")
                    }
                }
            }
        }
    }
    
    override func isContentValid() -> Bool {
        return true
    }
    
    override func didSelectPost() {
        // Post data to userDefaults
        let remindersPendingList = sharedDefault.object(forKey: "remindersFromShareSheet") as? [String]
        if var list = remindersPendingList, let text = sharedText {
            list.append(text)
            sharedDefault.set(list, forKey: "remindersFromShareSheet")
        }
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        return []
    }
}
