//
//  String+Ex.swift
//  XcodeTools
//
//  Created by 张江 on 2025/5/30.
//
import Foundation

public extension String {
    func path() -> String {
        //MARK: url路径处理( 中文路径转换问题处理 )
        if let fileURL = URL(string: self), let path = fileURL.path.removingPercentEncoding {
            return path
        }else{
            return self
        }
    }
}
