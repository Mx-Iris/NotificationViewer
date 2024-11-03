//
//  AppDelegate.swift
//  Example-macOS
//
//  Created by JH on 11/2/24.
//

import Cocoa
import FishHook

//@_silgen_name("_CFXNotificationPost")
//func _CFXNotificationPost(_ nc: CFNotificationCenter, _ notification: NSNotification, _ deliverImmediately: Bool) -> Void
//public func hook_CFXNotificationPost(_ nc: CFNotificationCenter, _ notification: NSNotification, _ deliverImmediately: Bool) {
//    print("😃", "hook", nc, notification, deliverImmediately)
//    _CFXNotificationPost(nc, notification, deliverImmediately)
//}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        var toMachO: MachOImage?
//        let indices = 0..<_dyld_image_count()
//        let index = indices.first { index in
//            guard let pathC = _dyld_get_image_name(index) else {
//                return false
//            }
//            let path = String(cString: pathC)
//            let imageName = path
//                .components(separatedBy: "/")
//                .last
//            return imageName == "Example-macOS.debug.dylib"
//        }
//
//        if let index, let mh = _dyld_get_image_header(index) {
//            toMachO = MachOImage.init(ptr: mh)
//        }
//        guard let toMachO else {
//            return
//        }
//        guard let to = toMachO.symbol(
//            named: "_$s13Example_macOS24hook_CFXNotificationPostyySo23CFNotificationCenterRefa_So14NSNotificationCSbtF"
//        ) else {
//            return
//        }
//        guard let machO = MachOImage(name: "CoreFoundation") else {
//            return
//        }
//
//        let rebindings: [Rebinding] = [
//            .init(
//                name: "_CFXNotificationPost",
//                replacement: .init(mutating: toMachO.ptr.advanced(by: to.offset)),
//                replaced: nil
//            ),
//        ]
//
//        FishHook.rebind_symbols_image(
//            machO: machO,
//            rebindings: rebindings
//        )
//
//        NotificationCenter.default.post(name: .init("test"), object: nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
