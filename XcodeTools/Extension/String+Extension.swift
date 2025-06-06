//
//  String+Extension.swift
//  XcodeTools
//
//  Created by 张江 on 2025/6/4.
//

import Foundation

#if os(macOS)
import AppKit
public typealias PlatformFont = NSFont
#else
import UIKit
public typealias PlatformFont = UIFont
#endif

// 字符串截取用法
//let showName = "我就是我不一样的烟火，你就是来了我也是烟火"
//print(showName[...8])
//print(showName[..<8])
//print(showName[10...])
//print(showName[1...4])
//print(showName[1..<4])
//print(showName[...30])
//print(showName[-20...4])

public extension String {
    subscript (i: Int) -> Character {
        if i > self.count {
            return Character("")
        }
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        var lower = bounds.lowerBound
        if lower < 0 {
            lower = 0
        }
        
        var upper = bounds.upperBound
        if upper > self.count {
            upper = self.count
        }
        
        let start = index(startIndex, offsetBy: lower)
        let end = index(startIndex, offsetBy: upper)
        if end < start { return "" }
        return String(self[start..<end])
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        var lower = bounds.lowerBound
        if lower < 0 {
            lower = 0
        }
        
        var upper = bounds.upperBound
        if upper >= self.count {
            upper = self.count - 1
        }
        
        let start = index(startIndex, offsetBy: lower)
        let end = index(startIndex, offsetBy: upper)
        if end < start { return "" }
        return String(self[start...end])
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        var lower = bounds.lowerBound
        if lower < 0 {
            lower = 0
        }
        
        let start = index(startIndex, offsetBy: lower)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return String(self[start...end])
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> String {
        var upper = bounds.upperBound
        if upper >= self.count {
            upper = self.count - 1
        }
        let end = index(startIndex, offsetBy: upper)
        if end < startIndex { return "" }
        return String(self[startIndex...end])
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> String {
        var upper = bounds.upperBound
        if upper >= self.count {
            upper = self.count - 1
        }
        let end = index(startIndex, offsetBy: upper)
        if end < startIndex { return "" }
        return String(self[startIndex..<end])
    }
    
    // MARK: 去除空格和换行
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


// MARK:- 1、沙盒路径的获取
/*
  - 1、Home(应用程序包)目录
  - 整个应用程序各文档所在的目录,包含了所有的资源文件和可执行文件
  - 2、Documents
  - 保存应用运行时生成的需要持久化的数据，iTunes同步设备时会备份该目录
  - 需要保存由"应用程序本身"产生的文件或者数据，例如: 游戏进度，涂鸦软件的绘图
  - 目录中的文件会被自动保存在 iCloud
  - 注意: 不要保存从网络上下载的文件，否则会无法上架!
  - 3、Library
  - 3.1、Library/Cache
  -  保存应用运行时生成的需要持久化的数据，iTunes同步设备时不备份该目录。一般存放体积大、不需要备份的非重要数据
  - 保存临时文件,"后续需要使用"，例如: 缓存的图片，离线数据（地图数据）
  - 系统不会清理 cache 目录中的文件
  - 就要求程序开发时, "必须提供 cache 目录的清理解决方案"
  - 3.2、Library/Preference
  - 保存应用的所有偏好设置，IOS的Settings应用会在该目录中查找应用的设置信息。iTunes
  - 用户偏好，使用 NSUserDefault 直接读写！
  - 如果想要数据及时写入硬盘，还需要调用一个同步方法
  - 4、tmp
  - 保存临时文件，"后续不需要使用"
  - tmp 目录中的文件，系统会自动被清空
  - 重新启动手机, tmp 目录会被清空
  - 系统磁盘空间不足时，系统也会自动清理
  - 保存应用运行时所需要的临时数据，使用完毕后再将相应的文件从该目录删除。应用没有运行，系统也可能会清除该目录下的文件，iTunes不会同步备份该目录
  */
public extension String {
    // MARK: 1.1、获取Home的完整路径名
    static func homeDirectory() -> String {
        //获取程序的Home目录
        let homeDirectory = NSHomeDirectory()
        return homeDirectory
    }
    
    // MARK: 1.2、获取Documnets的完整路径名
    static func documnetsDirectory() -> String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documnetPath = documentPaths[0]

        return documnetPath
    }

    // MARK: 1.3、获取Library的完整路径名
    /**
     这个目录下有两个子目录：Caches 和 Preferences
 Library/Preferences目录，包含应用程序的偏好设置文件。不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好。
     Library/Caches目录，主要存放缓存文件，iTunes不会备份此目录，此目录下文件不会再应用退出时删除
     */
    /// 获取Library的完整路径名
    /// - Returns: Library的完整路径名
    static func libraryDirectory() -> String {
        //获取程序的documentPaths目录
        
        let libraryPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let libraryPath = libraryPaths[0]

        return libraryPath
    }

    // MARK: 1.4、获取/Library/Caches的完整路径名
    /// 获取/Library/Caches的完整路径名
    /// - Returns: /Library/Caches的完整路径名
    static func cachesDirectory() -> String {
        //获取程序的/Library/Caches目录
        let cachesPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let cachesPath = cachesPaths[0]
        return cachesPath
    }
    
    // MARK: 1.5、获取Library/Preferences的完整路径名
    static func preferencesDirectory() -> String {
        let preferencesPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.preferencePanesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let preferencesPath = preferencesPaths[0]

        return preferencesPath
    }
    
    // MARK: 1.6、获取Library/Preferences的完整路径名
    static func supportDirectory() -> String {
        let supportPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let supportPath = supportPaths[0]

        return supportPath
    }
    
    // MARK: 1.7、获取Tmp的完整路径名
    /// 获取Tmp的完整路径名，用于存放临时文件，保存应用程序再次启动过程中不需要的信息，重启后清空。
    static func tmpDirectory() -> String {
        let tmpDir = NSTemporaryDirectory()
        return tmpDir
    }
}


//MARK: 字符串 宽高
public extension String {
    func height(maxWidth: CGFloat, font: PlatformFont) -> CGFloat {
        let constraintSize = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(maxHeight: CGFloat, font: PlatformFont) -> CGFloat {
        let constraintSize = CGSize(width: .greatestFiniteMagnitude, height: maxHeight)
        let boundingBox = self.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

public extension String {
    func toDouble() -> Double {
        Double(self) ?? 0
    }
}

public extension String {
    func path() -> String {
        //MARK: url路径处理( 中文路径转换问题处理 )
        if let fileURL = URL(string: self), let path = fileURL.path.removingPercentEncoding {
            return path
        }else{
            return self
        }
    }
    
    func urlEncode(isAddSuf: Bool = true) -> String {
        var temStr = self
        if temStr.hasPrefix("/") {
            temStr = temStr[1...]
        }
        if isAddSuf && !temStr.hasSuffix("/") {
            temStr.append("/")
        }
        var customAllowSet = CharacterSet.urlPathAllowed
        customAllowSet.remove(charactersIn: "/")
        if let encodePath = temStr.addingPercentEncoding(withAllowedCharacters: customAllowSet) {
            return encodePath
        }
        return self
    }
}
