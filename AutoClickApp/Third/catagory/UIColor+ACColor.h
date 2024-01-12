//
//  UIColor+ACColor.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ACColor)

/// 十六进制字符串获取颜色
/// @param color 16进制色值  支持@“#123456”、@“0x123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color;

/// 十六进制字符串获取颜色
/// @param color 16进制色值  支持@“#123456”、@“0x123456”、 @“0X123456”、 @“123456”三种格式
/// @param alpha 透明度
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIImage*) createImageWithColor: (UIColor*) color;
+ (UIImage*) createImageWithColor: (UIColor*) color size:(CGSize)size;

// 主题色 #26B59A
+ (UIColor *)mainThemeColor;
+ (UIColor *)themeColor;
+ (UIColor *)themeColor1;
+ (UIColor *)colorFFFFFF;
+ (UIColor *)color000000;
+ (UIColor *)colorFAFBFC;
+ (UIColor *)colorC1C7D0;
+ (UIColor *)color333333;
+ (UIColor *)color666666;
+ (UIColor *)color999999;
+ (UIColor *)color7D838C;
+ (UIColor *)colorF1F1F1;
+ (UIColor *)colorE1E1E1;
+ (UIColor *)colorDAFFFA;
+ (UIColor *)color4D4D4D;
+ (UIColor *)colorFA514B;
+ (UIColor *)colorF7F8FA;
+ (UIColor *)colorD1D1D1;
+ (UIColor *)colorFF5F59;
+ (UIColor *)colorF6F6F6;
+ (UIColor *)colorF2F2F2;
+ (UIColor *)mainBlackColor;
@end

typedef NS_ENUM(NSInteger, GradientColorDirection) {
    GradientColorDirectionLevel,//水平渐变
    GradientColorDirectionVertical,//竖直渐变
    GradientColorDirectionDownDiagonalLine,//向上对角线渐变
    GradientColorDirectionUpwardDiagonalLine,//向下对角线渐变
};

@interface UIColor (Gradient)

/// 设置渐变色
/// @param size 需要渐变的大小
/// @param direction 渐变的方向
/// @param startcolor 渐变的开始颜色
/// @param endColor 渐变的结束颜色
+ (instancetype)gradientColorWithSize:(CGSize)size
                            direction:(GradientColorDirection)direction
                           startColor:(UIColor *)startcolor
                             endColor:(UIColor *)endColor;

@end

NS_ASSUME_NONNULL_END
