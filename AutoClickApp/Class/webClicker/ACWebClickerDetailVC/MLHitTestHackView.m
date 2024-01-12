//
//  MLHitTestHackView.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/14.
//

#import "MLHitTestHackView.h"
#import<objc/runtime.h>
@implementation MLHitTestHackView

+ (void)load
{
    [self hackHitTest];
}
+ (void)hackHitTest
{
    SEL hitTestSEL = @selector(hitTest:withEvent:);
    Method customHitTest = class_getInstanceMethod([MLHitTestHackView class], hitTestSEL);
    Method originalHitTest = class_getInstanceMethod([UIView class], hitTestSEL);
    method_exchangeImplementations(customHitTest, originalHitTest);
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    if ([self pointInside:point withEvent:event]) {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                if(hitTestView.tag == 100012){
                    return hitTestView.superview;;
                }
                return hitTestView;
            }
        }
        return self;
    }
    return nil;
}


@end
