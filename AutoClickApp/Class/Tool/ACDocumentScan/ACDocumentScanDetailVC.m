//
//  ACDocumentScanDetailVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/8.
//

#import "ACDocumentScanDetailVC.h"
#import "GKCycleScrollView.h"
#import <VisionKit/VisionKit.h>
#import "NSString+Timerstr.h"

#define kAdapter(w) kScreenW / 750.0f * w

@interface ACDocumentScanDetailVC ()<GKCycleScrollViewDataSource, GKCycleScrollViewDelegate,VNDocumentCameraViewControllerDelegate>
@property (nonatomic, strong) GKCycleScrollView     *cycleScrollView;
@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) VNDocumentCameraViewController* dcVc ;


@end

@implementation ACDocumentScanDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.mainBlackColor;
    [self.view addSubview:self.topV];
    [self.view addSubview:self.cycleScrollView];
    [self.cycleScrollView reloadData];

    UILabel *label = [self.view createLabelFrame:CGRectMake(kScreenW/2-32, kNavBarHeight +8, 64, 30) textColor:kWhiteColor font:kBoldFont(12)];
    label.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    kViewRadius(label, 8);
    label.text = kStringFormat(@"1/%li",self.imageArr.count);
    self.titleL = label;
    label.textAlignment = NSTextAlignmentCenter;
    
    UIButton *addBtn = [UIButton buttonWithType:0];
    addBtn.frame = CGRectMake(kScreenW/2-32, kScreenH-kTabBarHeight-20-64, 64, 64);
    [addBtn setImage:kIMAGE_Name(@"scan_share") forState:0];
    [addBtn setImageEdgeInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"#8A38F5"];
    kViewRadius(addBtn, 32);
    [addBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    UIButton *delbtn = [UIButton buttonWithType:0];
    delbtn.frame = CGRectMake(kScreenW/4-26, kScreenH-kTabBarHeight-20-58, 52, 52);
    [delbtn setImage:kIMAGE_Name(@"scan_del") forState:0];
    [delbtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [delbtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delbtn];
    
    UIButton *delbtn1 = [UIButton buttonWithType:0];
    delbtn1.frame = CGRectMake(kScreenW/4*3-26, kScreenH-kTabBarHeight-20-58, 52, 52);
    [delbtn1 setImage:kIMAGE_Name(@"scan_delete") forState:0];
    [delbtn1 setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [delbtn1 addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delbtn1];
}
-(void)shareAction{
    //[playVolume playMusic];

    
    NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:0];
    for (NSString *path in self.imageArr) {
        NSData *imageData = [NSData dataWithContentsOfFile:path];
        UIImage *imageToShare = [UIImage imageWithData:imageData];
        [activityItems addObject:imageToShare];
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    //分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            [self showMsgWithTitle:@"Share Success"];
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
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
        NSArray *pathArr = [kUserDefaults objectForKey:@"documentScan"];
        NSMutableArray *arr1 = [NSMutableArray arrayWithArray:pathArr];
        [arr1 removeObjectAtIndex:self.indexRow];
        NSArray *arr3 = [NSArray arrayWithArray:arr1];
        [kUserDefaults setObject:arr3 forKey:@"documentScan"];
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
-(void)editAction{
    //[playVolume playMusic];

    if(@available(iOS 13,*)) {
        
        //只有支持的机型才能使用，因此要判断是否支持
        
        if (!VNDocumentCameraViewController.supported) {
            
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
            NSString * str1 = @"This device does not support it";
            NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:str1];
            [titleText addAttributes:@{NSFontAttributeName:kBoldFont(17),NSForegroundColorAttributeName:kWhiteColor} range:NSMakeRange(0, str1.length)];
            [alertController setValue:titleText forKey:@"attributedTitle"];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
            
        }
        
        VNDocumentCameraViewController* dcVc = [[VNDocumentCameraViewController alloc] init];
        
        dcVc.delegate=self;
        self.dcVc = dcVc;
        
        [self presentViewController:dcVc animated:YES completion:nil];
    }
}
-(void)showMsgWithTitle:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIView *view = alertController.view.subviews.firstObject;
    UIView *view1 = view.subviews.firstObject;
    UIView *view2 = view1.subviews.firstObject;


    
    view2.backgroundColor = [UIColor colorWithHexString:@"#1E1E1E" alpha:0.75];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:KLanguage(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        

       }];


    [alertController addAction:okAction];           // A
    NSString * str1 = title;
      NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:str1];
    [titleText addAttributes:@{NSFontAttributeName:kBoldFont(17),NSForegroundColorAttributeName:kWhiteColor} range:NSMakeRange(0, str1.length)];
      [alertController setValue:titleText forKey:@"attributedTitle"];
 
    [self presentViewController:alertController animated:YES completion:nil];
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
        
        UIView *searchBgv = [[UIView alloc] initWithFrame:CGRectMake(50, kStatusBarHeight+4, kScreenW-100, 36)];
        [_topV addSubview:searchBgv];
        searchBgv.backgroundColor = [UIColor mainBlackColor];
        
        

        
        UILabel *urlL = [searchBgv createLabelTextColor:kWhiteColor font:kBoldFont(17)];
        urlL.frame = CGRectMake(20, 10, searchBgv.width-40, 17);
        urlL.textAlignment = NSTextAlignmentCenter;
        urlL.text = self.titleStr;
        

        
    }
    return _topV;
}
-(void)backAction{
    //[playVolume playMusic];

    [self.navigationController popViewControllerAnimated:YES];
}
- (GKCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[GKCycleScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+10, kScreenW, kScreenH-kNavBarHeight-kTabBarHeight-100)];
        _cycleScrollView.dataSource = self;
        _cycleScrollView.delegate = self;
        _cycleScrollView.isInfiniteLoop = NO;
        _cycleScrollView.isChangeAlpha = NO;
        _cycleScrollView.isAutoScroll = NO;
        _cycleScrollView.leftRightMargin = kAdapter(50.0f);
        _cycleScrollView.topBottomMargin = kAdapter(40.0f);
    }
    return _cycleScrollView;
}
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.imageArr.count;
}
#pragma mark - GKCycleScrollViewDelegate
//- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
//    return CGSizeMake(ceilf(kScreenW-100), kScreenH-kNavBarHeight-kTabBarHeight-100);
//}
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return CGSizeMake(ceilf(kAdapter(560.0f)), kAdapter(850.0f));
}
- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
        cell.layer.cornerRadius = 10;
        cell.layer.masksToBounds = YES;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }

    NSString *pathStr = self.imageArr[index];
    NSData *data = [NSData dataWithContentsOfFile:pathStr];
    cell.imageView.image = [UIImage imageWithData:data];
//    cell.imageView.image = kIMAGE_Name(@"122");
    return cell;
}
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index {
    if (cycleScrollView.scrollView.isTracking) return;
    self.titleL.text = kStringFormat(@"%li/%li",(long)index+1,self.imageArr.count);

}
#pragma mark - VNDocumentCameraViewControllerDelegate

- (void)documentCameraViewController:(VNDocumentCameraViewController *)controller didFinishWithScan:(VNDocumentCameraScan *)scan API_AVAILABLE(ios(13)){

    [self.dcVc dismissViewControllerAnimated:YES completion:nil];
    if(scan.pageCount<1){
        return;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.imageArr];
    for(int i = 0; i < [scan pageCount]; i++) {
        UIImage* img = [scan imageOfPageAtIndex:i];
        NSData *data = UIImageJPEGRepresentation(img, 1.0f);
        NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@.png", NSHomeDirectory(),[NSString nowTimeInterval]];
        [data writeToFile:filePath atomically:YES];
        [arr addObject:filePath];
    }
    NSArray *arr2 = [NSArray arrayWithArray:arr];
    NSArray *pathArr = [kUserDefaults objectForKey:@"documentScan"];
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:pathArr];
    [arr1 replaceObjectAtIndex:self.indexRow withObject:arr2];
    NSArray *arr3 = [NSArray arrayWithArray:arr1];
    [kUserDefaults setObject:arr3 forKey:@"documentScan"];
    self.imageArr = arr2;
    [self.cycleScrollView reloadData];
    [self.cycleScrollView scrollToCellAtIndex:0 animated:NO];
 
    self.titleL.text = kStringFormat(@"1/%li",self.imageArr.count);
    if(self.refreshBlock){
        self.refreshBlock();
    }


}

- (void)documentCameraViewControllerDidCancel:(VNDocumentCameraViewController *)controller API_AVAILABLE(ios(13)){
    [self.dcVc dismissViewControllerAnimated:YES completion:nil];


}

- (void)documentCameraViewController:(VNDocumentCameraViewController *)controller didFailWithError:(NSError *)error API_AVAILABLE(ios(13)){
    [self.dcVc dismissViewControllerAnimated:YES completion:nil];



}
@end
