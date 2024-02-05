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
    
    self.userView = [[ACAppClickUserView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kNavBarHeight - kTabBarHeight)];
    __weak typeof(self) weakSelf = self;
    self.userView.clickedBlock = ^{
        [MBProgressHUD showTipMessageInView:KLanguage(@"Loading...") timer:100];
        [[XYStore defaultStore] addPayment:@"autoclicker_onapp"
                                   success:^(SKPaymentTransaction *transaction)
        {
            [kUserDefaults setBool:true forKey:@"PayVideo"];
            weakSelf.userView.hidden = true;
            [MBProgressHUD hideHUD];
            //用户取消了交易
            [MBProgressHUD showSuccessMessage:@"Success"];
            
        } failure:^(SKPaymentTransaction *transaction, NSError *error) {
            [MBProgressHUD hideHUD];
        }];
       
    };
    [self.view addSubview:self.userView];
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
