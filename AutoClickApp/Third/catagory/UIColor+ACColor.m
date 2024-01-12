//
//  UIColor+ACColor.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/27.
//

#import "UIColor+ACColor.h"

@implementation UIColor (ACColor)

///十六进制字符串获取颜色
/// @param color 16进制色值  支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color{
    return [self colorWithHexString:color alpha:1.0f];
}


/// 十六进制字符串获取颜色
/// @param color 16进制色值  支持@“#123456”、 @“0X123456”、 @“123456”三种格式
/// @param alpha 透明度
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6){
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"]){
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6){
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIImage*) createImageWithColor: (UIColor*) color {
    return [self createImageWithColor:color size:CGSizeMake(1, 1)];
}
+ (UIImage*) createImageWithColor: (UIColor*) color size:(CGSize)size {
    CGRect rect=CGRectMake(0,0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

// 主题色 #26B59A
+ (UIColor *)mainThemeColor {
    return [UIColor colorWithHexString:@"#26B59A"];
//    return [UIColor colorWithHexString:@"#DBDAFF"];

}
+(UIColor *)themeColor{
    return [UIColor colorWithHexString:@"#E7D4FF"];
}
+(UIColor *)themeColor1{
    return [UIColor colorWithHexString:@"#8A38F5"];
}
+(UIColor *)mainBlackColor{
    return [UIColor colorWithHexString:@"#110C10"];
}
+ (UIColor *)colorFFFFFF {
    return [UIColor colorWithHexString:@"#FFFFFF"];
}

+ (UIColor *)color000000 {
    return [UIColor colorWithHexString:@"#000000"];
}

+ (UIColor *)colorFAFBFC {
    return [UIColor colorWithHexString:@"#FAFBFC"];
}

+ (UIColor *)colorC1C7D0 {
    return [UIColor colorWithHexString:@"#C1C7D0"];
}

+ (UIColor *)color333333 {
    return [UIColor colorWithHexString:@"#333333"];
}

+ (UIColor *)color666666 {
    return [UIColor colorWithHexString:@"#666666"];
}

+ (UIColor *)color999999 {
    return [UIColor colorWithHexString:@"#999999"];
}

+ (UIColor *)color7D838C {
    return [UIColor colorWithHexString:@"#7D838C"];
}

+ (UIColor *)colorF1F1F1 {
    return [UIColor colorWithHexString:@"#F1F1F1"];
}

+ (UIColor *)colorE1E1E1 {
    return [UIColor colorWithHexString:@"#E1E1E1"];
}

+ (UIColor *)colorDAFFFA {
    return [UIColor colorWithHexString:@"#DAFFFA"];
}

+ (UIColor *)color4D4D4D {
    return [UIColor colorWithHexString:@"#4D4D4D"];
}

+ (UIColor *)colorFA514B {
    return [UIColor colorWithHexString:@"#FA514B"];
}

+ (UIColor *)colorF7F8FA {
    return [UIColor colorWithHexString:@"#F7F8FA"];
}

+ (UIColor *)colorD1D1D1 {
    return [UIColor colorWithHexString:@"#D1D1D1"];
}

+ (UIColor *)colorFF5F59 {
    return [UIColor colorWithHexString:@"#FF5F59"];
}

+ (UIColor *)colorF6F6F6 {
    return [UIColor colorWithHexString:@"#F6F6F6"];
}

+ (UIColor *)colorF2F2F2 {
    return [UIColor colorWithHexString:@"#F2F2F2"];
}

@end

@implementation UIColor (Gradient)

+ (instancetype)gradientColorWithSize:(CGSize)size
                            direction:(GradientColorDirection)direction
                           startColor:(UIColor *)startcolor
                             endColor:(UIColor *)endColor {
    
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    if (direction == GradientColorDirectionUpwardDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    
    CGPoint endPoint = CGPointMake(0.0, 0.0);
    switch (direction) {
        case GradientColorDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case GradientColorDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case GradientColorDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            endPoint = CGPointMake(1.0, 0.0);
            break;
    }
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

@end
