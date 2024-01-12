//
//  UIFont+Extension.swift
//  venom
//
//  Created by steve on 2022/1/19.
//

import Foundation
import UIKit


// MARK: - 字体
/// 系统默认字体
public let Font11 = UIFont.systemFont(ofSize: 11)
/// 系统默认字体
public let Font12 = UIFont.systemFont(ofSize: 12)
/// 系统默认字体
public let Font13 = UIFont.systemFont(ofSize: 13)
/// 系统默认字体
public let Font14 = UIFont.systemFont(ofSize: 14)
/// 系统默认字体
public let Font15 = UIFont.systemFont(ofSize: 15)
/// 系统默认字体
public let Font16 = UIFont.systemFont(ofSize: 16)


///根据屏幕自适应字体参数 16*FontFit
public let FontFit = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 375


public enum Weight {
    case medium
    case semibold
    case light
    case ultralight
    case regular
    case thin
    case Din
    case Dinbold
    case RacingSan
}

/// pingfang-sc 字体
public func Font(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .regular)
}
/// pingfang-sc 字体
public func FontMedium(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .medium)
}
/// pingfang-sc 字体
public func FontBold(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .semibold)
}

/// pingfang-sc 字体
public func FontWeight(_ size: CGFloat, weight: Weight) -> UIFont {
    var name = ""
    switch weight {
    case .medium:
        name = "PingFangSC-Medium"
    case .semibold:
        name = "PingFangSC-Semibold"
    case .light:
        name = "PingFangSC-Light"
    case .ultralight:
        name = "PingFangSC-Ultralight"
    case .regular:
        name = "PingFangSC-Regular"
    case .thin:
        name = "PingFangSC-Thin"
    case.Dinbold:
        name = "DINCondensed-Bold"
    case .Din:
        name = "DIN Condensed"
    case .RacingSan:
        name = "RacingSan"
    }
    
    return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
}



extension UIFont {
    class func pingFangSCMedium(_ size: CGFloat)-> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: size)!
    }
    
    class func pingFangSCSemibold(_ size: CGFloat)-> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: size)!
    }
    
    class func pingFangRegular(_ size: CGFloat)-> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size)!
    }
    
    class func DINAlternateBold(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "DINAlternate-Bold", size: size)
    }
    
    class func VNFontNumberYellow(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "vnfont-yellow", size: size)
    }
    class func VNFontNumberBrown(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "vnfont-brown", size: size)
    }
    
}
