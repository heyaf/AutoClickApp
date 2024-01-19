//
//  RadialGradientLayer.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/1/18.
//

#import "DynamicRadialGradientView.h"

@implementation DynamicRadialGradientView
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    // 创建颜色渐变
    UIColor *startColor = [UIColor colorWithRed:138/255.0 green:56/255.0 blue:245/255.0 alpha:1.0]; // 深色起始颜色
    UIColor *endColor = [UIColor colorWithRed:138/255.0 green:56/255.0 blue:245/255.0 alpha:0.0]; // 透明的结束颜色

    // 获取颜色的组件
    const CGFloat *startColorComponents = CGColorGetComponents(startColor.CGColor);
    const CGFloat *endColorComponents = CGColorGetComponents(endColor.CGColor);

    CGFloat colorComponents[8] = {
        startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], // 开始颜色
        endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3] // 结束颜色
    };

    // 调整locations数组中的值，以改变渐变的分布
    CGFloat locations[2] = {0.0, 1.0};

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, 2);

    // 圆形渐变填充
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = MIN(rect.size.width / 2, rect.size.height / 2);
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, kCGGradientDrawsBeforeStartLocation);

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);

    CGContextRestoreGState(context);
}

@end
