//
//  ACPrivacyPhotoDetailVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/5.
//

#import "ACPrivacyPhotoDetailVC.h"
#import <AVKit/AVKit.h>
@interface ACPrivacyPhotoDetailVC ()
@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UIView *bottomV;

@end

@implementation ACPrivacyPhotoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.mainBlackColor;
    [self.view addSubview:self.topV];
    [self.view addSubview:self.bottomV];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, kNavBarHeight + 10, kScreenW-20, kScreenH-kNavBarHeight-kTabBarHeight-20)];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    kViewRadius(imageV, 1);
    [self.view addSubview:imageV];
    /// 网络地址

    if(self.type==2){
        NSData *data = [NSData dataWithContentsOfFile:self.pathStr];
        imageV.image = [UIImage imageWithData:data];
        imageV.userInteractionEnabled = YES;
        UIButton *playBtn = [UIButton buttonWithType:0];
        [playBtn setImage:kIMAGE_Name(@"paly_video") forState:0];
        playBtn.frame = CGRectMake(0, 0, 60, 60);
        playBtn.center = CGPointMake(imageV.centerX, imageV.centerY-kNavBarHeight-20);
        [imageV addSubview:playBtn];
        [playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];

    }else{
        NSData *imageData = [NSData dataWithContentsOfFile:self.pathStr];
        imageV.image = [UIImage imageWithData:imageData];

    }
}
-(UIImage *)getFirstImage{
    /// 本地文件
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.pathStr] options:opts];
    NSParameterAssert(asset);//断言
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    NSError *error = nil;
    CGImageRef thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&error];
    if( error ) {
        NSLog(@"%@", error );
    }
    if(thumbnailImageRef) {
        return  [[UIImage alloc]initWithCGImage:thumbnailImageRef];
    }
    return nil;
}
-(void)playVideo{
    if(self.type==1){
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
        
        NSURL *movieUrl = [NSURL fileURLWithPath:self.pathStr];

        AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:movieUrl];
        playerViewController.player = avPlayer;
        [self presentViewController:playerViewController animated:YES completion:nil];
        return;
    }
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[self.videoStr] options:nil];
    PHAsset *asset = fetchResult.firstObject;

    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
            AVURLAsset* myAsset = (AVURLAsset*)avasset;
        
            if (myAsset) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
                    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:myAsset.URL];
                    playerViewController.player = avPlayer;
                    [self presentViewController:playerViewController animated:YES completion:nil];
                    [avPlayer play];
                });
                
               
            }
        }];

}
-(UIView *)topV{
    if(!_topV){
        _topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        _topV.backgroundColor = UIColor.mainBlackColor;
        
        UIButton *backBtn = [UIButton buttonWithType:0];
        backBtn.frame = CGRectMake(6, kStatusBarHeight+2, 40, 40);
        [backBtn setImage:kIMAGE_Name(@"album_back") forState:0];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_topV addSubview:backBtn];
        
        UIView *searchBgv = [[UIView alloc] initWithFrame:CGRectMake(50, kStatusBarHeight+4, kScreenW-100, 36)];
        [_topV addSubview:searchBgv];
        searchBgv.backgroundColor = [UIColor mainBlackColor];
        
        

        
        UILabel *urlL = [searchBgv createLabelTextColor:kWhiteColor font:kBoldFont(17)];
        urlL.frame = CGRectMake(20, 10, searchBgv.width-40, 17);
        urlL.textAlignment = NSTextAlignmentCenter;

        [_topV createLineFrame:CGRectMake(0, kNavBarHeight-1, kScreenW, 1) lineColor:kRGB(32, 32, 32)];

    }
    return _topV;
}
-(UIView *)bottomV{
    if(!_bottomV){
        _bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH-kTabBarHeight, kScreenW, kTabBarHeight)];
        _bottomV.backgroundColor = UIColor.mainBlackColor;
        
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(kScreenW/4-20, 0, 40, 64);
        [btn setImage:kIMAGE_Name(@"delete") forState:0];
        [btn setTitle:KLanguage(@"Delete") forState:0];
        [btn setTitleColor:kWhiteColor forState:0];
        btn.titleLabel.font = kMediunFont(10);
        [btn setImagePositionWithType:SSImagePositionTypeTop spacing:5];
        [btn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomV addSubview:btn];
        
        UIButton *btn1 = [UIButton buttonWithType:0];
        btn1.frame = CGRectMake(kScreenW*3/4-20, 0, 40, 64);
        [btn1 setImage:kIMAGE_Name(@"share") forState:0];
        [btn1 setTitle:KLanguage(@"Export") forState:0];
        [btn1 setTitleColor:kWhiteColor forState:0];
        btn1.titleLabel.font = kMediunFont(10);
        [btn1 setImagePositionWithType:SSImagePositionTypeTop spacing:5];
        [btn1 addTarget:self action:@selector(shareTItle) forControlEvents:UIControlEventTouchUpInside];
        [_bottomV addSubview:btn1];
    }
    return _bottomV;
}
-(void)deleteAction{
    //[playVolume playMusic];

        // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm Delete"
                                                                             message:@"Are you sure you want to delete"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIView *view = alertController.view.subviews.firstObject;
    UIView *view1 = view.subviews.firstObject;
    UIView *view2 = view1.subviews.firstObject;


    
    view2.backgroundColor = [UIColor colorWithHexString:@"#1E1E1E" alpha:0.75];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:KLanguage(@"Delete popup Dialog") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *arr = [kUserDefaults objectForKey:@"privacyAlbum"];
        
        NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:0];
        [arr1 addObjectsFromArray:arr];
        for (int i =0;i<arr.count;i++) {
            NSDictionary *dic = arr[i];
            NSDictionary *dic1;
            if ( [dic intSafeForKey:@"Id"]==self.ID) {
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithCapacity:0];
                NSArray *arr3 = [dic arraySafeForKey:@"content"];
                NSMutableArray *arr2 = [NSMutableArray arrayWithArray:arr3];
                [arr2 removeObject:self.pathStr];
                [mutDic setObject:arr2 forKey:@"content"];
                [mutDic setObject:@(self.ID) forKey:@"Id"];
                [mutDic setObject:dic[@"name"] forKey:@"name"];
                [mutDic setObject:@(self.type) forKey:@"type"];

                dic1 = [NSDictionary dictionaryWithDictionary:mutDic];
                [arr1 replaceObjectAtIndex:i withObject:dic1];
                break;
            }
        }
        NSArray *arr2 = [NSArray arrayWithArray:arr1];
        [kUserDefaults setObject:arr2 forKey:@"privacyAlbum"];
        if(self.refreshBlock){
            self.refreshBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];

       }];
       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KLanguage(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           NSLog(@"Cancel Action");
       }];
//    [okAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
//    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
       [alertController addAction:cancelAction];       // B
        [alertController addAction:okAction];           // A

    // 使用富文本来改变alert的title字体大小和颜色
    NSString * str1 = KLanguage(@"Confirm Delete");
      NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:str1];
    [titleText addAttributes:@{NSFontAttributeName:kBoldFont(17),NSForegroundColorAttributeName:kWhiteColor} range:NSMakeRange(0, str1.length)];
      [alertController setValue:titleText forKey:@"attributedTitle"];
      
      // 使用富文本来改变alert的message字体大小和颜色
      // NSMakeRange(0, 2) 代表:从0位置开始 两个字符
    NSString * str = KLanguage(@"Are you sure you want to delete");
      NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:str];
    [messageText addAttributes:@{NSFontAttributeName:kFont(13),NSForegroundColorAttributeName:kWhiteColor} range:NSMakeRange(0, str.length)];
      [alertController setValue:messageText forKey:@"attributedMessage"];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)shareAction{
    
}
-(void)backAction{
    //[playVolume playMusic];

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)shareTItle{
    //[playVolume playMusic];

    //分享的标题
//    NSString *textToShare = @"卡通相机";
    //分享的图片
    NSData *imageData = [NSData dataWithContentsOfFile:self.pathStr];
    UIImage *imageToShare = [UIImage imageWithData:imageData];
    //分享的url
    //    NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];
    
    NSArray *activityItems = @[imageToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    //分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
}

@end
