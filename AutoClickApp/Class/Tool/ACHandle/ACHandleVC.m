//
//  ACHandleVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/8.
//

#import "ACHandleVC.h"
#import "HoldingModel.h"
#import "RollingView.h"
#import "ACColorView.h"

@interface ACHandleVC ()<UISearchBarDelegate,UITextFieldDelegate>
@property (nonatomic, strong) HoldingModel *model;

@property (nonatomic, strong) RollingView *rollingView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) ACColorView *colorView;


@end

@implementation ACHandleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.mainBlackColor;
    self.model = [self loadModel];
    [self.view addSubview:self.rollingView];
    self.rollingView.model = self.model;
    
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(6, kStatusBarHeight+2, 40, 40);
    [backBtn setImage:kIMAGE_Name(@"back_w") forState:0];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    [self.view addSubview:self.bottomView];
    
    self.colorView = [[ACColorView alloc] initWithFrame:CGRectMake(16, kScreenH, kScreenW - 32, 220)];
    [self.view addSubview:self.colorView];
    self.colorView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    kViewRadius(self.colorView, 16);
    __weak typeof(self) weakSelf = self;
    self.colorView.selectColorBlock = ^(NSInteger index, NSString * _Nonnull colorStr) {
        if (index ==1) {
            weakSelf.model.color = [UIColor colorWithHexString:colorStr];
            weakSelf.model = weakSelf.model;
        }else{
            weakSelf.rollingView.backgroundColor = [UIColor colorWithHexString:colorStr];
        }
    };
}
- (void)setModel:(HoldingModel *)model{
    _model = model;
    if (model) {
        self.rollingView.model = model;
    }
}
#pragma mark 初始化Model 设置默认值
- (HoldingModel *)loadModel{
    HoldingModel *model = [HoldingModel new];
    model.content = KLanguage(@"Handheld barrage");
    model.speed = @"1.5";
    model.fontSize = @"96";
    model.fontName = @"HiraMaruProN-W4";
    model.color = [UIColor whiteColor];
    model.speedArray = @[@"0",@"0.5",@"1",@"1.5"];
    model.fontNameArray = @[@"Copperplate-Light",@"AppleSDGothicNeo-Thin",@"Thonburi",@"GillSans-Italic",@"MarkerFelt-Thin",@"HiraMaruProN-W4"];
    model.colorArray = @[[UIColor whiteColor],[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor]];
    model.fontSizeArray = @[@"24",@"36",@"48",@"64",@"72",@"84"];
    return model;
}

- (RollingView *)rollingView{
    if (!_rollingView) {
        _rollingView = [RollingView new];
        [self.view addSubview:_rollingView];
        [self.view sendSubviewToBack:_rollingView];
        //        CGSize size = CGSizeMake(self.view.bounds.size.height, self.view.bounds.size.width);
        CGSize size = CGSizeMake(self.view.bounds.size.height, self.view.bounds.size.width);
        CGRect rect;
        rect.size = size;
        rect.origin = CGPointMake(0, 0);
        _rollingView.frame = rect;
        _rollingView.center = self.view.center;

        _rollingView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_rollingView addGestureRecognizer:tap];
    }
    return _rollingView;
}
-(UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(16, kScreenH - kSafeAreaBottom -20-120, kScreenW - 32, 120)];
        kViewRadius(_bottomView, 16);
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        
        UIButton *backBtn = [UIButton buttonWithType:0];
        backBtn.frame = CGRectMake(11, 11, 42, 42);
        [backBtn setImage:kIMAGE_Name(@"handle_down") forState:0];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [backBtn addTarget:self action:@selector(downkAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:backBtn];
        
        UIButton *backBtn1 = [UIButton buttonWithType:0];
        backBtn1.frame = CGRectMake(kScreenW - 32-11-42, 11, 42, 42);
        [backBtn1 setImage:kIMAGE_Name(@"handle_color") forState:0];
        [backBtn1 setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [backBtn1 addTarget:self action:@selector(downkAction1) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:backBtn1];
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(16, 56, kScreenW-64, 48)];
        _searchBar.placeholder = KLanguage(@"Enter text");
        _searchBar.searchTextField.text = KLanguage(@"Handheld barrage");
        _searchBar.tintColor = kWhiteColor;
        _searchBar.barTintColor = UIColor.mainBlackColor;
        _searchBar.searchTextField.textColor = kWhiteColor;
        [_searchBar setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        _searchBar.searchTextField.returnKeyType = UIReturnKeySend;
        _searchBar.searchTextField.backgroundColor = kClearColor;
        kViewBorderRadius(_searchBar, 8, 1, [UIColor colorWithHexString:@"#E7D4FF"]);
        _searchBar.searchBarStyle = UISearchBarStyleProminent;
//        _searchBar.searchTextPositionAdjustment = UIOffsetMake(10, 10);
//        _searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(5, 5);
        [_bottomView addSubview:_searchBar];
        _searchBar.delegate = self;
        
        [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].leftView = nil;
        [UISearchBar appearance].searchTextPositionAdjustment = UIOffsetMake(10, 0);
        
    }
    return _bottomView;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.model.content = searchBar.searchTextField.text;
    self.model = self.model;
    [self.searchBar.searchTextField resignFirstResponder];

}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    self.model.content = searchBar.searchTextField.text;
    self.model = self.model;
    return YES;
}

-(void)downkAction{
    [self.searchBar.searchTextField resignFirstResponder];
    //[playVolume playMusic];

    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = kScreenH ;
    }];
}
-(void)tapAction{
    [self.searchBar.searchTextField resignFirstResponder];
    if (self.bottomView.y == kScreenH - kSafeAreaBottom -20-120) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView.y = kScreenH ;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView.y = kScreenH - kSafeAreaBottom -20-120 ;
        }];
    }
    
}

-(void)downkAction1{
    //[playVolume playMusic];

    [self.searchBar.searchTextField resignFirstResponder];

    [UIView animateWithDuration:0.3 animations:^{
        self.colorView.y = kScreenH - kSafeAreaBottom -20-220;
    }];
}
-(void)backAction{
    AppDelegate *appde = kAppDelegate;
    if (appde.hasShowStar == false) {
        [SKStoreReviewController requestReview];
        appde.hasShowStar = true;
    }

    [self.navigationController popViewControllerAnimated:YES];
}
@end
