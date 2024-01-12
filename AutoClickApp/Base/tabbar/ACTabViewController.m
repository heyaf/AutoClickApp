//
//  ACTabViewController.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/27.
//

#import "ACTabViewController.h"
#import "ACTabbar.h"
#import "UIImage+colorImage.h"
@interface ACTabViewController ()<UITabBarControllerDelegate, UITabBarDelegate>

@property (nonatomic, strong) ACTabbar *tabbar;

@end

@implementation ACTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabbar = [[ACTabbar alloc] init];
    /// 添加自定义tabbar
    [self setValue:self.tabbar forKeyPath:@"tabBar"];
    
//    [[UITabBar appearance] setBackgroundImage:[UIColor createImageWithColor:UIColor.mainBlackColor]];
//    [UITabBar appearance].barTintColor = UIColor.mainBlackColor;
//    [[UITabBar appearance] setTranslucent:NO];
    if(@available(iOS 13.0, *)) {
        [[UITabBar appearance] setTintColor:[UIColor colorWithHexString:@"#FFFDFF"]];
        [[UITabBar appearance] setUnselectedItemTintColor:[UIColor colorWithHexString:@"#8C898E"]];
    } else {
        //Normal
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithBoldType:(BNFontBoldTypeRegular) size:12], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#8C898E"]} forState:UIControlStateNormal];
        //Selected
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithBoldType:(BNFontBoldTypeRegular) size:12], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#FFFDFF"]} forState:UIControlStateSelected];
    }
    self.delegate = self;
    [self createContollers];
    [[UITabBar appearance] setTranslucent:NO];
    
    if (@available(iOS 15.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        UITabBarItemAppearance *itemAppearance = [[UITabBarItemAppearance alloc] init];
        itemAppearance.normal.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithBoldType:(BNFontBoldTypeRegular) size:12], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#8C898E"]};
        itemAppearance.selected.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithBoldType:(BNFontBoldTypeRegular) size:12], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#FFFDFF"]};
        appearance.stackedLayoutAppearance = itemAppearance;
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = UIColor.mainBlackColor;
        self.tabBar.standardAppearance = appearance;
        self.tabBar.scrollEdgeAppearance = appearance;

    } else {
        // Fallback on earlier versions
    }
    self.tabbar.backgroundColor = UIColor.mainBlackColor;
    
    [self.tabbar createLineFrame:CGRectMake(0, 0, kScreenW, 0.5) lineColor:kRGBA(30, 30, 30, 1)];
//    UIView *color_view = [[UIView alloc]initWithFrame:self.tabBar.bounds];
//    color_view.backgroundColor = [UIColor mainBlackColor];
//    [self.tabBar insertSubview:color_view atIndex:0];

}

#pragma mark -创建并添加子控制器
- (void)createContollers
{
    // YYStarsMainVC YYStoreMainVC
    [self addChildViewControllerName:@"ACWebClickerVC" title:KLanguage(@"web clicker") imageName:@"tab1" highImageName:@"tab4"];
    // YYHomeMainVC YYHomeVC
    [self addChildViewControllerName:@"ACAppClickerViewController" title:KLanguage(@"App clicker") imageName:@"tab2" highImageName:@"tab5"];
    [self addChildViewControllerName:@"ACToolsVC" title:KLanguage(@"Tools") imageName:@"tab3" highImageName:@"tab6"];
}


- (void)addChildViewControllerName:(NSString *)childControllerName
                             title:(NSString *)title
                         imageName:(NSString *)imageName
                     highImageName:(NSString *)highImageName
{
    UIViewController *chilVC = [[NSClassFromString(childControllerName) alloc] init];
    
    UINavigationController *baseNaviC = [[UINavigationController alloc] initWithRootViewController:chilVC];
    
    chilVC.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    UIImage *selectImg =  [UIImage imageNamed:highImageName];
    
    chilVC.tabBarItem.selectedImage = [selectImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    chilVC.tabBarItem.title = title;
//    chilVC.title = title;
    [self addChildViewController:baseNaviC];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = UIColor.mainBlackColor;
        baseNaviC.navigationBar.standardAppearance = appearance;
        baseNaviC.navigationBar.scrollEdgeAppearance = appearance;
        
      
        

    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    UINavigationController *navVC = (UINavigationController *)viewController;
//    UIViewController *rootCtrl = navVC.topViewController;
    //[playVolume playMusic];

    return YES;
}

@end
