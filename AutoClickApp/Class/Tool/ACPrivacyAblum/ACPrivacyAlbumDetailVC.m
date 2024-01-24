//
//  ACPrivacyAlbumDetailVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/4.
//

#import "ACPrivacyAlbumDetailVC.h"
#import "ACPrivacyAlbumDetailItem.h"
#import "NSString+Timerstr.h"
#import "ZWFileManager.h"
#import "ACPrivacyPhotoDetailVC.h"
#import "popView.h"
#import "PopTableListView.h"

@interface ACPrivacyAlbumDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *dataArrloc;

@property (nonatomic ,strong) PopTableListView *popListView;
@property (nonatomic, strong) UITextField *renameTF;

@property (nonatomic, strong) UILabel *titleL;

@end


@implementation ACPrivacyAlbumDetailVC
-(NSMutableArray *)dataArr{LazyMutableArray(_dataArr)}
-(NSMutableArray *)dataArrloc{LazyMutableArray(_dataArrloc)}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.mainBlackColor;
    [self.view addSubview:self.topV];
    
    UIImageView *emptyImageV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW/2-39, kNavBarHeight+74, 78, 78)];
    emptyImageV.image = kIMAGE_Name(@"album_empty");
    if(self.type==2){
        emptyImageV.image = kIMAGE_Name(@"video_empty");

    }
    [self.view addSubview:emptyImageV];
    UILabel *label = [self.view createLabelFrame:CGRectMake(20, emptyImageV.maxY+20, kScreenW-40, 20) textColor:kWhiteColor font:kFont(16)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = KLanguage(@"No pictures yet");

    [self.view addSubview:self.collectionV];
    [self refreshData];
    
    UIButton *addBtn = [UIButton buttonWithType:0];
    addBtn.frame = CGRectMake(0, kScreenH-kTabBarHeight, kScreenW, 64);
    addBtn.backgroundColor = UIColor.mainBlackColor;
    [addBtn setImage:kIMAGE_Name(@"add-line") forState:0];
    [addBtn setTitle:KLanguage(@"Add photo") forState:0];
    [addBtn setTitleColor:[UIColor colorWithHexString:@"#007AFF"] forState:0];
    addBtn.titleLabel.font = kMediunFont(18);
    [addBtn addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    if(self.type==2){
        label.text = KLanguage(@"No video yet");
        [addBtn setTitle:KLanguage(@"Add video") forState:0];

    }
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
-(void)refreshData{
    NSArray *arr = [kUserDefaults objectForKey:@"privacyAlbum"];
    
    [self.dataArr removeAllObjects];
    [self.dataArrloc removeAllObjects];
    for (NSDictionary *dic in arr) {
        if ( [dic intSafeForKey:@"Id"]==self.ID) {
            [self.dataArr addObjectsFromArray:[dic arraySafeForKey:@"content"]];
            [self.dataArrloc addObjectsFromArray:[dic arraySafeForKey:@"contentasset"]];

            break;
        }
    }
    if(self.dataArr.count==0){
        self.collectionV.hidden = YES;
    }
    [self.collectionV reloadData];
}
-(UICollectionView *)collectionV{
    if(!_collectionV){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenW-16*3)/2;
        layout.itemSize = CGSizeMake(itemW, itemW);
        
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+10, kScreenW, kScreenH-kTabBarHeight-kNavBarHeight-20) collectionViewLayout:layout];
        _collectionV.delegate = self;
        _collectionV.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _collectionV.backgroundColor = UIColor.mainBlackColor;
        _collectionV.showsVerticalScrollIndicator = false;
        _collectionV.showsHorizontalScrollIndicator = false;
        _collectionV.dataSource = self;
        [_collectionV registerNib:[UINib nibWithNibName:@"ACPrivacyAlbumDetailItem" bundle:nil] forCellWithReuseIdentifier:@"ACPrivacyAlbumDetailItem"];

        
    }
    return _collectionV;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ACPrivacyAlbumDetailItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"ACPrivacyAlbumDetailItem" forIndexPath:indexPath];
    
    NSString *pathStr = self.dataArr[indexPath.row];
    NSData *data = [NSData dataWithContentsOfFile:pathStr];
    item.photoImageV.image = [UIImage imageWithData:data];
    item.playImageV.hidden = self.type==1;

    return item;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ACPrivacyPhotoDetailVC *pushVC = [[ACPrivacyPhotoDetailVC  alloc] init];
    NSString *pathStr = self.dataArr[indexPath.row];
    if(self.type==2){
        pushVC.videoStr = self.dataArrloc[indexPath.row];
    }
    pushVC.pathStr = pathStr;
    pushVC.refreshBlock = ^{
        [self refreshData];
    };
    pushVC.type = self.type;
    pushVC.ID = self.ID;
    [self.navigationController pushViewController:pushVC animated:YES];
    //[playVolume playMusic];

}
- (PopTableListView *)popListView{
    if (_popListView == nil) {
        __weak typeof(self) weakSelf = self;
        _popListView = [[PopTableListView alloc] initWithTitles:@[KLanguage(@"Rename"),KLanguage(@"Delete")] imgNames:@[@"rename_icon",@"delete"]];
        _popListView.backgroundColor = [UIColor colorWithHexString:@"#272226"];
        _popListView.layer.cornerRadius = 10;
        _popListView.selectTitleBlock = ^(NSInteger index) {
            [PopView hidenPopView];
            if(index==0){
                [weakSelf renameAction];
            }else if(index == 1){
                [weakSelf deleteAction];
            }
        };
    }
    return _popListView;
}
//重命名
-(void)renameAction{
    //[playVolume playMusic];

    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLanguage(@"Delete")
                                                                             message:KLanguage(@"Are you sure you want to delete")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIView *view = alertController.view.subviews.firstObject;
    UIView *view1 = view.subviews.firstObject;
    UIView *view2 = view1.subviews.firstObject;



    view2.backgroundColor = [UIColor colorWithHexString:@"#1E1E1E" alpha:0.75];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:KLanguage(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!self.renameTF||self.renameTF.text.length==0) {
            return;
        }
        self.titleL.text = self.renameTF.text;
        NSArray *arr = [kUserDefaults objectForKey:@"privacyAlbum"];
        
        NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:0];
        [arr1 addObjectsFromArray:arr];
        for (int i =0;i<arr.count;i++) {
            NSDictionary *dic = arr[i];
            NSDictionary *dic1;
            if ( [dic intSafeForKey:@"Id"]==self.ID) {
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithCapacity:0];
                NSArray *arr3 = [dic arraySafeForKey:@"content"];
               
                [mutDic setObject:arr3 forKey:@"content"];
                [mutDic setObject:@(self.ID) forKey:@"Id"];
                [mutDic setObject:self.renameTF.text forKey:@"name"];
                [mutDic setObject:@(self.type) forKey:@"type"];

                dic1 = [NSDictionary dictionaryWithDictionary:mutDic];
                [arr1 replaceObjectAtIndex:i withObject:dic1];
                break;
            }
        }
        NSArray *arr2 = [NSArray arrayWithArray:arr1];
        [kUserDefaults setObject:arr2 forKey:@"privacyAlbum"];

      
       }];
       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KLanguage(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       }];
    // 2.1 添加文本框
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = KLanguage(@"Enter the name");
            textField.textColor = kWhiteColor;
            UIView *view = textField.superview;
            view.backgroundColor = [UIColor colorWithHexString:@"#1E1E1E" alpha:0.05];
            [textField addTarget:self action:@selector(alertUserAccountInfoDidChange:) forControlEvents:UIControlEventEditingChanged];     // 添加响应事件
            self.renameTF = textField;
        }];
       [alertController addAction:okAction];           // A
       [alertController addAction:cancelAction];       // B
    
    // 使用富文本来改变alert的title字体大小和颜色
    NSString * str1 = KLanguage(@"Enter the name");
      NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:str1];
    [titleText addAttributes:@{NSFontAttributeName:kBoldFont(17),NSForegroundColorAttributeName:kWhiteColor} range:NSMakeRange(0, str1.length)];
      [alertController setValue:titleText forKey:@"attributedTitle"];
      
      // 使用富文本来改变alert的message字体大小和颜色
      // NSMakeRange(0, 2) 代表:从0位置开始 两个字符
    NSString * str = KLanguage(@"Please give the web page you want tobookmark a name");
      NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:str];
    [messageText addAttributes:@{NSFontAttributeName:kFont(13),NSForegroundColorAttributeName:kWhiteColor} range:NSMakeRange(0, str.length)];
      [alertController setValue:messageText forKey:@"attributedMessage"];

    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)alertUserAccountInfoDidChange:(UITextField *)sender
{
//    NSString *text = sender.text;
}
-(void)deleteAction{
    //[playVolume playMusic];

    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLanguage(@"Confirm Delete")
                                                                             message:KLanguage(@"Are you sure you want to delete")
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
            if ( [dic intSafeForKey:@"Id"]==self.ID) {
                [arr1 removeObject:dic];
                break;
            }
        }
        NSArray *arr2 = [NSArray arrayWithArray:arr1];
        [kUserDefaults setObject:arr2 forKey:@"privacyAlbum"];

        [self.navigationController popViewControllerAnimated:YES];
      
       }];
       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KLanguage(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       }];
    //    [okAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    //    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    [alertController addAction:cancelAction];       // B

       [alertController addAction:okAction];           // A
    // 使用富文本来改变alert的title字体大小和颜色
    NSString * str1 = KLanguage(@"Delete");
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
        urlL.text = self.titleStr;
        self.titleL = urlL;
        UIButton *addBtn = [UIButton buttonWithType:0];
        addBtn.frame = CGRectMake(kScreenW-56, kStatusBarHeight+2, 40, 40);
        [addBtn setImage:kIMAGE_Name(@"album-1") forState:0];
        [addBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topV addSubview:addBtn];
        [_topV createLineFrame:CGRectMake(0, kNavBarHeight-1, kScreenW, 1) lineColor:kRGB(32, 32, 32)];

    }
    return _topV;
}
-(void)vipBtnAction{
    ACPayTwoViewController *vc = [ACPayTwoViewController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;

    [self presentViewController:vc animated:YES completion:nil];
}
-(void)addPhoto:(UIButton *)btn{
    if(![vipTool isVip]) {
        [self vipBtnAction];
        return;
    }
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                // 已经授权
                
                break;
            case PHAuthorizationStatusDenied:
            case PHAuthorizationStatusRestricted:
                // 权限被拒绝或受限
                [self photoQuanxian];
                return;;
            case PHAuthorizationStatusNotDetermined:
                // 权限未确定，请求权限
                
                break;
            default:
                // 其他情况
               
                break;
        }
    
    
    
    
    [UIButton setanimationwithBtn:btn];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        NSString *video = asset.localIdentifier;
        NSData *data = UIImageJPEGRepresentation(coverImage, 1.0f);


        NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@.png", NSHomeDirectory(),[NSString nowTimeInterval]];
        [data writeToFile:filePath atomically:YES];
        [self.dataArr addObject:filePath];
        [self.dataArrloc addObject:video];
        [self.collectionV reloadData];
        self.collectionV.hidden = NO;
        
        NSArray *arr = [kUserDefaults objectForKey:@"privacyAlbum"];
        
        NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:0];
        [arr1 addObjectsFromArray:arr];
        for (int i =0;i<arr.count;i++) {
            NSDictionary *dic = arr[i];
            NSDictionary *dic1;
            if ( [dic intSafeForKey:@"Id"]==self.ID) {
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithCapacity:0];
                [mutDic setObject:[NSArray arrayWithArray:self.dataArr] forKey:@"content"];
                [mutDic setObject:@(self.ID) forKey:@"Id"];
                [mutDic setObject:self.titleStr forKey:@"name"];
                [mutDic setObject:[NSArray arrayWithArray:self.dataArrloc] forKey:@"contentasset"];
                [mutDic setObject:@(self.type) forKey:@"type"];

                dic1 = [NSDictionary dictionaryWithDictionary:mutDic];
                [arr1 replaceObjectAtIndex:i withObject:dic1];
                break;
            }
        }
        NSArray *arr2 = [NSArray arrayWithArray:arr1];
        if(arr2.count==0){
        }
        [kUserDefaults setObject:arr2 forKey:@"privacyAlbum"];
            
    }];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        for (int i =0; i<photos.count; i++) {
            NSData *data = UIImageJPEGRepresentation(photos[i], 1.0f);

            NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@%i.png", NSHomeDirectory(),[NSString nowTimeInterval],i];
            [data writeToFile:filePath atomically:YES];
            [self.dataArr addObject:filePath];
            [self.collectionV reloadData];
            self.collectionV.hidden = NO;
            
            NSArray *arr = [kUserDefaults objectForKey:@"privacyAlbum"];
            
            NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:0];
            [arr1 addObjectsFromArray:arr];
            for (int i =0;i<arr.count;i++) {
                NSDictionary *dic = arr[i];
                NSDictionary *dic1;
                if ( [dic intSafeForKey:@"Id"]==self.ID) {
                    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithCapacity:0];
                    [mutDic setObject:[NSArray arrayWithArray:self.dataArr] forKey:@"content"];
                    [mutDic setObject:@(self.ID) forKey:@"Id"];
                    [mutDic setObject:self.titleStr forKey:@"name"];
                    [mutDic setObject:@(self.type) forKey:@"type"];

                    dic1 = [NSDictionary dictionaryWithDictionary:mutDic];
                    [arr1 replaceObjectAtIndex:i withObject:dic1];
                    break;
                }
            }
            NSArray *arr2 = [NSArray arrayWithArray:arr1];
            if(arr2.count==0){
            }
            [kUserDefaults setObject:arr2 forKey:@"privacyAlbum"];
        }
       

    }];
    imagePickerVc.videoMaximumDuration = 10;
    imagePickerVc.iconThemeColor = UIColor.mainBlackColor;
    imagePickerVc.allowTakeVideo = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowPickingImage = NO;
    imagePickerVc.allowPickingVideo = NO;
    if(self.type==1){
        imagePickerVc.allowTakePicture = YES;
        imagePickerVc.allowPickingImage = YES;
    }else{
        imagePickerVc.allowTakeVideo = YES;
        imagePickerVc.allowPickingVideo = YES;
    }
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
-(void)backAction{
    //[playVolume playMusic];

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addAction:(UIButton *)addBtn{
    [UIButton setanimationwithBtn:addBtn];
    //[playVolume playMusic];

    PopView *popView = [PopView popUpContentView:self.popListView direct:PopViewDirection_PopUpBottom onView:addBtn];
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    popView.clickOutHidden = YES;
}

//读文件数据
- (NSData*)readFileData:(NSString *)path{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL bool1 = [fm isReadableFileAtPath:path];
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *fileData = [handle readDataToEndOfFile];
    [handle closeFile];
    return fileData;
}
-(void)photoQuanxian{
    ACAlbumPowerSetVC *vc = [ACAlbumPowerSetVC new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:true completion:nil];
}
@end
