//
//  Navigator.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/28.
//

import Foundation

protocol Navigator {
    func navigate()
    
    var title: String { get }
}
