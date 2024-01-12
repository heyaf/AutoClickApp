//
//  RoundAnimationButton.h
//  YUAnimation
//
//  Created by 郭海祥 on 2017/12/19.
//  Copyright © 2017年 animation.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundAnimationButton : UIButton

@property (nonatomic, assign) BOOL isShowAnnimation; //状态标识

//centerSetting

@property (nonatomic, assign) BOOL centerLineShow; //default YES
@property (nonatomic, assign) CGFloat centerLineWidth; //default 1
@property (nonatomic, assign) UIColor * centerLineColor; //default whiter

@property (nonatomic, assign) CGFloat spaceFromCenter; //default  10 距离边缘的距离

@property (nonatomic, assign) UIColor * rotateLineColor; //default white

- (void)showAnnimation;
- (void)hiddenAnnimation;

@end
