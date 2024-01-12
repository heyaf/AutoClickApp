//
//  SceneDelegate.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/25.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "ACTabViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "ACGuiderPageVC.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    //设置默认语言
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"]) {
            //获得当前语言
            NSArray *languages = [NSLocale preferredLanguages];
            NSString *language = [languages objectAtIndex:0];
            if([language hasPrefix:@"zh"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
            }else if([language hasPrefix:@"ja"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"ja" forKey:@"appLanguage"];
            }else if([language hasPrefix:@"ru"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"ru" forKey:@"appLanguage"];
            }else if([language hasPrefix:@"fr"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"fr" forKey:@"appLanguage"];
            }else if([language hasPrefix:@"de"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"de" forKey:@"appLanguage"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
            }
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.frame = [[UIScreen mainScreen] bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ACTabViewController *tabBarVC = [[ACTabViewController alloc] init];
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    if ([kUserDefaults boolForKey:@"showPage"]) {
        
    } else {
        [kUserDefaults setBool:YES forKey:@"showPage"];
        ACGuiderPageVC *pushVC = [[ACGuiderPageVC  alloc] init];
        pushVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.window.rootViewController presentViewController:pushVC animated:NO completion:nil];
    }
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    }

}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.

    // Save changes in the application's managed object context when the application transitions to the background.
    [(AppDelegate *)UIApplication.sharedApplication.delegate saveContext];
}


@end
