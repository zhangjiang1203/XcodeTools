//
//  ContentView.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/31.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        AppleScriptAction.showInFinder()
    }
    
    var body: some View {
        
        NavigationSplitView {
            SideBarView()
        } detail: {
            DetailContentPage()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
