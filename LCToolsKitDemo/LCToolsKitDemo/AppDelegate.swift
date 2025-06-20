//
//  AppDelegate.swift
//  LCToolsKitDemo
//
//  Created by DevLiuSir on 2019/3/2.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let a = LCAppEnvironmentDetector.shared.currentEnvironment()
        
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

