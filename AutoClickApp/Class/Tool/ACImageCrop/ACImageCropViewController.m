//
//  ACImageCropViewController.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/7.
//

#import "ACImageCropViewController.h"
#define ControllSize 60
#define ControllSize1 2

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ACImageCropViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView* clipMaskView;

@property (nonatomic,strong) UIView* clipBox;
@property (nonatomic,strong) UIView* whiteBox;
@property (nonatomic,strong) UIView* hLine1;
@property (nonatomic,strong) UIView* hLine2;
@property (nonatomic,strong) UIView* vLine1;
@property (nonatomic,strong) UIView* vLine2;
@property (nonatomic,strong) UIView* leftView;
@property (nonatomic,strong) UIView* rightView;
@property (nonatomic,strong) UIView* bottomView;
@property (nonatomic,strong) UIView* topView;
@property (nonatomic,strong) UIView* leftTopView;
@property (nonatomic,strong) UIView* rightTopView;
@property (nonatomic,strong) UIView* leftBottomView;
@property (nonatomic,strong) UIView* rightBottomView;

@property (nonatomic,strong) UIImageView* imageView;

@property (nonatomic,assign) CGSize maskSize;

@property (nonatomic,assign) CGRect maxClipBoxFrame;

@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UIView *bottomV;

@property (nonatomic, assign) NSInteger index;
//@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;

@end

@implementation ACImageCropViewController{
    CGFloat _minX;
    CGFloat _minY;
    CGFloat _maxX;
    CGFloat _maxY;
    BOOL _moveBox;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.mainBlackColor;
    
    self.view.layer.masksToBounds = YES;
    if ((self.clipSize.width == 0 || self.clipSize.height == 0) && self.ratio == 0 && self.clipType == WEClipImageMoveImage) {
    }
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.clipMaskView];

    [self.view bringSubviewToFront:self.clipMaskView];
    if (self.clipType == WEClipImageMoveBox) {
        [self.view addSubview:self.clipBox];
    }
    [self.view addSubview:self.topV];
    [self.view addSubview:self.bottomV];
    
    UIButton *btn1 = [UIButton buttonWithType:0];
    btn1.frame = CGRectMake(kScreenW/2-8-99, kScreenH-kTabBarHeight-33-42, 66, 42);
    [btn1 setBackgroundColor:[UIColor colorWithHexString:@"#272226"]];
    [btn1 setTitle:@"16 : 9" forState:0];
    btn1.titleLabel.font = kFont(14);
    kViewRadius(btn1, 5);
    [self.view addSubview:btn1];
    btn1.tag = 200;
    [btn1 addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:0];
    btn2.frame = CGRectMake(kScreenW/2-33, kScreenH-kTabBarHeight-33-42, 66, 42);
    [btn2 setBackgroundColor:[UIColor colorWithHexString:@"#272226"]];
    [btn2 setTitle:@"4 : 3" forState:0];
    btn2.titleLabel.font = kFont(14);
    kViewRadius(btn2, 5);
    [self.view addSubview:btn2];
    btn2.tag = 201;
    [btn2 addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn3 = [UIButton buttonWithType:0];
    btn3.frame = CGRectMake(kScreenW/2+8+33, kScreenH-kTabBarHeight-33-42, 66, 42);
    [btn3 setBackgroundColor:[UIColor colorWithHexString:@"#272226"]];
    [btn3 setTitle:@"1 : 1" forState:0];
    btn3.titleLabel.font = kFont(14);
    kViewRadius(btn3, 5);
    [self.view addSubview:btn3];
    btn3.tag = 202;
    [btn3 addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.btn1 = btn1;
    self.btn2 = btn2;
    self.btn3 = btn3;

}
-(void)changeAction:(UIButton *)btn{
    [UIButton setanimationwithBtn:btn];
    [playVolume playMusic];

    self.index = btn.tag-199;
    if (btn.tag == 200) {
        self.btn1.backgroundColor = [UIColor colorWithHexString:@"#8A38F5"];
        self.btn2.backgroundColor = [UIColor colorWithHexString:@"#272226"];
        self.btn3.backgroundColor = [UIColor colorWithHexString:@"#272226"];

    }else if (btn.tag == 201){
        self.btn2.backgroundColor = [UIColor colorWithHexString:@"#8A38F5"];
        self.btn1.backgroundColor = [UIColor colorWithHexString:@"#272226"];
        self.btn3.backgroundColor = [UIColor colorWithHexString:@"#272226"];
    }else if (btn.tag == 202){
        self.btn3.backgroundColor = [UIColor colorWithHexString:@"#8A38F5"];
        self.btn2.backgroundColor = [UIColor colorWithHexString:@"#272226"];
        self.btn1.backgroundColor = [UIColor colorWithHexString:@"#272226"];
    }
    CGFloat num = 1;
    if (self.index==1) {
        num = 16/9.00;
    }else if (self.index==2){
        num = 4/3.00;
    }
    if (self.originalImage.size.width > self.originalImage.size.height) {
        if (self.index==1) {
            num = 9/16.00;
        }else if (self.index==2){
            num = 3/4.00;
        }
    }
    CGFloat height = self.clipBox.frame.size.width*num;
    
    CGRect clipBoxFrame = CGRectMake(self.clipBox.frame.origin.x, self.clipBox.frame.origin.y, self.clipBox.frame.size.width,MIN(height, self.imageView.height) );
    [UIView animateWithDuration:0.3 animations:^{
        self.clipBox.frame = clipBoxFrame;
//            self.imageView.frame = tempImageFrame;
        [self reloadClipBox];
    } completion:^(BOOL finished) {
        //透明图层
        UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:_clipMaskView.bounds];
//            [path1 appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((_clipMaskView.frame.size.width - self.maskSize.width) / 2, (_clipMaskView.frame.size.height - self.maskSize.height) / 2, self.maskSize.width, self.maskSize.height)] bezierPathByReversingPath]];
        [path1 appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(self.clipBox.frame.origin.x + ControllSize / 2, self.clipBox.frame.origin.y + ControllSize / 2, self.clipBox.frame.size.width - ControllSize, self.clipBox.frame.size.height - ControllSize)] bezierPathByReversingPath]];
        CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
        shapeLayer1.path = path1.CGPath;
        [_clipMaskView.layer setMask:shapeLayer1];
        
        _minX = self.clipBox.frame.origin.x + ControllSize / 2;//(_clipMaskView.frame.size.width - (self.clipBox.frame.size.width - ControllSize)) / 2;
        _minY = self.clipBox.frame.origin.y + ControllSize / 2;//(_clipMaskView.frame.size.height - (self.clipBox.frame.size.height - ControllSize)) / 2;
        _maxX = self.clipBox.frame.origin.x + self.clipBox.frame.size.width - ControllSize / 2;//_clipMaskView.frame.size.width - _minX;
        _maxY = self.clipBox.frame.origin.y + self.clipBox.frame.size.height - ControllSize / 2;//_clipMaskView.frame.size.height - _minY;
    }];
    return;

}
- (UIView*)clipMaskView {
    if (!_clipMaskView) {
    
        _clipMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        _clipMaskView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
        self.maskSize = CGSizeZero;
        if (CGSizeEqualToSize(self.clipSize, CGSizeZero)) {
            if (self.clipType == WEClipImageMoveBox) {
                self.maskSize = CGSizeMake(_clipMaskView.frame.size.width - ControllSize1, (_clipMaskView.frame.size.width - ControllSize1) / self.originalImage.size.width * self.originalImage.size.height);
            } else {
                if (self.ratio >= 1) {//说明宽大
                    self.maskSize = CGSizeMake(_clipMaskView.frame.size.width - ControllSize1, (_clipMaskView.frame.size.width - ControllSize1) / self.ratio);
                } else {
                    self.maskSize = CGSizeMake((ScreenHeight - 64 - ControllSize1) * self.ratio, ScreenHeight - 64 - ControllSize1);
//                    self.maskSize = CGSizeMake(self.view.frame.size.width - 80, (self.view.frame.size.width - 80) / self.ratio);
                }
            }
        } else {
            //如果宽大于高
            if (self.clipSize.width >= self.clipSize.height) {
                //宽大 宽小于屏幕宽 / 2
                if (self.clipSize.width < self.view.frame.size.width / 2) {
                    self.maskSize = CGSizeMake(self.view.frame.size.width / 2, (self.view.frame.size.width / 2) / self.clipSize.width * self.clipSize.height);
                } else {
                    //宽大 宽大于屏幕宽 - 40
                    if (self.clipSize.width > self.view.frame.size.width - 40) {
                        self.maskSize = CGSizeMake(self.view.frame.size.width - 40, (self.view.frame.size.width - 40) / self.clipSize.width * self.clipSize.height);
                    } else {
                        self.maskSize = self.clipSize;
                    }
                }
            } else {
                if (self.clipSize.height < (self.view.frame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame)) / 2) {
                    self.maskSize = CGSizeMake((self.view.frame.size.width - CGRectGetMaxY(self.navigationController.navigationBar.frame)) / 2 / self.clipSize.height * self.clipSize.width, (self.view.frame.size.width - CGRectGetMaxY(self.navigationController.navigationBar.frame)) / 2);
                } else {
                    //宽大 宽大于屏幕宽 - 40
                    if (self.clipSize.height > self.view.frame.size.width - CGRectGetMaxY(self.navigationController.navigationBar.frame) - 40) {
                        self.maskSize = CGSizeMake((self.view.frame.size.width - CGRectGetMaxY(self.navigationController.navigationBar.frame) - 40) / self.clipSize.height * self.clipSize.width, self.view.frame.size.width - CGRectGetMaxY(self.navigationController.navigationBar.frame) - 40);
                    } else {
                        self.maskSize = self.clipSize;
                    }
                }
            }
        }
        self.maskSize = self.imageView.frame.size;
        //透明图层
        UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:_clipMaskView.bounds];
        [path1 appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((_clipMaskView.frame.size.width - self.maskSize.width) / 2, (_clipMaskView.frame.size.height - self.maskSize.height) / 2, self.maskSize.width, self.maskSize.height)] bezierPathByReversingPath]];
        CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
        shapeLayer1.path = path1.CGPath;
        [_clipMaskView.layer setMask:shapeLayer1];
        
        _minX = (_clipMaskView.frame.size.width - self.maskSize.width) / 2;
        _minY = (_clipMaskView.frame.size.height - self.maskSize.height) / 2;
        _maxX = _clipMaskView.frame.size.width - _minX;
        _maxY = _clipMaskView.frame.size.height - _minY;
        
//        //拖动(改变位置)
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEditViewGesture:)];
//        pan.delegate = self;
//        [_clipMaskView addGestureRecognizer:pan];
//        // 缩放手势
//        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleEditViewGesture:)];
//        pinch.delegate = self;
//        [_clipMaskView addGestureRecognizer:pinch];
    }
    return _clipMaskView;
}

- (UIImageView*)imageView {
    if (!_imageView) {
        CGSize tempSize = CGSizeZero;
        CGRect rect = CGRectZero;
//        if (self.originalImage.size.width > self.originalImage.size.height) {
//            tempSize = CGSizeMake(self.maskSize.height / self.originalImage.size.height * self.originalImage.size.width, self.maskSize.height);
//            if (tempSize.width < self.maskSize.width) {
//                tempSize = CGSizeMake(self.maskSize.width, self.maskSize.width / tempSize.width * tempSize.height);
//            }
//            rect = CGRectMake((self.clipMaskView.frame.size.width - tempSize.width) / 2, (self.clipMaskView.frame.size.height - tempSize.height) / 2, tempSize.width, tempSize.height);
//        } else {
//            tempSize = CGSizeMake(self.maskSize.width, self.maskSize.width / self.originalImage.size.width * self.originalImage.size.height);
//            if (tempSize.height < self.maskSize.height) {
//                tempSize = CGSizeMake(self.maskSize.height / tempSize.height * tempSize.width, self.maskSize.height);
//            }
//            rect = CGRectMake(10, kNavBarHeight, self.view.frame.size.width-20, kScreenH-kNavBarHeight-kTabBarHeight-100);
//        }
        CGFloat height = kScreenH- kTabBarHeight- kNavBarHeight -100;
        CGFloat imageW = self.originalImage.size.width;
        CGFloat imageH = self.originalImage.size.height;
        if (imageW/imageH>kScreenW/height) { //上下留白
            CGFloat imageVH = kScreenW*imageH/imageW;
            
            rect = CGRectMake(0, height/2+kNavBarHeight, kScreenW, imageVH);
        }else{
            CGFloat imageVW =height *imageW/imageH;
            rect = CGRectMake(kScreenW/2-imageVW/2, kNavBarHeight, imageVW, height);
            
        }
        
        _imageView = [[UIImageView alloc] initWithFrame:rect];
        _imageView.image = self.originalImage;
    }
    return _imageView;
}

- (UIView*)clipBox {
    if (!_clipBox) {
        _clipBox = [[UIView alloc] initWithFrame:CGRectMake(self.imageView.frame.origin.x - ControllSize / 2, self.imageView.frame.origin.y - ControllSize / 2, self.imageView.frame.size.width + ControllSize, self.imageView.frame.size.height + ControllSize)];
        
        self.maxClipBoxFrame = _clipBox.frame;
        
        //拖动(改变位置)
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEditViewGesture:)];
        pan.delegate = self;
        [_clipBox addGestureRecognizer:pan];
        // 缩放手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleEditViewGesture:)];
        pinch.delegate = self;
        [_clipBox addGestureRecognizer:pinch];
        
        [self reloadClipBox];
    }
    return _clipBox;
}

- (void)reloadClipBox {
    if (!_whiteBox) {
        self.whiteBox = [[UIView alloc] init];
        self.whiteBox.layer.borderColor = [UIColor whiteColor].CGColor;
        self.whiteBox.layer.borderWidth = 1;
        [_clipBox addSubview:self.whiteBox];
        
        self.hLine1 = [[UIView alloc] init];
        self.hLine1.backgroundColor = [UIColor whiteColor];
        [_clipBox addSubview:self.hLine1];
        
        self.hLine2 = [[UIView alloc] init];
        self.hLine2.backgroundColor = [UIColor whiteColor];
        [_clipBox addSubview:self.hLine2];
        
        self.vLine1 = [[UIView alloc] init];
        self.vLine1.backgroundColor = [UIColor whiteColor];
        [_clipBox addSubview:self.vLine1];
        
        self.vLine2 = [[UIView alloc] init];
        self.vLine2.backgroundColor = [UIColor whiteColor];
        [_clipBox addSubview:self.vLine2];
        
        self.leftTopView = [[UIView alloc] init];
        [self.leftTopView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clipBoxHandlePan:)]];
        [_clipBox addSubview:self.leftTopView];
        
        self.rightTopView = [[UIView alloc] init];
        [self.rightTopView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clipBoxHandlePan:)]];
        [_clipBox addSubview:self.rightTopView];
        
        self.leftBottomView = [[UIView alloc] init];
        [self.leftBottomView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clipBoxHandlePan:)]];
        [_clipBox addSubview:self.leftBottomView];
        
        self.rightBottomView = [[UIView alloc] init];
        [self.rightBottomView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clipBoxHandlePan:)]];
        [_clipBox addSubview:self.rightBottomView];
        
        self.leftView = [[UIView alloc] init];
        [self.leftView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clipBoxHandlePan:)]];
        [_clipBox addSubview:self.leftView];
        
        self.rightView = [[UIView alloc] init];
        [self.rightView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clipBoxHandlePan:)]];
        [_clipBox addSubview:self.rightView];
        
        self.topView = [[UIView alloc] init];
        [self.topView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clipBoxHandlePan:)]];
        [_clipBox addSubview:self.topView];
        
        self.bottomView = [[UIView alloc] init];
        [self.bottomView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clipBoxHandlePan:)]];
        [_clipBox addSubview:self.bottomView];
    }
    
    self.whiteBox.frame = CGRectMake(ControllSize / 2, ControllSize / 2, _clipBox.frame.size.width - ControllSize, _clipBox.frame.size.height - ControllSize);
    
    self.hLine1.frame = CGRectMake(ControllSize / 2, ControllSize / 2 + (_clipBox.frame.size.height - ControllSize) / 3, _clipBox.frame.size.width - ControllSize, 1);
    self.hLine2.frame = CGRectMake(ControllSize / 2, ControllSize / 2 + (_clipBox.frame.size.height - ControllSize) / 3 * 2, _clipBox.frame.size.width - ControllSize, 1);
    
    self.vLine1.frame = CGRectMake(ControllSize / 2 + (_clipBox.frame.size.width - ControllSize) / 3, ControllSize / 2, 1, _clipBox.frame.size.height - ControllSize);
    self.vLine2.frame = CGRectMake(ControllSize / 2 + (_clipBox.frame.size.width - ControllSize) / 3 * 2, ControllSize / 2, 1, _clipBox.frame.size.height - ControllSize);
    
    self.leftTopView.frame = CGRectMake(0, 0, ControllSize, ControllSize);
    self.rightTopView.frame = CGRectMake(_clipBox.frame.size.width - ControllSize, 0, ControllSize, ControllSize);
    self.leftBottomView.frame = CGRectMake(0, _clipBox.frame.size.height - ControllSize, ControllSize, ControllSize);
    self.rightBottomView.frame = CGRectMake(_clipBox.frame.size.width - ControllSize, _clipBox.frame.size.height - ControllSize, ControllSize, ControllSize);
    self.leftView.frame = CGRectMake(0, CGRectGetMaxY(self.leftTopView.frame), ControllSize, _clipBox.frame.size.height - self.leftTopView.frame.size.height - self.leftBottomView.frame.size.height);
    self.rightView.frame = CGRectMake(_clipBox.frame.size.width - ControllSize, CGRectGetMaxY(self.rightTopView.frame), ControllSize, _clipBox.frame.size.height - self.rightTopView.frame.size.height - self.rightBottomView.frame.size.height);
    self.topView.frame = CGRectMake(CGRectGetMaxX(self.leftTopView.frame), 0, _clipBox.frame.size.width - self.leftTopView.frame.size.width - self.rightTopView.frame.size.width, ControllSize);
    self.bottomView.frame = CGRectMake(CGRectGetMaxX(self.leftBottomView.frame), _clipBox.frame.size.height - ControllSize, _clipBox.frame.size.width - self.rightTopView.frame.size.width - self.rightBottomView.frame.size.width, ControllSize);
}

- (void)clipBoxHandlePan:(UIPanGestureRecognizer*)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (_moveBox == true) {
            return;
        }
        _moveBox = true;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGRect clipBoxFrame = [self resetClipBox];
        NSLog(@"%@---%@+++++%@",NSStringFromCGRect(clipBoxFrame),NSStringFromCGRect(self.clipBox.frame),NSStringFromCGRect(pan.view.frame) );
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        _moveBox = false;
        CGRect clipBoxFrame = [self resetClipBox];
        //        CGFloat chang = MAX(clipBoxFrame.size.width, clipBoxFrame.size.height);
        CGFloat num = 1;
        if (self.index==1) {
            num = 16/9.00;
        }else if (self.index==2){
            num = 4/3.00;
        }
        if (self.originalImage.size.width > self.originalImage.size.height) {
            if (self.index==1) {
                num = 9/16.00;
            }else if (self.index==2){
                num = 3/4.00;
            }
        }
        CGFloat height = self.clipBox.frame.size.width*num;
        
        clipBoxFrame = CGRectMake(clipBoxFrame.origin.x, clipBoxFrame.origin.y, clipBoxFrame.size.width, MIN(height, self.imageView.height));
//        CGFloat bili = self.maxClipBoxFrame.size.width / self.clipBox.frame.size.width;
//
//        CGRect tempImageFrame = self.imageView.frame;
//        tempImageFrame.size.width = tempImageFrame.size.width * bili;
//        tempImageFrame.size.height = tempImageFrame.size.height * bili;
//        tempImageFrame.origin.x = tempImageFrame.origin.x - (self.clipBox.origin.x - clipBoxFrame.origin.x);
//        tempImageFrame.origin.y = tempImageFrame.origin.y - (self.clipBox.origin.y - clipBoxFrame.origin.y);
//
//        NSLog(@"%@---%@--%@",NSStringFromCGSize(self.maxClipBoxFrame.size),NSStringFromCGSize(self.clipBox.size),NSStringFromCGSize(tempImageFrame.size));
//
//        if (tempImageFrame.size.width > self.imageView.image.size.width){
//            tempImageFrame.size.width = self.imageView.image.size.width;
//        }
//        if (tempImageFrame.size.height > self.imageView.image.size.height) {
//            tempImageFrame.size.height = self.imageView.image.size.height;
//        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.clipBox.frame = clipBoxFrame;
//            self.imageView.frame = tempImageFrame;
            [self reloadClipBox];
        } completion:^(BOOL finished) {
            //透明图层
            UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:_clipMaskView.bounds];
//            [path1 appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((_clipMaskView.frame.size.width - self.maskSize.width) / 2, (_clipMaskView.frame.size.height - self.maskSize.height) / 2, self.maskSize.width, self.maskSize.height)] bezierPathByReversingPath]];
            [path1 appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(self.clipBox.frame.origin.x + ControllSize / 2, self.clipBox.frame.origin.y + ControllSize / 2, self.clipBox.frame.size.width - ControllSize, self.clipBox.frame.size.height - ControllSize)] bezierPathByReversingPath]];
            CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
            shapeLayer1.path = path1.CGPath;
            [_clipMaskView.layer setMask:shapeLayer1];
            
            _minX = self.clipBox.frame.origin.x + ControllSize / 2;//(_clipMaskView.frame.size.width - (self.clipBox.frame.size.width - ControllSize)) / 2;
            _minY = self.clipBox.frame.origin.y + ControllSize / 2;//(_clipMaskView.frame.size.height - (self.clipBox.frame.size.height - ControllSize)) / 2;
            _maxX = self.clipBox.frame.origin.x + self.clipBox.frame.size.width - ControllSize / 2;//_clipMaskView.frame.size.width - _minX;
            _maxY = self.clipBox.frame.origin.y + self.clipBox.frame.size.height - ControllSize / 2;//_clipMaskView.frame.size.height - _minY;
        }];
        return;
    }
    CGPoint translation = [pan translationInView:self.view];
    CGRect tempFrame = self.clipBox.frame;
    if ([pan.view isEqual:self.leftTopView]) {
        tempFrame.origin.x = tempFrame.origin.x + translation.x;
        tempFrame.origin.y = tempFrame.origin.y + translation.y;
        tempFrame.size.width = tempFrame.size.width - translation.x;
        tempFrame.size.height = tempFrame.size.height - translation.y;
    } else if ([pan.view isEqual:self.leftBottomView]) {
        tempFrame.origin.x = tempFrame.origin.x + translation.x;
        tempFrame.size.width = tempFrame.size.width - translation.x;
        tempFrame.size.height = tempFrame.size.height + translation.y;
    } else if ([pan.view isEqual:self.rightTopView]) {
        tempFrame.origin.y = tempFrame.origin.y + translation.y;
        tempFrame.size.width = tempFrame.size.width + translation.x;
        tempFrame.size.height = tempFrame.size.height - translation.y;
    } else if ([pan.view isEqual:self.rightBottomView]) {
        tempFrame.size.width = tempFrame.size.width + translation.x;
        tempFrame.size.height = tempFrame.size.height + translation.y;
    } else if ([pan.view isEqual:self.leftView]) {
        tempFrame.origin.x = tempFrame.origin.x + translation.x;
        tempFrame.size.width = tempFrame.size.width - translation.x;
    } else if ([pan.view isEqual:self.rightView]) {
        tempFrame.size.width = tempFrame.size.width + translation.x;
    } else if ([pan.view isEqual:self.topView]) {
        tempFrame.origin.y = tempFrame.origin.y + translation.y;
        tempFrame.size.height = tempFrame.size.height - translation.y;
    } else if ([pan.view isEqual:self.bottomView]) {
        tempFrame.size.height = tempFrame.size.height + translation.y;
    }
    
    if (tempFrame.origin.x < self.maxClipBoxFrame.origin.x) {
        tempFrame.origin.x = self.maxClipBoxFrame.origin.x;
    }
    if (tempFrame.origin.y < self.maxClipBoxFrame.origin.y) {
        tempFrame.origin.y = self.maxClipBoxFrame.origin.y;
    }
    if (tempFrame.size.width > self.maxClipBoxFrame.size.width - (tempFrame.origin.x - self.maxClipBoxFrame.origin.x)) {
        tempFrame.size.width = self.maxClipBoxFrame.size.width - (tempFrame.origin.x - self.maxClipBoxFrame.origin.x);
    }
    if (tempFrame.size.height > self.maxClipBoxFrame.size.height - (tempFrame.origin.y - self.maxClipBoxFrame.origin.y)) {
        tempFrame.size.height = self.maxClipBoxFrame.size.height - (tempFrame.origin.y - self.maxClipBoxFrame.origin.y);
    }
    
    self.clipBox.frame = tempFrame;
    [self reloadClipBox];
    
    [pan setTranslation:CGPointZero inView:self.view];
}

- (void)handleEditViewGesture:(UIGestureRecognizer*)gesture {
    if (_moveBox) {
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGRect tempFrame = [self resetImageView];
//        if (tempFrame.size.height > self.imageView.image.size.height && [gesture isKindOfClass:[UIPinchGestureRecognizer class]]) {
//            CGPoint center = self.imageView.center;
//            [UIView animateWithDuration:0.3 animations:^{
//                self.imageView.size = self.imageView.image.size;
//                self.imageView.center = center;
//            } completion:^(BOOL finished) {
//
//            }];
//        }else{
//        }
        [UIView animateWithDuration:0.3 animations:^{
            //                self.clipBox.frame
            self.imageView.frame = tempFrame;
        } completion:^(BOOL finished) {
            
        }];
        return;
    }
    if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        [self handlePan:(UIPanGestureRecognizer*)gesture];
    } else if ([gesture isKindOfClass:[UIPinchGestureRecognizer class]]) {
        [self handlePinch:(UIPinchGestureRecognizer*)gesture];
    }
}

- (void)handlePan:(UIPanGestureRecognizer*)pan {
    CGPoint translation = [pan translationInView:self.clipMaskView];
    self.imageView.center = CGPointMake(self.imageView.center.x + translation.x,
                                   self.imageView.center.y + translation.y);
//    NSLog(@"%f------%f",self.imageView.frame.origin.x,self.imageView.frame.origin.y);
    [pan setTranslation:CGPointZero inView:self.view];
}

- (void)handlePinch:(UIPinchGestureRecognizer*)pinch {
    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        self.imageView.transform = CGAffineTransformScale(self.imageView.transform, pinch.scale, pinch.scale);
        pinch.scale = 1;
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    if (![gestureRecognizer.view isEqual:otherGestureRecognizer.view]) {
        return false;
    }
    return true;
}

- (CGRect)resetImageView {
    CGRect tempFrame = self.imageView.frame;
    if (tempFrame.size.width < _maxX - _minX) {
        tempFrame.size.width = _maxX - _minX;
        tempFrame.size.height = tempFrame.size.width / self.imageView.frame.size.width * self.imageView.frame.size.height;
    }
    if (tempFrame.origin.x > _minX) {
        tempFrame.origin.x = _minX;
    }
    if (tempFrame.size.height < _maxY - _minY) {
        tempFrame.size.height = _maxY - _minY;
        tempFrame.size.width = tempFrame.size.height / self.imageView.frame.size.height * self.imageView.frame.size.width;
    }
    if (tempFrame.origin.y > _minY) {
        tempFrame.origin.y = _minY;
    }
    if (CGRectGetMaxY(tempFrame) < _maxY) {
        tempFrame.origin.y = tempFrame.origin.y + _maxY - CGRectGetMaxY(tempFrame);
    }
    if (CGRectGetMaxX(tempFrame) < _maxX) {
        tempFrame.origin.x = tempFrame.origin.x + _maxX - CGRectGetMaxX(tempFrame);
    }
    return tempFrame;
}

- (CGRect)resetClipBox {
    CGRect tempFrame = self.clipBox.frame;
    
//    tempFrame.size.width = self.maxClipBoxFrame.size.width;
//    tempFrame.size.height =  self.maxClipBoxFrame.size.width / tempFrame.size.width * tempFrame.size.height;
//    tempFrame.origin.x = (self.view.frame.size.width - tempFrame.size.width) / 2;
//    tempFrame.origin.y = (self.view.frame.size.height - tempFrame.size.height) / 2;
    
    return tempFrame;
}

- (void)resetAllClip {
    for (UIView* view in self.view.subviews) {
        [view removeFromSuperview];
        
    }
    self.clipMaskView = nil;
    self.imageView = nil;
    
    [self.view addSubview:self.clipMaskView];
    [self.view addSubview:self.imageView];
    [self.view bringSubviewToFront:self.clipMaskView];
    if (self.clipType == WEClipImageMoveBox) {
        self.whiteBox = nil;
        self.hLine1 = nil;
        self.hLine2 = nil;
        self.vLine1 = nil;
        self.vLine2 = nil;
        self.leftTopView = nil;
        self.rightTopView = nil;
        self.leftBottomView = nil;
        self.rightBottomView = nil;
        self.leftView = nil;
        self.rightView = nil;
        self.topView = nil;
        self.bottomView = nil;
        self.clipBox = nil;
        [self.view addSubview:self.clipBox];
    }
}



- (UIImage *)clipImageWithFrame:(CGRect)frame Image:(UIImage *)image{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x = frame.origin.x*scale,y =frame.origin.y*scale,w = frame.size.width*scale,h = frame.size.height*scale;
    //    CGFloat x = frame.origin.x, y =frame.origin.y, w = frame.size.width, h = frame.size.height;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    UIImage* upImage = [self fixOrientation:image];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([upImage CGImage], dianRect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef scale:scale orientation:upImage.imageOrientation];
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    return thumbScale;
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


-(UIView *)topV{
    if(!_topV){
        _topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        _topV.backgroundColor = UIColor.mainBlackColor;
        
        UIButton *backBtn = [UIButton buttonWithType:0];
        backBtn.frame = CGRectMake(6, kStatusBarHeight+2, 40, 40);
        [backBtn setImage:kIMAGE_Name(@"back_left") forState:0];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_topV addSubview:backBtn];
        
        UIView *searchBgv = [[UIView alloc] initWithFrame:CGRectMake(30, kStatusBarHeight+4, kScreenW-60, 36)];
        [_topV addSubview:searchBgv];
        searchBgv.backgroundColor = [UIColor mainBlackColor];
        
        

        
        UILabel *urlL = [searchBgv createLabelTextColor:kWhiteColor font:kBoldFont(17)];
        urlL.frame = CGRectMake(20, 10, searchBgv.width-40, 17);
        urlL.textAlignment = NSTextAlignmentCenter;
        urlL.text = @"Document scanning";
        
       
        
    }
    return _topV;
}
-(void)backAction{
    [playVolume playMusic];

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)save:(UIButton *)saveBtn{
    [playVolume playMusic];

    [UIButton setanimationwithBtn:saveBtn];
    CGRect tempFrame = CGRectZero;
    if (self.clipType == WEClipImageMoveBox) {
        CGFloat bili = self.originalImage.size.width / [UIScreen mainScreen].scale / self.imageView.frame.size.width;
        tempFrame = CGRectMake(self.clipBox.frame.origin.x + ControllSize / 2, self.clipBox.frame.origin.y + ControllSize / 2, self.clipBox.frame.size.width - ControllSize, self.clipBox.frame.size.height - ControllSize);
        tempFrame.origin.x = (tempFrame.origin.x - self.imageView.frame.origin.x) * bili;
        tempFrame.size.width = tempFrame.size.width * bili;
        tempFrame.origin.y = (tempFrame.origin.y - self.imageView.frame.origin.y) * bili;
        tempFrame.size.height = tempFrame.size.height * bili;
    } else {
        tempFrame = CGRectMake(_minX, _minY, _maxX - _minX, _maxY - _minY);
        CGRect imageFrame = [self resetImageView];
        
        CGFloat bili = self.originalImage.size.width / [UIScreen mainScreen].scale / imageFrame.size.width;
        
        tempFrame.origin.x = (tempFrame.origin.x - imageFrame.origin.x) * bili;
        tempFrame.origin.y = (tempFrame.origin.y - imageFrame.origin.y) * bili;
        tempFrame.size.width = tempFrame.size.width * bili;
        tempFrame.size.height = tempFrame.size.height * bili;
    }
    NSLog(@"%@",NSStringFromCGRect(tempFrame));
    UIImage *image = [self clipImageWithFrame:tempFrame Image:self.originalImage];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"保存图片失败" ;
        
    }else{
        
        msg = @"保存图片成功" ;
        // 1.创建UIAlertController
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm Delete"
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIView *view = alertController.view.subviews.firstObject;
        UIView *view1 = view.subviews.firstObject;
        UIView *view2 = view1.subviews.firstObject;


        
        view2.backgroundColor = [UIColor colorWithHexString:@"#1E1E1E" alpha:0.75];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];

           }];


        [alertController addAction:okAction];           // A
        NSString * str1 = @"Save Successful";
          NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:str1];
        [titleText addAttributes:@{NSFontAttributeName:kBoldFont(17),NSForegroundColorAttributeName:kWhiteColor} range:NSMakeRange(0, str1.length)];
          [alertController setValue:titleText forKey:@"attributedTitle"];
     
        [self presentViewController:alertController animated:YES completion:nil];
        
    }

}

-(UIView *)bottomV{
    if(!_bottomV){
        _bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH-kTabBarHeight, kScreenW, kTabBarHeight+30)];
        _bottomV.backgroundColor = [UIColor colorWithHexString:@"#272226"];
        kViewRadius(_bottomV, 15);
        
        UIButton *saveBtn = [UIButton buttonWithType:0];
        saveBtn.frame = CGRectMake(24, 10, kScreenW - 48, 40);
        [saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#8A38F5"]];
        [saveBtn setTitle:@"Crop and Save" forState:0];
        saveBtn.titleLabel.font = kFont(16);
        kViewRadius(saveBtn, 10);
        [_bottomV addSubview:saveBtn];
        [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomV;
}
@end
