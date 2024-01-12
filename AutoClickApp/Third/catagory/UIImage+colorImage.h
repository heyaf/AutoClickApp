//
//  UIImage+colorImage.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (colorImage)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
