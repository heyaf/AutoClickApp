//
//  ACGuiderPageVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/10.
//

#import "ACGuiderPageVC.h"
#import <Lottie/Lottie.h>
@interface ACGuiderPageVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIButton *pageBtn;
// 设置动画View
@property (strong,nonatomic) LOTAnimationView *animation;
@property (strong,nonatomic) LOTAnimationView *animation1;

@property (nonatomic, strong) UIView *lineV;

@property (nonatomic, strong) UIView *pageView;


@property (nonatomic, assign) NSInteger index;
@end

@implementation ACGuiderPageVC

  
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.mainBlackColor;
    [self.view addSubview:self.scrollview];
    
    self.animation = [LOTAnimationView animationNamed:@"globe"];
                
    self.animation.frame = CGRectMake(0, 0, 182, 182);

    self.animation.center = CGPointMake(kScreenW/2, kStatusBarHeight + 170+91);
    if (!kISiPhoneXX) {
        self.animation.centerY = kStatusBarHeight + 110+91;
    }
    self.animation.loopAnimation = YES;
    self.animation.animationSpeed = 0.5;
    [self.scrollview addSubview:self.animation];
//    self.animation.autoReverseAnimation = YES;
    [self.animation play];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.animation.maxX-40, self.animation.maxY-27-45, 45, 45)];
    imageV.image = kIMAGE_Name(@"guider_ani1");
    [self.scrollview addSubview:imageV];
    
    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW/2+kScreenW-26, self.animation.centerY -20, 52, 52)];
    imageV2.image = kIMAGE_Name(@"guider_ani2");
    [self.scrollview addSubview:imageV2];
    self.animation1 = [LOTAnimationView animationNamed:@"wired-outline-134-target"];
    self.animation1.frame = CGRectMake(0, 0, 182, 182);
    self.animation1.center = CGPointMake(kScreenW/2+kScreenW, self.animation.centerY);
    self.animation1.loopAnimation = YES;
    self.animation1.animationSpeed = 0.5;
   
    [self.scrollview addSubview:self.animation1];
    
    UIView *bgLine = [self.view createLineFrame:CGRectMake(kScreenW/2-60, self.animation.maxY + 91, 120, 4) lineColor:[UIColor colorWithHexString:@"#272226"]];
    kViewRadius(bgLine, 2);
    UIView *lineV = [bgLine createLineFrame:CGRectMake(0, 0, 40, 4) lineColor:kWhiteColor];
    kViewRadius(lineV, 2);
    self.lineV = lineV;
    
    UILabel *label = [self.scrollview createLabelFrame:CGRectMake(10, bgLine.maxY + 24, kScreenW-20, 22) textColor:kWhiteColor font:kMediunFont(16)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = KLanguage(@"Automatically click on the web");
    
    UILabel *label1 = [self.scrollview createLabelFrame:CGRectMake(kScreenW + 10, bgLine.maxY + 24, kScreenW-20, 22) textColor:kWhiteColor font:kMediunFont(16)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = KLanguage(@"How to automatically click on the app");
    
    UILabel *label2 = [self.scrollview createLabelFrame:CGRectMake(kScreenW*2 + 10, bgLine.maxY + 24, kScreenW-20, 22) textColor:kWhiteColor font:kMediunFont(16)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = KLanguage(@"Interesting practical gadgets");
    
    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(kScreenW/2-28, label.maxY + 77, 56, 56);
    btn.backgroundColor = kWhiteColor;
    kViewRadius(btn, 28);
    [self.view addSubview:btn];
    self.pageBtn = btn;
    [btn addTarget:self action:@selector(guiderClicker) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW/2-12, btn.y +16, 24, 24)];
    imageV1.image = kIMAGE_Name(@"guider_click");
    [self.view addSubview:imageV1];
    
    [self.scrollview addSubview:self.pageView];
    self.index =0;
    
    UILabel *skipL  = [self.view createLabelFrame:CGRectMake(kScreenW - 50, kStatusBarHeight + 32, 30, 20) textColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.6] font:kFont(10)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"Skip" attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
    skipL.attributedText = attrStr;
    [skipL sizeToFit];
    skipL.height = 20;
    skipL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipAction)];
    [skipL addGestureRecognizer:tap];
    
}
-(void)skipAction{
    //[playVolume playMusic];

    CATransition *animation = [CATransition animation];
    animation.type = @"cube";
    animation.subtype = kCATransitionFromRight;
    animation.duration = 0.5;    //换图片的时候使用转场动画
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
//    [kKeyWindow.rootViewController presentViewController:[ACPayOneViewController new] animated:YES completion:nil];
}
-(UIScrollView *)scrollview{
    if(!_scrollview){
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _scrollview.backgroundColor = UIColor.mainBlackColor;
        _scrollview.contentSize = CGSizeMake(kScreenW*3, kScreenH);
        _scrollview.pagingEnabled = YES;
        _scrollview.delegate = self;
        _scrollview.scrollEnabled = NO;
        
    }
    return _scrollview;
}
-(void)guiderClicker{
    //[playVolume playMusic];

    __weak typeof(self) weakSelf = self;
    self.index ++ ;
    if(self.index>0){
        [self.animation stop];
        [self.animation1 play];
    }else if (self.index>1){
        [self.animation stop];
        [self.animation1 stop];
    }
    if (self.index==3) {
        CATransition *animation = [CATransition animation];
        animation.type = @"cube";
        animation.subtype = kCATransitionFromRight;
        animation.duration = 0.5;    //换图片的时候使用转场动画
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.scrollview.contentOffset = CGPointMake(kScreenW*weakSelf.index, 0);
        weakSelf.lineV.x = weakSelf.index*40;
        weakSelf.pageBtn.width = ((kScreenW-32) - 56)/3*weakSelf.index+56;
        weakSelf.pageBtn.centerX = kScreenW/2;
    }];
}
-(UIView *)pageView{
    if(!_pageView){
        CGFloat width = 74*3+32;
        CGFloat height = 102*2+16;
        _pageView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW*2+kScreenW/2-width/2, self.animation.y - 15, width, height)];
        _pageView.backgroundColor = kClearColor;
        NSArray *pageAarr = @[@"guide1",@"guide2",@"guide3",@"guide4",@"guide5",@"guide6"];
        for (int i = 0; i<pageAarr.count; i++) {
            NSInteger row = i/3;
            NSInteger column = i%3;
            UIView *bgV = [_pageView createLineFrame:CGRectMake(column*(16+74), row*(16+102), 74, 102) lineColor:[UIColor colorWithHexString:@"#272226"]];
            kViewRadius(bgV, 14);
            
            UIImageView *imaegV = [[UIImageView alloc] initWithFrame:CGRectMake(37-17, 51-17, 34, 34)];
            imaegV.image = kIMAGE_Name(pageAarr[i]);
            [bgV addSubview:imaegV];
        }
    }
    return _pageView;
}
@end
