//
//  ACWebClickerVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/27.
//

#import "ACWebClickerVC.h"
#import "ACWebClickerItem.h"
#import "ACWebClickerReusableView.h"
#import "ACWebClickerDetailVC.h"
#import "ACSettingVC.h"
#import <CoreTelephony/CTCellularData.h>
//#import <IQKeyboardManager/IQKeyboardManager.h>
@interface ACWebClickerVC ()<UISearchBarDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITextField *searchTextfield;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UICollectionView *collectionV;

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *iconArr;
@property (nonatomic, strong) NSArray *urlArr;
@property (nonatomic, strong) UIView *lineV;



@end

@implementation ACWebClickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArr = @[@[KLanguage(@"roblox"),KLanguage(@"Minecraft"),KLanguage(@"Amongus")],@[KLanguage(@"Tiktok"),KLanguage( @"Tinder"),KLanguage(@"Twitter"),KLanguage(@"Facebook"),KLanguage(@"YouTube"),KLanguage(@"linkedin")]];
    self.iconArr = @[@[@"icon1",@"icon2",@"icon3"],@[@"icon4",@"icon5",@"icon6",@"icon7",@"icon8",@"icon9"]];
    self.urlArr = @[@[@"http://www.roblox.com",@"http://www.minecraft.net",@"https://www.innersloth.com/games/among-us/"],@[@"https://www.tiktok.com/browse",@"https://tinder.com/",@"https://twitter.com/home",@"https://www.facebook.com/",@"https://www.youtube.com/",@"https://www.linkedin.com/"]];
    
    self.view.backgroundColor = UIColor.mainBlackColor;
    //修改NavigationBar
    [self.navigationController.navigationBar setBarTintColor:[UIColor mainBlackColor]];
    [self setNav];
    [self creatUI];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self getNet];
//
//    });
//    [[CTCellularData alloc] init].restrictedState;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self changeSearchBarStatues:NO];
    [_searchBar.searchTextField resignFirstResponder];
    self.navigationController.navigationBarHidden = YES;
    self.lineV.hidden = YES;
//    [IQKeyboardManager sharedManager].enable = YES;


}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    BOOL net = [kUserDefaults boolForKey:@"netWork"];
    if (!net) {
        [self getNet];
    }
    ACPayOneViewController *oneVC = [[ACPayOneViewController alloc] init];
    oneVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [kKeyWindow.rootViewController presentViewController:oneVC animated:YES completion:nil];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.lineV.hidden = NO;
//    [IQKeyboardManager sharedManager].enable = NO;

}

-(void)creatUI{
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10,kNavBarHeight+24, kScreenW-20, 48)];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = KLanguage(@"Search Any Website");
    searchBar.delegate = self;
    kViewRadius(searchBar, 10);
    searchBar.searchTextField.textColor = kWhiteColor;
    searchBar.backgroundColor = [UIColor colorWithHexString:@"#272226"];;
    [searchBar setImage:kIMAGE_Name(@"search_icon") forSearchBarIcon:UISearchBarIconSearch state:0];
    UITextField *textfield;
    if (@available(iOS 13.0, *)) {
        textfield = [searchBar searchTextField];
    } else {
        textfield = [searchBar valueForKey:@"_searchField"];
    }
    searchBar.searchTextField.borderStyle = UITextBorderStyleNone;
    self.searchTextfield = textfield;
    textfield.delegate = self;
    //修改placeHolder的颜色
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:KLanguage(@"Search Any Website") attributes:@{NSForegroundColorAttributeName : kRGBA(255, 255, 255, 0.7)}];
    textfield.attributedPlaceholder = placeholderString;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    UIButton *cancleBtn = [UIButton buttonWithType:0];
    [cancleBtn setTitle:KLanguage(@"Cancel") forState:0];
    cancleBtn.frame = CGRectMake(kScreenW-80, kNavBarHeight + 40, 70, 18);
    [cancleBtn setTitleColor:[UIColor colorWithHexString:@"#ACA9AC"] forState:0];
    [self.view addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    [cancleBtn addTarget:self action:@selector(cancleBtnclicked) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.hidden = YES;
    
    [self.view addSubview:self.collectionV];
}
-(UICollectionView *)collectionV{
    if(!_collectionV){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenW-16*4)/3;
        layout.itemSize = CGSizeMake(itemW, itemW);
        
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+96, kScreenW, kScreenH-kTabBarHeight-kNavBarHeight-106) collectionViewLayout:layout];
        _collectionV.delegate = self;
        _collectionV.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _collectionV.backgroundColor = UIColor.mainBlackColor;
        _collectionV.scrollEnabled = false;
        _collectionV.showsVerticalScrollIndicator = false;
        _collectionV.showsHorizontalScrollIndicator = false;
        _collectionV.dataSource = self;
        [_collectionV registerNib:[UINib nibWithNibName:@"ACWebClickerItem" bundle:nil] forCellWithReuseIdentifier:@"ACWebClickerItem"];
//        [_collectionV registerNib:[UINib nibWithNibName:@"ACWebClickerReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ACWebClickerReusableView"];
        [_collectionV registerClass:[ACWebClickerReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ACCollectionReusableView"];
        
    }
    return _collectionV;
}
-(void)cancleBtnclicked{
    //[playVolume playMusic];

    [self changeSearchBarStatues:NO];
    [_searchBar.searchTextField resignFirstResponder];
}
-(void)changeSearchBarStatues:(BOOL)statues{
    if(statues){
        [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.right.mas_offset(-80);
            make.top.mas_offset(kNavBarHeight+24);
            make.height.mas_equalTo(48);
        }];
        self.cancleBtn.hidden = NO;
        kViewBorderRadius(self.searchBar, 10, 1, UIColor.themeColor);

    }else{
        [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.right.mas_offset(-10);
            make.top.mas_offset(kNavBarHeight+24);
            make.height.mas_equalTo(48);
        }];
        self.cancleBtn.hidden = YES;
        kViewBorderRadius(self.searchBar, 10, 0, kClearColor);

    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self changeSearchBarStatues:YES];
    //[playVolume playMusic];

    return YES;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    NSString *str = searchBar.searchTextField.text;
    if(str.length==0){
        return;
    }
    if([str hasPrefix:@"https://"]||[str hasPrefix:@"http://"]){
        
    }else if ([str hasPrefix:@"www."]){
        str = kStringFormat(@"https://%@",str);
    }else{
        str = kStringFormat(@"https://www.cn.bing.com/search?q=%@",str);
        
    }
    ACWebClickerDetailVC *pushVC = [[ACWebClickerDetailVC  alloc] init];
    pushVC.urlStr = str;
    pushVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pushVC animated:YES];
}
-(void)searchBarSearchButtonClicked{
    
}
-(void)setNav{
    
    UILabel *label = [self.navigationController.navigationBar createLabelFrame:CGRectMake(10, 10, 280, 24) textColor:UIColor.whiteColor font:kBoldFont(24)];
    label.text = KLanguage(@"auto clicker");
    
    UIButton *setBtn = [UIButton buttonWithType:0];
    setBtn.frame = CGRectMake(kScreenW-45, 7, 34, 34);
    [setBtn setImage:kIMAGE_Name(@"set_icon") forState:0];
    [self.navigationController.navigationBar addSubview:setBtn];
    [setBtn addTarget:self action:@selector(setClicked) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
   self.lineV = [self.navigationController.navigationBar createLineFrame:CGRectMake(0, 44-1, kScreenW, 1) lineColor:kRGB(32, 32, 32)];
}

#pragma mark ---delete---
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section==0){
        return 3;
    }
    return 6;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ACWebClickerItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"ACWebClickerItem" forIndexPath:indexPath];
    item.mainImV.image = kIMAGE_Name(self.iconArr[indexPath.section][indexPath.row]);
    item.titleL.text = self.titleArr[indexPath.section][indexPath.row];
    return item;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(self.view.frame.size.width, 40);
   
}
 
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    ACWebClickerReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                withReuseIdentifier:@"ACCollectionReusableView"
                                                                                       forIndexPath:indexPath];
    
    UILabel * nameL = [headView createLabelTextColor:kWhiteColor font:kFont(14)];
    nameL.frame = CGRectMake(0, 10, 200, 20);
    if (indexPath.section==0) {
        nameL.text = KLanguage(@"game");
    } else {
        nameL.text = KLanguage(@"social media");

    }
    return headView;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //[playVolume playMusic];

    ACWebClickerDetailVC *pushVC = [[ACWebClickerDetailVC  alloc] init];
    pushVC.urlStr = self.urlArr[indexPath.section][indexPath.row];
    pushVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pushVC animated:YES];
}
//设置
-(void)setClicked{
    //[playVolume playMusic];

    ACSettingVC *pushVC = [[ACSettingVC  alloc] init];
    pushVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pushVC animated:YES];
}
-(void)getNet{
 
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]
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
        [kUserDefaults setBool:YES forKey:@"netWork"];
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
#pragma mark - 键盘处理
- (void)keyboardWillShow:(NSNotification *)note {
    // 取出键盘最终的frame
//    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.collectionV.hidden = YES;

}

- (void)keyboardWillHide:(NSNotification *)note {
    self.collectionV.hidden = NO;
    [self changeSearchBarStatues:NO];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
