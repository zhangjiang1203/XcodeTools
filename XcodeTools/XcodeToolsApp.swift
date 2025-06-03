//
//  XcodeToolsApp.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/31.
//

import SwiftUI

@main
struct XcodeToolsApp: App {
    
    init() {
        _ = AppleScriptManager.default
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
 
