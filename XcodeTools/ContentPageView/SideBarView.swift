//
//  SideBarView.swift
//  XcodeTools
//
//  Created by 张江 on 2024/3/1.
//

import Foundation
import SwiftUI

struct SideBarView: View {
    
    var body: some View {
        List(0..<10, id: \.self){ _ in
            Text("数据展示类型")
            
        }
    }
}
