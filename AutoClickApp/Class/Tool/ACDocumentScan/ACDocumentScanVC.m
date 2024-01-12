//
//  ACDocumentScanVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/3.
//

#import "ACDocumentScanVC.h"
#import <VisionKit/VisionKit.h>
#import "NSString+Timerstr.h"
#import "ACDocumentScanItem.h"
#import "ACDocumentScanDetailVC.h"

@interface ACDocumentScanVC ()<VNDocumentCameraViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) VNDocumentCameraViewController* dcVc ;

@property (nonatomic, strong) NSMutableArray *dataarr;

@end


@implementation ACDocumentScanVC

-(NSMutableArray *)dataarr{LazyMutableArray(_dataarr)}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.mainBlackColor;
    [self.view addSubview:self.topV];
    [self.view addSubview:self.emptyView];
    NSArray *pathArr = [kUserDefaults objectForKey:@"documentScan"];
    [self.dataarr addObjectsFromArray:pathArr];
    self.emptyView.hidden = self.dataarr.count>0;
    [self.view addSubview:self.collectionV];
    self.collectionV.hidden = self.dataarr.count==0;

    UIButton *addBtn = [UIButton buttonWithType:0];
    addBtn.frame = CGRectMake(kScreenW-64-48, kScreenH-kTabBarHeight-20-48, 64, 64);
    [addBtn setImage:kIMAGE_Name(@"scan_add") forState:0];
    [addBtn setImageEdgeInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"#8A38F5"];
    kViewRadius(addBtn, 32);
    [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}
-(void)refreshData{
    [self.dataarr removeAllObjects];
    NSArray *pathArr = [kUserDefaults objectForKey:@"documentScan"];
    [self.dataarr addObjectsFromArray:pathArr];
    [self.collectionV reloadData];
    self.emptyView.hidden = self.dataarr.count>0;
    self.collectionV.hidden = self.dataarr.count==0;

}
-(UICollectionView *)collectionV{
    if(!_collectionV){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenW-16*2-10)/2;
        layout.itemSize = CGSizeMake(itemW, itemW*220/166+40);
        
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+10, kScreenW, kScreenH-kNavBarHeight-20) collectionViewLayout:layout];
        _collectionV.delegate = self;
        _collectionV.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _collectionV.backgroundColor = UIColor.mainBlackColor;
        _collectionV.showsVerticalScrollIndicator = false;
        _collectionV.showsHorizontalScrollIndicator = false;
        _collectionV.dataSource = self;
        [_collectionV registerNib:[UINib nibWithNibName:@"ACDocumentScanItem" bundle:nil] forCellWithReuseIdentifier:@"ACDocumentScanItem"];

        
    }
    return _collectionV;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataarr.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ACDocumentScanItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"ACDocumentScanItem" forIndexPath:indexPath];
    NSString *pathStr = self.dataarr[indexPath.row][0];
    NSData *data = [NSData dataWithContentsOfFile:pathStr];
    item.mainimageV.image = [UIImage imageWithData:data];
    NSString *time = [pathStr componentsSeparatedByString:@"/"].lastObject;
    NSString *tim1 = [time componentsSeparatedByString:@"."].firstObject;
    item.nameL.text = tim1;
    item.titleL.text = [NSString timeWithYearMonthDayCountDown:tim1];
    return item;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ACDocumentScanDetailVC *pushVC = [[ACDocumentScanDetailVC  alloc] init];
    pushVC.imageArr = self.dataarr[indexPath.row];
    pushVC.indexRow = indexPath.row;
    pushVC.refreshBlock = ^{
        [self refreshData];
    };
    [self.navigationController pushViewController:pushVC animated:YES];
    //[playVolume playMusic];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];

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
        urlL.text = KLanguage(@"Document scanning");
        
        [_topV createLineFrame:CGRectMake(0, kNavBarHeight-1, kScreenW, 1) lineColor:kRGB(32, 32, 32)];

        
    }
    return _topV;
}
-(UIView *)emptyView{
    if(!_emptyView){
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight +126, kScreenW, 90)];
        _emptyView.backgroundColor = UIColor.mainBlackColor;
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW/2-27, 0, 54, 54)];
        imageV.image = kIMAGE_Name(@"scan_empty");
        [_emptyView addSubview:imageV];
        
        UILabel *label = [_emptyView createLabelFrame:CGRectMake(0, 68, kScreenW, 17) textColor:kWhiteColor font:kFont(12)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = KLanguage(@"No files available");
    }
    return _emptyView;
}
-(void)backAction{
    //[playVolume playMusic];

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addAction:(UIButton *)addBtn{
    //[playVolume playMusic];

    [UIButton setanimationwithBtn:addBtn];
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
#pragma mark - VNDocumentCameraViewControllerDelegate

- (void)documentCameraViewController:(VNDocumentCameraViewController *)controller didFinishWithScan:(VNDocumentCameraScan *)scan API_AVAILABLE(ios(13)){

    [self.dcVc dismissViewControllerAnimated:YES completion:nil];
    if(scan.pageCount<1){
        return;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
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
    [arr1 addObject:arr2];
    NSArray *arr3 = [NSArray arrayWithArray:arr1];
    [kUserDefaults setObject:arr3 forKey:@"documentScan"];
    [self refreshData];
 
    


}

- (void)documentCameraViewControllerDidCancel:(VNDocumentCameraViewController *)controller API_AVAILABLE(ios(13)){
    [self.dcVc dismissViewControllerAnimated:YES completion:nil];

}

- (void)documentCameraViewController:(VNDocumentCameraViewController *)controller didFailWithError:(NSError *)error API_AVAILABLE(ios(13)){
    [self.dcVc dismissViewControllerAnimated:YES completion:nil];



}
/*

//    [self getToken];
//
//    return;
    NSString *tokenStr = @"24.0d221f3a0a73f5a457063e28fc43834c.2592000.1701593223.282335-42295202";
    NSString *url = kStringFormat(@"https://aip.baidubce.com/rest/2.0/ocr/v1/doc_crop_enhance?access_token=%@",tokenStr);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
      cachePolicy:NSURLRequestUseProtocolCachePolicy
      timeoutInterval:10.0];
    NSDictionary *headers = @{
      @"Content-Type": @"application/json"
    };
    UIImage *originImage = [UIImage imageNamed:@"32nip.jpg"];
    NSData *data = UIImageJPEGRepresentation(originImage, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [request setAllHTTPHeaderFields:headers];

    NSDictionary *dic = @{@"image":encodedImageStr};
    NSData * dataD = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:dataD];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error) {
        NSLog(@"%@", error);
      } else {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        NSLog(@"%@",responseDictionary);
        dispatch_semaphore_signal(sema);
      }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    
}
-(void)getToken{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=udONz99IdkLQtXTU2RAw8IhW&client_secret=cuibvhV5ehrXAwbwRx2i5UbsV6s88Dsu"]
      cachePolicy:NSURLRequestUseProtocolCachePolicy
      timeoutInterval:10.0];
    NSDictionary *headers = @{
      @"Content-Type": @"application/x-www-form-urlencoded"
    };
    [request setAllHTTPHeaderFields:headers];

    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error) {
        NSLog(@"%@", error);
      } else {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        NSLog(@"%@",responseDictionary);
        dispatch_semaphore_signal(sema);
      }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

}
 */
@end
