//
//  ACPrivacyAblumVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/2.
//

#import "ACPrivacyAblumVC.h"
#import <Foundation/Foundation.h>
#import "ACPrivacyAblumItem.h"
#import "ACPrivacyAlbumDetailVC.h"
@interface ACPrivacyAblumVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, strong) UIView *topV;

@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, assign) NSInteger Type;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITextField *renameTF;

@end

@implementation ACPrivacyAblumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.mainBlackColor;
    [self.view addSubview:self.topV];
    [self.view addSubview:self.imageBtn];
    [self.view addSubview:self.videoBtn];

    [self.view addSubview:self.collectionV];
    self.Type =1;

    kViewBorderRadius(self.imageBtn, 5, 1, kWhiteColor);

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
-(void)refreshData{
    
    NSArray *arr = [kUserDefaults objectForKey:@"privacyAlbum"];
    NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dataDic in arr) {
        if ([dataDic intSafeForKey:@"type"]==self.Type) {
            [arr1 addObject:dataDic];
        }
    }
    if (arr1.count==0) {
        NSDictionary *dic = @{@"Id":@(999+self.Type),
                              @"name":KLanguage(@"default album"),
                              @"content":@[],
                              @"type":@(self.Type)};
        [arr1 addObject: dic];
        
        NSMutableArray *dataArr = [NSMutableArray arrayWithObject:dic];
        [dataArr addObjectsFromArray:arr];
        NSArray *Userarr  = [NSArray arrayWithArray:dataArr];
        [kUserDefaults setObject:Userarr forKey:@"privacyAlbum"];

    }
    self.dataArr = [NSMutableArray arrayWithArray:arr1];
    [self.collectionV reloadData];
}
-(UICollectionView *)collectionV{
    if(!_collectionV){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenW-16*3)/2;
        layout.itemSize = CGSizeMake(itemW, itemW*201/166);
        
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+60, kScreenW, kScreenH-kNavBarHeight-20) collectionViewLayout:layout];
        _collectionV.delegate = self;
        _collectionV.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _collectionV.backgroundColor = UIColor.mainBlackColor;
        _collectionV.showsVerticalScrollIndicator = false;
        _collectionV.showsHorizontalScrollIndicator = false;
        _collectionV.dataSource = self;
        [_collectionV registerNib:[UINib nibWithNibName:@"ACPrivacyAblumItem" bundle:nil] forCellWithReuseIdentifier:@"ACPrivacyAblumItem"];

        
    }
    return _collectionV;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ACPrivacyAblumItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"ACPrivacyAblumItem" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArr[indexPath.row];
    NSArray * arr = [dic arraySafeForKey:@"content"];
    
    item.titleL.text = [dic stringSafeForKey:@"name"];
    NSString *stringNum = KLanguage(@"Total 0 photos");
    if(self.Type ==2){
        stringNum = KLanguage(@"Total 0 videos");
    }
    NSMutableString *mutStr = [[NSMutableString alloc] initWithString:stringNum];
    NSRange range = [mutStr rangeOfString:@"**"];
    [mutStr replaceCharactersInRange:range withString:kStringFormat(@"%li",arr.count)];
    item.subTitleL.text = mutStr;
    if (arr.count==0) {
        item.mainImageV.hidden = YES;
    }else{
        NSString *pathStr = arr[0];
        NSData *data = [NSData dataWithContentsOfFile:pathStr];
        item.mainImageV.image = [UIImage imageWithData:data];
        item.mainImageV.hidden = NO;
        
    }
//    item.playImageV.hidden = self.Type==1;
    item.emptyImageV.hidden = NO;
    if(self.Type==1){
        item.emptyImageV.image = kIMAGE_Name(@"album_empty");
    }else{
        item.emptyImageV.image = kIMAGE_Name(@"video_empty");

    }

    return item;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ACPrivacyAlbumDetailVC *pushVC = [[ACPrivacyAlbumDetailVC  alloc] init];
    pushVC.type = self.Type;
    NSDictionary *dic = self.dataArr[indexPath.row];
    pushVC.ID = [dic intSafeForKey:@"Id"];
    pushVC.titleStr = [dic stringSafeForKey:@"name"];
  
    [self.navigationController pushViewController:pushVC animated:YES];
    //[playVolume playMusic];

}
- (UIButton *)imageBtn{
    if(!_imageBtn){
        _imageBtn = [UIButton buttonWithType:0];
        _imageBtn.frame = CGRectMake(16, kNavBarHeight+ 16, 70, 29);
        [_imageBtn setTitle:KLanguage(@"Photos") forState:0];
        [_imageBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:0];
        [_imageBtn setTitleColor:UIColor.mainBlackColor forState:UIControlStateSelected];
        _imageBtn.backgroundColor = kWhiteColor;
        kViewBorderRadius(_imageBtn, 5, 1, [UIColor colorWithHexString:@"#333333"]);
        _imageBtn.selected = YES;
        _imageBtn.titleLabel.font = kMediunFont(12);

        _imageBtn.tag = 100;
        [_imageBtn addTarget:self action:@selector(ChooseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageBtn;
}
- (UIButton *)videoBtn{
    if(!_videoBtn){
        _videoBtn = [UIButton buttonWithType:0];
        _videoBtn.frame = CGRectMake(100,kNavBarHeight+ 16, 70, 29);
        [_videoBtn setTitle:KLanguage(@"Videos") forState:0];
        [_videoBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:0];
        [_videoBtn setTitleColor:UIColor.mainBlackColor forState:UIControlStateSelected];
        _videoBtn.backgroundColor = UIColor.mainBlackColor;
        _videoBtn.titleLabel.font = kMediunFont(12);
        kViewBorderRadius(_videoBtn, 5, 1, [UIColor colorWithHexString:@"#333333"]);
        _videoBtn.tag = 101;
        [_videoBtn addTarget:self action:@selector(ChooseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoBtn;
}
-(UIView *)topV{
    if(!_topV){
        _topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        _topV.backgroundColor = UIColor.mainBlackColor;
        
        UIButton *backBtn = [UIButton buttonWithType:0];
        backBtn.frame = CGRectMake(6, kStatusBarHeight+2, 40, 40);
        [backBtn setImage:kIMAGE_Name(@"back_w") forState:0];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_topV addSubview:backBtn];
        
        UIView *searchBgv = [[UIView alloc] initWithFrame:CGRectMake(50, kStatusBarHeight+4, kScreenW-100, 36)];
        [_topV addSubview:searchBgv];
        searchBgv.backgroundColor = [UIColor mainBlackColor];
        
        

        
        UILabel *urlL = [searchBgv createLabelTextColor:kWhiteColor font:kBoldFont(17)];
        urlL.frame = CGRectMake(20, 10, searchBgv.width-40, 17);
        urlL.textAlignment = NSTextAlignmentCenter;
        urlL.text = KLanguage(@"Privacy album");
        
        UIButton *addBtn = [UIButton buttonWithType:0];
        addBtn.frame = CGRectMake(kScreenW-56, kStatusBarHeight+2, 40, 40);
        [addBtn setImage:kIMAGE_Name(@"add_icon") forState:0];
        [addBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [_topV addSubview:addBtn];
        [_topV createLineFrame:CGRectMake(0, kNavBarHeight-1, kScreenW, 1) lineColor:kRGB(32, 32, 32)];

        
    }
    return _topV;
}
-(void)ChooseBtnClicked:(UIButton *)itemBtn{
    [UIButton setanimationwithBtn:itemBtn];
    //[playVolume playMusic];

    if (itemBtn.tag ==100) {
        self.Type = 1;
        kViewBorderRadius(self.imageBtn, 5, 1, kWhiteColor);
        kViewBorderRadius(self.videoBtn, 5, 1, [UIColor colorWithHexString:@"#333333"]);
        self.imageBtn.selected = YES;
        self.videoBtn.selected = NO;
        [self.imageBtn setBackgroundColor:kWhiteColor];
        [self.videoBtn setBackgroundColor:UIColor.mainBlackColor];
    }else{
        self.Type = 2;
        kViewBorderRadius(self.videoBtn, 5, 1, kWhiteColor);
        kViewBorderRadius(self.imageBtn, 5, 1, [UIColor colorWithHexString:@"#333333"]);
        self.videoBtn.selected = YES;
        self.imageBtn.selected = NO;
        [self.videoBtn setBackgroundColor:kWhiteColor];
        [self.imageBtn setBackgroundColor:UIColor.mainBlackColor];
    }
    [self refreshData];
    [self.collectionV scrollsToTop];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    //[playVolume playMusic];

}
-(void)addAction{
    //[playVolume playMusic];

    
    
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLanguage(@"Delete")
                                                                             message:KLanguage(@"Are you sure you want to delete")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIView *view = alertController.view.subviews.firstObject;
    UIView *view1 = view.subviews.firstObject;
    UIView *view2 = view1.subviews.firstObject;



    __weak typeof(self) weakSelf = self;
    view2.backgroundColor = [UIColor colorWithHexString:@"#1E1E1E" alpha:0.75];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:KLanguage(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!self.renameTF||self.renameTF.text.length==0) {
            return;
        }
        NSArray *arr = [kUserDefaults objectForKey:@"privacyAlbum"];

        NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dataDic in arr) {
            if ([dataDic intSafeForKey:@"type"]==weakSelf.Type) {
                [mutArr addObject:dataDic];
            }
        }
        NSDictionary *dic = @{@"Id":@(arr.count+1),
                              @"name":self.renameTF.text,
                              @"content":@[],
                              @"type":@(weakSelf.Type)};
        [mutArr addObject:dic];
        
        NSMutableArray *mutArr1 = [NSMutableArray arrayWithArray:arr];
        [mutArr1 addObject:dic];
        NSArray *arr1 = [NSArray arrayWithArray:mutArr1];
        [kUserDefaults setObject:arr1 forKey:@"privacyAlbum"];
        weakSelf.dataArr = mutArr;
        [weakSelf.collectionV reloadData];
      
       }];
       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KLanguage(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       }];
    // 2.1 添加文本框
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = KLanguage(@"Enter the name");
            textField.textColor = kWhiteColor;
            UIView *view = textField.superview;
            view.backgroundColor = [UIColor colorWithHexString:@"#1E1E1E" alpha:0.05];
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
//读文件数据
- (NSData*)readFileData:(NSString *)path{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *fileData = [handle readDataToEndOfFile];
    [handle closeFile];
    return fileData;
}
@end
