//
//  UIImage+colorImage.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/19.
//

#import "UIImage+colorImage.h"

@implementation UIImage (colorImage)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        [color setFill];
        [context fillRect:CGRectMake(0, 0, size.width, size.height)];
    }];
    return image;
}

@end
