//
//  ACGridLayoutVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/9.
//

#import "ACGridLayoutVC.h"

@interface ACGridLayoutVC ()
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic,strong) UIView* hLine1;
@property (nonatomic,strong) UIView* hLine2;
@property (nonatomic,strong) UIView* vLine1;
@property (nonatomic,strong) UIView* vLine2;
@property (nonatomic, assign) NSInteger num;
@end

@implementation ACGridLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.mainBlackColor;

    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(6, kStatusBarHeight+2, 40, 40);
    [backBtn setImage:kIMAGE_Name(@"back_left") forState:0];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [self.view addSubview:self.bottomV];
    
    CGFloat height = kScreenH- kTabBarHeight-20;
    if(!kISiPhoneXX){
        height -=20;
    }
    CGFloat imageW = self.oriImage.size.width;
    CGFloat imageH = self.oriImage.size.height;
    UIImageView *imageV = [[UIImageView alloc] initWithImage:self.oriImage];
    if (imageW/imageH>kScreenW/height) { //上下留白
        CGFloat imageVH = kScreenW*imageH/imageW;
        
        imageV.frame = CGRectMake(0, 0, kScreenW, imageVH);
        imageV.centerY = height/2;
    }else{
        CGFloat imageVW =height *imageW/imageH;
        imageV.frame = CGRectMake(kScreenW/2-imageVW/2, 10, imageVW, height);
        
    }
    [self.view addSubview:imageV];
    [self.view sendSubviewToBack:imageV];
    
    self.hLine1 = [[UIView alloc] init];
    self.hLine1.backgroundColor = [UIColor whiteColor];
    [imageV addSubview:self.hLine1];
    
    self.hLine2 = [[UIView alloc] init];
    self.hLine2.backgroundColor = [UIColor whiteColor];
    [imageV addSubview:self.hLine2];
    
    self.vLine1 = [[UIView alloc] init];
    self.vLine1.backgroundColor = [UIColor whiteColor];
    [imageV addSubview:self.vLine1];
    
    self.vLine2 = [[UIView alloc] init];
    self.vLine2.backgroundColor = [UIColor whiteColor];
    [imageV addSubview:self.vLine2];
    CGFloat linew = 6;
    CGFloat itemW = (imageV.width-12)/3;
    CGFloat itemH = (imageV.height-12)/3;

    self.hLine1.frame = CGRectMake(0, itemH, imageV.width, linew);
    self.hLine2.frame = CGRectMake(0, itemH*2+linew, imageV.width, linew);
    
    self.vLine1.frame = CGRectMake(itemW, 0, linew, imageV.height);;
    self.vLine2.frame = CGRectMake(itemW*2+linew, 0, linew, imageV.height);;
}

-(void)backAction{
    //[playVolume playMusic];
    AppDelegate *appde = kAppDelegate;
    if (appde.hasShowStar == false) {
        [SKStoreReviewController requestReview];
        appde.hasShowStar = true;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIView *)bottomV{
    if(!_bottomV){
        _bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH-kTabBarHeight, kScreenW, kTabBarHeight+30)];
        _bottomV.backgroundColor = [UIColor colorWithHexString:@"#272226"];
        kViewRadius(_bottomV, 15);
        
        UIButton *saveBtn = [UIButton buttonWithType:0];
        saveBtn.frame = CGRectMake(24, 20, kScreenW - 48, 40);
        [saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#8A38F5"]];
        [saveBtn setTitle:KLanguage(@"Split and save the image") forState:0];
        saveBtn.titleLabel.font = kFont(16);
        kViewRadius(saveBtn, 10);
        [_bottomV addSubview:saveBtn];
        [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        if(!kISiPhoneXX){
            _bottomV.frame = CGRectMake(0, kScreenH-kTabBarHeight-30, kScreenW, kTabBarHeight+60);
        }
    }
    return _bottomV;
}
-(void)save:(UIButton *)saveBtn{
    _num = 0;
    [UIButton setanimationwithBtn:saveBtn];
    //[playVolume playMusic];

    NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i =0; i<9; i++) {
        NSInteger row = i%3;
        NSInteger column = i/3;
        CGFloat height = self.oriImage.size.height/3;
        CGFloat width = self.oriImage.size.width/3;
        
        UIImage *image = [self croppIngimageByImageName:self.oriImage toRect:CGRectMake(width*row, height*column, width, height)];
        [imageArr addObject:image];

    }
//    NSArray *arr =  [[imageArr reverseObjectEnumerator] allObjects];
    for (int i=0; i<9; i++) {
        UIImage *image  = imageArr[i];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    _num++;
    
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"保存图片失败" ;
        
    }else{
        
        msg = @"保存图片成功" ;
        if(_num==9){
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
            NSString * str1 = KLanguage(@"Save successful");
              NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:str1];
            [titleText addAttributes:@{NSFontAttributeName:kBoldFont(17),NSForegroundColorAttributeName:kWhiteColor} range:NSMakeRange(0, str1.length)];
              [alertController setValue:titleText forKey:@"attributedTitle"];
         
            [self presentViewController:alertController animated:YES completion:nil];
        }
        // 1.创建UIAlertController
        
        
    }

}
- (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}
@end
