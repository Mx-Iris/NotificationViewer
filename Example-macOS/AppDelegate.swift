//
//  AppDelegate.swift
//  Example-macOS
//
//  Created by JH on 11/2/24.
//

import Cocoa
import FishHook

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {}

    func applicationWillTerminate(_ aNotification: Notification) {}

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
