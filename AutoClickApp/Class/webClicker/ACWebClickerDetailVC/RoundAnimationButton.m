//
//  RoundAnimationButton.m
//  YUAnimation
//
//  Created by 郭海祥 on 2017/12/19.
//  Copyright © 2017年 animation.com. All rights reserved.
//

#import "RoundAnimationButton.h"


@interface RoundAnimationButton() {
    CALayer * subLayer;
    UIView * centerV; ///<中间显示的
}

@end

@implementation RoundAnimationButton

- (instancetype)init {
    if (self = [super init]) {
        [self defaultSetting];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting {
    _centerLineShow = YES;
    _centerLineWidth = 1;
    _centerLineColor = [UIColor whiteColor];
    _spaceFromCenter = 1;
    _rotateLineColor = [UIColor whiteColor];
}

- (void)showAnnimation {
    
    if (_isShowAnnimation) {
        [self hiddenAnnimation];
    }
    
    CGRect centerFrame = self.bounds;
    centerFrame.size = CGSizeMake(centerFrame.size.width - 2*_spaceFromCenter, centerFrame.size.height - 2*_spaceFromCenter);
    centerFrame.origin = CGPointMake(centerFrame.origin.x +_spaceFromCenter , centerFrame.origin.y + _spaceFromCenter);
    centerV = [[UIView alloc] initWithFrame:centerFrame];
    
    CGFloat centerCornerRadius = 0.0f;
    if (self.frame.size.width <= self.frame.size.height) {
        centerCornerRadius = floor((self.layer.cornerRadius*centerV.frame.size.width)/self.frame.size.width);
    } else {
        centerCornerRadius = floor((self.layer.cornerRadius*centerV.frame.size.height)/self.frame.size.height);
    }
    centerV.layer.cornerRadius = centerCornerRadius;
    
    if (_centerLineShow) {
        centerV.layer.borderColor = _centerLineColor.CGColor;
        centerV.layer.borderWidth = _centerLineWidth;
    }
    centerV.clipsToBounds = self.clipsToBounds;
    centerV.userInteractionEnabled = NO;
    [self addSubview:centerV];
    
    [self addSublayerForAnnimation];
    
    _isShowAnnimation = YES;

}
- (void)hiddenAnnimation {
    if (centerV) {
        [centerV removeFromSuperview];
        centerV = nil;
    }
    [self removeSublayerForAnnimation];
     _isShowAnnimation = NO;
}

- (void)addSublayerForAnnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        subLayer = [self replicatorLayer];
        [centerV.layer addSublayer:subLayer];
    });
}

- (void)removeSublayerForAnnimation {
    if (subLayer) {
        [subLayer removeFromSuperlayer];
        subLayer = nil;
    }
}

- (CALayer *)replicatorLayer{
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer new];
    replicatorLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    //    replicatorLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75].CGColor;
    
    CALayer *subLayer = [CALayer new];
    subLayer.bounds = CGRectMake(0, 0, 10, 10);
//    subLayer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    });
//    subLayer.borderColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
//    subLayer.borderWidth = 2.0;
    subLayer.cornerRadius = 5;
    subLayer.shouldRasterize = YES;
    subLayer.rasterizationScale = [UIScreen mainScreen].scale;
    [replicatorLayer addSublayer:subLayer];
    
    
    CAKeyframeAnimation *move = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    move.path = [self customPath];
    move.repeatCount = INFINITY;
    move.duration = 3.0;
    move.calculationMode = kCAAnimationCubicPaced;//kCAAnimationPaced; //平均
//    move.autoreverses = YES; //自动回弹
  
    [subLayer addAnimation:move forKey:nil];
    
    
    replicatorLayer.instanceDelay = 0.02;
    replicatorLayer.preservesDepth = YES;
    replicatorLayer.instanceCount = 20;
    replicatorLayer.instanceColor = _rotateLineColor.CGColor;
//    replicatorLayer.instanceGreenOffset = -0.03;

    return replicatorLayer;
}

- (CGPathRef)customPath
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:centerV.bounds cornerRadius:centerV.layer.cornerRadius];
    return CGPathCreateCopy(bezierPath.CGPath);
}

@end
