//
//  ACAppClickerViewController.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/27.
//

#import "ACAppClickerViewController.h"
#import "ACVideoListItem.h"
#import <AVKit/AVKit.h>
#import "ACSettingVC.h"
#import "ACAppClickUserView.h"
#import "PayCenter.h"
#import <XYIAPKit.h>
#import "WMDragView.h"

@interface ACAppClickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, strong) NSArray *videoArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UIButton *vipBtn;
@property (nonatomic, strong) ACAppClickUserView *userView;

@end

@implementation ACAppClickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.mainBlackColor;
    self.videoArr = @[@"english_video",@"chinese_video",@"de_video",@"de_video"];
    self.titleArr = @[@"English subtitles",@"Chinese subtitles",@"German subtitles",@"Portuguese subtitles"];
    [self creatVipUI];
    
    self.userView = [[ACAppClickUserView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight - kTabBarHeight)];
    __weak typeof(self) weakSelf = self;
    self.userView.clickedBlock = ^{
       
        [weakSelf clickedAction];
       
    };
    [self.view addSubview:self.userView];
    [self setDragView];
    
}
//已付费用户UI
-(void)creatVipUI{
    
    [self setNav];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.lineV.hidden = NO;
    self.vipBtn.hidden = [vipTool isVip];
    self.userView.hidden = false;
    if ([vipTool isVip] || [kUserDefaults boolForKey:@"PayVideo"]) {
        self.userView.hidden = true;
    }


}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.lineV.hidden = YES;


}
-(void)setDragView{
//    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW , self.userView.height - 20 - kNavBarHeight)];
//    bgview.backgroundColor = kClearColor;
//    [self.userView addSubview:bgview];
    
    WMDragView *view = [[WMDragView alloc] init];
    view.frame = CGRectMake(24,72 ,44,196);
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithRed:71.00000336766243/255.0 green:73.00000324845314/255.0 blue:80.00000283122063/255.0 alpha:1.0].CGColor;

    view.layer.backgroundColor = [UIColor colorWithRed:24/255.0 green:26/255.0 blue:32/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 8;
    [self.userView addSubview:view];

    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 20, 20)];
    imageV.image = kIMAGE_Name(@"容器099");
    [view addSubview:imageV];
    
    UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(12, 52, 20, 20)];
    imageV1.image = kIMAGE_Name(@"容器1011");
    [view addSubview:imageV1];
    
    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(12, 88, 20, 20)];
    imageV2.image = kIMAGE_Name(@"容器1012");
    [view addSubview:imageV2];
    
    UIImageView *imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(12, 124, 20, 20)];
    imageV3.image = kIMAGE_Name(@"容器1013");
    [view addSubview:imageV3];
    
    UIImageView *imageV4 = [[UIImageView alloc] initWithFrame:CGRectMake(12, 160, 20, 20)];
    imageV4.image = kIMAGE_Name(@"容器1014");
    [view addSubview:imageV4];
}
-(void)clickedAction{
    //[playVolume playMusic];

    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLanguage(@"Unlock this feature")
                                                                             message:KLanguage(@"Unlock the use of automatic clicks in other apps!")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIView *view = alertController.view.subviews.firstObject;
    UIView *view1 = view.subviews.firstObject;
    UIView *view2 = view1.subviews.firstObject;



    view2.backgroundColor = [UIColor colorWithHexString:@"#1E1E1E" alpha:0.75];
    NSString *priceL = @"$1.99";
    NSArray *arr = [kUserDefaults objectForKey:@"productInfoDefaultsKey"];
    if (k_isValidArray(arr) && arr.count == 3) {
        NSDictionary *dic = arr[0];
        priceL = dic[@"finalPrice"];
    }
    __weak typeof(self) weakSelf = self;

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:priceL style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showTipMessageInView:KLanguage(@"Loading...") timer:100];
        [[XYStore defaultStore] addPayment:@"autoclicker_onapp"
                                   success:^(SKPaymentTransaction *transaction)
        {
            [kUserDefaults setBool:true forKey:@"PayVideo"];
            weakSelf.userView.hidden = true;
            [MBProgressHUD hideHUD];
            //用户取消了交易
            [MBProgressHUD showSuccessMessage:KLanguage(@"Purchase successful")];
            
        } failure:^(SKPaymentTransaction *transaction, NSError *error) {
            [MBProgressHUD hideHUD];
            if(transaction.error.code != SKErrorPaymentCancelled) {
                NSLog(@"111-%li",transaction.error.code);
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 在主线程上执行的代码
                    ///购买失败
                    [MBProgressHUD showErrorMessage:KLanguage(@"Failed purchase")];

                });


            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    //用户取消了交易
                    [MBProgressHUD showErrorMessage:KLanguage(@"Cancel purchase")];

                });


            }
        }];
      
       }];
       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KLanguage(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       }];
 
    [alertController addAction:cancelAction];       // B

    [alertController addAction:okAction];           // A

    // 使用富文本来改变alert的title字体大小和颜色
    NSString * str1 = KLanguage(@"Unlock this feature");
      NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:str1];
    [titleText addAttributes:@{NSFontAttributeName:kBoldFont(17),NSForegroundColorAttributeName:[UIColor systemBlueColor]} range:NSMakeRange(0, str1.length)];
      [alertController setValue:titleText forKey:@"attributedTitle"];
      
      // 使用富文本来改变alert的message字体大小和颜色
      // NSMakeRange(0, 2) 代表:从0位置开始 两个字符
    NSString * str = KLanguage(@"Unlock the use of automatic clicks in other apps!");
      NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:str];
    [messageText addAttributes:@{NSFontAttributeName:kFont(13),NSForegroundColorAttributeName:[UIColor systemBlueColor]} range:NSMakeRange(0, str.length)];
      [alertController setValue:messageText forKey:@"attributedMessage"];


    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)setNav{
    
    UILabel *label = [self.navigationController.navigationBar createLabelFrame:CGRectMake(10, 10, 280, 24) textColor:UIColor.whiteColor font:kBoldFont(24)];
    label.text = KLanguage(@"auto clicker") ;
    
    UIButton *setBtn = [UIButton buttonWithType:0];
    setBtn.frame = CGRectMake(kScreenW-45, 7, 34, 34);
    [setBtn setImage:kIMAGE_Name(@"set_icon") forState:0];
    [self.navigationController.navigationBar addSubview:setBtn];
    [setBtn addTarget:self action:@selector(setClicked) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.lineV = [self.navigationController.navigationBar createLineFrame:CGRectMake(0, 43, kScreenW, 0.5) lineColor:kRGB(32, 32, 32)];
    UIButton *vipBtn = [UIButton buttonWithType:0];
    vipBtn.frame = CGRectMake(kScreenW-45 *2, 7, 34, 34);
    [vipBtn setImage:kIMAGE_Name(@"svp") forState:0];
    [self.navigationController.navigationBar addSubview:vipBtn];
    [vipBtn addTarget:self action:@selector(vipBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [vipBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.vipBtn = vipBtn;

    [self.view addSubview:self.collectionV];
}
-(void)vipBtnAction{
    ACPayTwoViewController *vc = [ACPayTwoViewController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.reloadVip = ^{
        self.vipBtn.hidden = [vipTool isVip];
        self.userView.hidden = [vipTool isVip];
    };
    [self presentViewController:vc animated:YES completion:nil];
}
-(UICollectionView *)collectionV{
    if(!_collectionV){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenW-16*3)/2;
        layout.itemSize = CGSizeMake(itemW, itemW*96/166+30);
        
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+10, kScreenW, kScreenH-kTabBarHeight-kNavBarHeight-20) collectionViewLayout:layout];
        _collectionV.delegate = self;
        _collectionV.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _collectionV.backgroundColor = UIColor.mainBlackColor;
        _collectionV.scrollEnabled = false;
        _collectionV.showsVerticalScrollIndicator = false;
        _collectionV.showsHorizontalScrollIndicator = false;
        _collectionV.dataSource = self;
        [_collectionV registerNib:[UINib nibWithNibName:@"ACVideoListItem" bundle:nil] forCellWithReuseIdentifier:@"ACVideoListItem"];

        
    }
    return _collectionV;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.videoArr.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ACVideoListItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"ACVideoListItem" forIndexPath:indexPath];
    item.videoTitle.text = KLanguage(self.titleArr[indexPath.row]);
    item.videoImage.image = [self xy_getVideoThumbnail:self.videoArr[indexPath.row]];
    return item;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:self.videoArr[indexPath.row] ofType:@"mp4"];
    NSURL *movieUrl = [NSURL fileURLWithPath:path];

    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:movieUrl];
    playerViewController.player = avPlayer;
    [self presentViewController:playerViewController animated:YES completion:nil];
    [avPlayer play];
    //[playVolume playMusic];


}
//设置
-(void)setClicked{
    ACSettingVC *pushVC = [[ACSettingVC  alloc] init];
    pushVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pushVC animated:YES];
}
- (UIImage *)xy_getVideoThumbnail:(NSString *)filePath
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filePath ofType:@"mp4"];

    NSURL *sourceURL = [NSURL fileURLWithPath:path];
    AVAsset *asset = [AVAsset assetWithURL:sourceURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(0, 1);
    NSError *error;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:&error];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    return thumbnail;
}
@end
