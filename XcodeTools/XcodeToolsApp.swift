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
        //启动注册通知
        _ = AppleScriptManager.default
    }
    
    var body: some Scene {
        WindowGroup {
            
            HStack(alignment: .top) {
                ContentView()
            }
        }
    }
}
 
