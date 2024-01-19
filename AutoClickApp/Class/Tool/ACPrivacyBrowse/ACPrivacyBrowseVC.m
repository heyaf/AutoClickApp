//
//  ACPrivacyBrowseVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/6.
//

#import "ACPrivacyBrowseVC.h"
#import "ACPrivacyBrowseItem.h"
#import "ACPrivacyBrowseDetailVC.h"
@interface ACPrivacyBrowseVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *bottmView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *urlArr;
@property (nonatomic, assign) NSInteger index; //当前是在第几个页面
//是否是返回上一级
@property (nonatomic, assign) BOOL isback;
@property (nonatomic, assign) BOOL isRightClicked;
@property (nonatomic, assign) BOOL isrefresh;
@end

@implementation ACPrivacyBrowseVC
- (NSMutableArray *)dataArr{LazyMutableArray(_dataArr)}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.mainBlackColor;
    [self.view addSubview:self.topV];
    NSArray *arr = [kUserDefaults objectForKey:@"privacyBrowse"];
    [self.dataArr addObjectsFromArray:arr];
    if(arr.count==0){
        NSArray *defaultArr =             @[@{@"name":@"google",
                                              @"url":@"https://www.google.com/",
                                              @"icon":@"browse1"},
                                            @{@"name":@"bing",
                                              @"url":@"https://www.bing.com/",
                                              @"icon":@"browse2"},
                                            @{@"name":@"youtube",
                                              @"url":@"https://www.youtube.com",
                                              @"icon":@"browse3"},
                                            @{@"name":@"twitter",
                                              @"url":@"https://www.twitter.com/",
                                              @"icon":@"browse4"}];
        [self.dataArr addObjectsFromArray:defaultArr];
        [kUserDefaults setObject:defaultArr forKey:@"privacyBrowse"];
    }
    
    [self.view addSubview:self.collectionV];
    
    UIButton *searchBtn = [UIButton buttonWithType:0];
    searchBtn.backgroundColor = [UIColor colorWithHexString:@"#272226"];
    kViewRadius(searchBtn, 16);
    searchBtn.frame = CGRectMake(24, kNavBarHeight + 48, kScreenW-48, 56);
    [self.view addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 20, 16, 16)];
    imageV.image = kIMAGE_Name(@"search_icon");
    [searchBtn addSubview:imageV];
    
    UILabel *titleL = [searchBtn createLabelFrame:CGRectMake(40, 20, searchBtn.width-50, 16) textColor:kWhiteColor font:kFont(12)];
    titleL.text = KLanguage(@"Search Any Website");
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.dataArr removeAllObjects];
    NSArray *arr = [kUserDefaults objectForKey:@"privacyBrowse"];
    [self.dataArr addObjectsFromArray:arr];
    [self.collectionV reloadData];
}

-(UICollectionView *)collectionV{
    if(!_collectionV){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenW-16*5)/4;
        layout.itemSize = CGSizeMake(itemW, itemW+27);
        
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+128, kScreenW, kScreenH-kNavBarHeight-138-kSafeAreaBottom) collectionViewLayout:layout];
        _collectionV.delegate = self;
        _collectionV.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _collectionV.backgroundColor = UIColor.mainBlackColor;
        _collectionV.showsVerticalScrollIndicator = false;
        _collectionV.showsHorizontalScrollIndicator = false;
        _collectionV.dataSource = self;
        [_collectionV registerNib:[UINib nibWithNibName:@"ACPrivacyBrowseItem" bundle:nil] forCellWithReuseIdentifier:@"ACPrivacyBrowseItem"];
        
        
    }
    return _collectionV;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ACPrivacyBrowseItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"ACPrivacyBrowseItem" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArr[indexPath.row];
    item.iconimV.image = kIMAGE_Name(dic[@"icon"]);
    item.nameL.text = dic[@"name"];
    
    return item;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(![vipTool isVip]) {
        [self vipBtnAction];
        return;
    }
    ACPrivacyBrowseDetailVC *pushVC = [[ACPrivacyBrowseDetailVC  alloc] init];
    NSDictionary *dic = self.dataArr[indexPath.row];
    pushVC.urlStr = dic[@"url"];
    [self.navigationController pushViewController:pushVC animated:YES];
    //[playVolume playMusic];
    
}
-(void)vipBtnAction{
    ACPayTwoViewController *vc = [ACPayTwoViewController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
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
        urlL.text = KLanguage(@"Privacy browser");
        [_topV createLineFrame:CGRectMake(0, kNavBarHeight-1, kScreenW, 1) lineColor:kRGB(32, 32, 32)];
        
    }
    return _topV;
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    //[playVolume playMusic];
    
}
- (void)searchAction{
    if(![vipTool isVip]) {
        [self vipBtnAction];
        return;
    }
    ACPrivacyBrowseDetailVC *pushVC = [[ACPrivacyBrowseDetailVC  alloc] init];
    [self.navigationController pushViewController:pushVC animated:YES];
    //[playVolume playMusic];
    
}
@end
