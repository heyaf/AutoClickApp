//
//  Define.swift
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/1/12.
//

import UIKit
import Foundation
import SnapKit
import MBProgressHUD_JDragon
// MARK: ===================================工具类:变量宏定义=========================================
/// 屏幕宽
public let KScreenWidth = UIScreen.main.bounds.width
/// 屏幕高
public let KScreenHeight = UIScreen.main.bounds.height



// MARK: - 屏幕
/// 当前屏幕状态 高度
public let ScreenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
/// 当前屏幕状态 宽度
public let ScreenHeight = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)

/// 状态栏高度(信号栏高度),刘海屏 44、59等， 正常屏幕20
/// - Returns: 高
public func bmStatusBarHeight() ->CGFloat {
    if #available(iOS 13.0, *){
        return getWindow()?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }else{
        return UIApplication.shared.statusBarFrame.size.height
    }
}
public let StatusBarHeight: CGFloat = bmStatusBarHeight()

///获取当前设备window用于判断尺寸
//public func getWindow() -> UIWindow?{
//    if #available(iOS 13.0, *){
//        let winScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//        return winScene?.windows.first
//    }else{
//        return UIApplication.shared.keyWindow
//    }
//}

//获取当前的window
 public func getWindow() -> UIWindow? {
    
    if let window: UIWindow = (UIApplication.shared.delegate?.window)! {
        return window
    }

    if #available(iOS 13.0, *) {
        let arr: Set = UIApplication.shared.connectedScenes
        let windowScene: UIWindowScene = arr.first as! UIWindowScene
    //如果是普通APP开发，可以使用
    // SceneDelegate * delegate = (SceneDelegate *)windowScene.delegate;
       //UIWindow * mainWindow = delegate.window;
        
     if let mainWindow: UIWindow = windowScene.value(forKeyPath: "delegate.window") as? UIWindow {
            return mainWindow
        } else {
            return UIApplication.shared.windows.first!
        }
    } else {
        return UIApplication.shared.keyWindow!
        
    }
}

/// 导航栏高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化
/// - Returns: 高度  一般 44
public func bmNavBarHeight() ->CGFloat {
    return UINavigationController().navigationBar.frame.size.height
}
public let NavBarHeight: CGFloat = bmNavBarHeight()

/// 获取屏幕导航栏+信号栏总高度
public let NavBarAndStatusBarHeight = bmStatusBarHeight() + bmNavBarHeight()
/// 获取刘海屏底部home键高度,  34或0  普通屏为0
public let BottomHomeHeight = getWindow()?.safeAreaInsets.bottom ?? 0

/// TabBar高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化
/// - Returns: 高度   一般49
public func bmTabbarHeight() ->CGFloat {
    return UITabBarController().tabBar.frame.size.height
}

//刘海屏=TabBar高度+Home键高度, 普通屏幕为TabBar高度  83其他49
public let TabBarHeight = bmTabbarHeight() + BottomHomeHeight

/// iPhone 通用内容高度（总高度-kTopHeight-kBottomHeight）
public let kContentHeight: CGFloat = ScreenHeight - NavBarAndStatusBarHeight - TabBarHeight


/// 当前屏幕比例
public let Scare = UIScreen.main.scale
/// 画线宽度 不同分辨率都是一像素
public let LineHeight = CGFloat(Scare >= 1 ? 1/Scare: 1)


/// 屏幕适配-以屏幕宽度为缩放标准
public func FitWidth(_ value: CGFloat) -> CGFloat {
    return (value * (ScreenWidth / 375))
}
/// 屏幕适配-以屏幕高度为缩放标准  [Real 实际的 真实的]
public func FitHeight(_ value: CGFloat) -> CGFloat {
    return (value * (ScreenHeight / 375))
}


public func WindownSafeAreaInsets() -> UIEdgeInsets {
    if #available(iOS 11.0, *){
        return getWindow()?.safeAreaInsets ?? UIEdgeInsets.zero
    }
    else {
        return UIEdgeInsets.zero
    }
}

public func FIT(_ value: CGFloat) -> CGFloat {
    let width = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    let secal = width / 375.0
    return value * secal
}

extension Int {
    func vn() -> CGFloat {
        return FIT(CGFloat(self))
    }
}

extension CGFloat {
    func vn() -> CGFloat {
        return FIT(self)
    }
}

extension Double {
    func vn() -> CGFloat {
        return FIT(CGFloat(self))
    }
}







// MARK: - App信息

/// App 显示名称
public var AppDisplayName: String? {
    return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
}

public var AppName: String? {
    return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
}

/// app 的bundleid
public var AppBundleID: String? {
    return Bundle.main.bundleIdentifier
}

/// build号
public var AppBuildNumber: String? {
    return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
}

/// app版本号
public var AppVersion: String? {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}
/// app  Build number
public var AppBuildVersion: String? {
    return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
}
public var isX: Bool {
    return BottomHomeHeight > 0
}

// MARK: - 打印输出
public func BMLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
#if DEBUG
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
    let time = formatter.string(from: Date()) // 不需要可以注释
    
    let fileName = (file as NSString).lastPathComponent
    var funcTempName = funcName
    if funcName == "deinit" {
        funcTempName = "🟢🟢🟢deinit🟢🟢🟢"
    }
    
    print("\n\n----------------------------「LOG-BMLog」----------------------------\n\(time) 🔸文件: \(fileName) 🔸行: \(lineNum) 🔸方法: \(funcTempName) \n🟠内容:  \(message)\n-------------------------------「END」------------------------------- \n")
//    print("\n\n----------------------------「LOG-BMLog」----------------------------\n\(time) 🔸文件: \(fileName) 🔸行: \(lineNum) 🔸方法: \(funcTempName) 🔸线程: \(Thread.current)\n🟠内容:  \(message)\n-------------------------------「END」------------------------------- \n")
#endif
}


public func VNLog<T>(_ msg: T, file: String = #file, method: String = #function, line: Int = #line) {
//    #if DEBUG
        if "\(msg)".contains("\n") {
            print("\(formatter.string(from: Date()))文件:\((file as NSString).pathComponents.last ?? "")[\(line)行] 方法:\(method) > \n\(msg)")
        } else {
            print("\(formatter.string(from: Date()))文件:\((file as NSString).pathComponents.last ?? "")[\(line)行] 方法:\(method) > \(msg)")
        }
//    #endif
}

private let formatter = { () -> DateFormatter in
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
    return formatter
}()
public let SPACE: CGFloat = 12
public let PAGEZIE = 20

func KLanguage(key: String) -> String {
    let userDefaults = UserDefaults.standard
    let appLanguage = userDefaults.object(forKey: "appLanguage") as? String ?? "en"  // 假设默认语言为英语
    let path = Bundle.main.path(forResource: appLanguage, ofType: "lproj") ?? Bundle.main.bundlePath
    let languageBundle = Bundle(path: path)
    return languageBundle?.localizedString(forKey: key, value: nil, table: "Localizable") ?? key
}
public let IAP1_ProductID = "AutoClicker_Month_Nofree"
public let IAP2_ProductID = "AutoClicker_Year_Nofree"
/*#define IAP1_ProductID @"AutoClicker_Month_Nofree"
 #define IAP2_ProductID @"AutoClicker_Year_Nofree"*/
