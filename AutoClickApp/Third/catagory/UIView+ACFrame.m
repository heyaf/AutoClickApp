//
//  UIView+ACFrame.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/27.
//

#import "UIView+ACFrame.h"

@implementation UIView (ACFrame)

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x{
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y{
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width{
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

/** 中心的x坐标 */
- (CGFloat)centerX{
    return self.center.x;
}

/** 中心的y坐标 */
- (void)setCenterX:(CGFloat)x{
    self.center = CGPointMake(x, self.center.y);
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)y{
    self.center = CGPointMake(self.center.x, y);
}

/** 获取最大x */
- (CGFloat)maxX{
    return self.x + self.width;
}
/** 获取最小x */
- (CGFloat)minX{
    return self.x;
}

/** 获取最大y */
- (CGFloat)maxY{
    return self.y + self.height;
}
/** 获取最小y */
- (CGFloat)minY{
    return self.y;
}

/** 设置最小x,相当于设置x */
- (void)setMinX:(CGFloat)minX{
    self.x = minX;
}

/** 设置最大x */
- (void)setMaxX:(CGFloat)maxX{
    self.x = maxX - self.width;
}

/** 设置最小y,相当于设置y */
- (void)setMinY:(CGFloat)minY{
    self.y = minY;
}

/** 设置最大y */
- (void)setMaxY:(CGFloat)maxY{
    self.y = maxY - self.height;
}

-(void)removeAllSubviews{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}
@end
