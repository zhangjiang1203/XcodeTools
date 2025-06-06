//
//  ContentView.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/31.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectTab: TabbarType = .setting
    
    var body: some View {
        
        HStack{
            SideBarView(selectTab: $selectTab)
                .frame(width: 60)
            switch selectTab {
            case .setting:
                DetailContentPage()
                    .frame(minWidth: 700)
            }
        }
        .frame(minWidth: 900,minHeight: 700)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
