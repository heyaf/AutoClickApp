//
//  ACAppClickUserView.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/1/18.
//

#import "ACAppClickUserView.h"

#import "DynamicRadialGradientView.h"
@implementation ACAppClickUserView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = UIColor.mainBlackColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        [self addGestureRecognizer:tap];
       
        [self setUI];
      
    }
    return self;
}
-(void)hiddenView{
    if (self.clickedBlock) {
        self.clickedBlock();
    }
}
-(void)setUI{
    
    DynamicRadialGradientView *view = [[DynamicRadialGradientView alloc] initWithFrame:CGRectMake(kScreenW/2-140, kNavBarHeight + 100, 280, 280)];
    view.backgroundColor = UIColor.mainBlackColor;
    [self addSubview:view];
    [self addHeartbeatAnimationToView:view];
    
    self.animation1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 222, 222)];
    self.animation1.frame = CGRectMake(0, 0, 222, 222);
    self.animation1.center = view.center;
    [self addSubview:self.animation1];
    self.animation1.backgroundColor = UIColor.mainBlackColor;
    kViewRadius(self.animation1, 111);
    [self addHeartbeatAnimationToView:self.animation1];
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.frame];
    maskView.backgroundColor = kRGBA(0, 0, 0, 0.1);
    [self addSubview:maskView];
    
    



    UIImageView *centerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 67, 67)];
    centerImageV.image = kIMAGE_Name(@"APP_icon");
    centerImageV.center = CGPointMake(111, 111);
    [self.animation1 addSubview:centerImageV];
    
    UILabel *label = [self.animation1 createLabelFrame:CGRectMake(111 - 50, centerImageV.maxY + 20, 100, 20) textColor:kWhiteColor font:kBoldFont(14)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = KLanguage(@"unlock");
    
    UILabel *label1 = [self createLabelFrame:CGRectMake(kScreenW/2-90, view.maxY + 5, 180, 40) textColor:kRGBA(255, 255, 255, 0.6) font:kFont(13)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.numberOfLines = 2;
   
    [self addSubview:label1];
    // 创建属性字符串
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:KLanguage(@"Unlock the use of automatic clicks in other apps!")];

    // 创建段落样式并设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5]; // 设置行间距为10
    paragraphStyle.alignment = NSTextAlignmentCenter;
    // 将段落样式应用到属性字符串
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];

    // 将属性字符串应用到UILabel
    [label1 setAttributedText:attributedString];
}

- (void)addHeartbeatAnimationToView:(UIView *)view {
    // 创建一个关键帧动画，设置动画属性为"transform.scale"
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画时间点
    animation.values = @[@(1.0), // 开始时的动画值，即原始大小
                         @(1.1), // 心跳增大到 110%
                         @(1.0), // 再返回到原始大小
                         @(0.9), // 心跳减小到 90%
                         @(1.0)]; // 最终返回到原始大小
    
    // 为每个时间点设置相应的时间百分比，这些值在 0 和 1 之间
    animation.keyTimes = @[@(0), @(0.5), @(0.75), @(0.9), @(1)];
    
    // 设置动画的总时间
    animation.duration = 1.0;
    
    // 设置重复次数，这里设置为无限重复
    animation.repeatCount = HUGE_VALF;
    
    // 防止动画结束后回到初始状态
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    // 将动画添加到视图的图层上
    [view.layer addAnimation:animation forKey:@"heartbeatAnimation"];
}

@end
