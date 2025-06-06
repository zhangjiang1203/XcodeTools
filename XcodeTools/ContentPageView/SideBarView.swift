//
//  SideBarView.swift
//  XcodeTools
//
//  Created by 张江 on 2024/3/1.
//

import Foundation
import SwiftUI

enum TabbarType: CaseIterable {
    case setting
    
    var normalIcon: String {
        switch self {
        case .setting:
            return ""
        }
    }
    
    var selectIcon: String {
        switch self {
        case .setting:
            return ""
        }
    }
}


struct SideBarView: View {
    
    @Binding var selectTab: TabbarType
    
    var body: some View {
        VStack {
            createTabButton()
        }
        .padding(6)
        .padding(.vertical)
    }
    
    @ViewBuilder
    private func createTabButton() -> some View {
        ForEach(TabbarType.allCases, id: \.self) { tab in
            Button {
                withAnimation(.easeInOut) {
                    selectTab = tab
                }
            } label: {
                Image(selectTab == tab ? tab.selectIcon : tab.normalIcon)
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
            }
            .buttonStyle(.plain)
            .background(selectTab == tab ? Color(hex: "#efefef") : Color(hex: "#efefef",opacity: 0.2) )
            .clipShape(Circle())
            .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
        }
    }
}
