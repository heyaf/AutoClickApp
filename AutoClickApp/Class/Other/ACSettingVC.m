//
//  ACSettingVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/29.
//

#import "ACSettingVC.h"
#import "ACSettingTBCell.h"
#import <StoreKit/StoreKit.h>
#import "ACSetLanguageVC.h"

@interface ACSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *topV;

@property (nonatomic, strong) NSArray *iconArr;

@property (nonatomic, strong) NSArray *titleArr;


@property (nonatomic, assign) BOOL onswitch;

@end

@implementation ACSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.mainBlackColor;
    self.iconArr = @[@[@"set1",@"set2"],@[@"set3",@"set4",@"set5",@"set6"]];
    self.titleArr = @[@[KLanguage(@"Click Sound"),KLanguage(@"Select Language")],@[KLanguage(@"Privacy policy"),KLanguage(@"Rate App"),KLanguage(@"Feedback"),KLanguage(@"Share App")]];
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.topV];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setViewH];
}
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-kSafeAreaBottom) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 60;
        _tableview.backgroundColor = UIColor.mainBlackColor;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"ACSettingTBCell" bundle:nil] forCellReuseIdentifier:@"ACSettingTBCell"];
        
    }
    return _tableview;
}
-(void)setViewH{
    if ([vipTool isVip]) {
        self.tableview.tableHeaderView = [UIView new];
    }else{
        ACSettingHeaderView *header = [[ACSettingHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  150 * (kScreenW / 375))];
        header.payBack = ^{
            [self vipBtnAction];
        };
        self.tableview.tableHeaderView = header;
    }
}
-(void)vipBtnAction{
    ACPayTwoViewController *vc = [ACPayTwoViewController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.reloadVip = ^{
        [self setViewH];
    };
    [self presentViewController:vc animated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0||indexPath.row==3||indexPath.row==0) {
        return 50;
    }
    return 60;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.iconArr[section];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACSettingTBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACSettingTBCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *icon = self.iconArr[indexPath.section][indexPath.row];
    cell.logoimageV.image = kIMAGE_Name(icon);
    cell.titleL.text = self.titleArr[indexPath.section][indexPath.row];
    if(indexPath.section==0&&indexPath.row==0){
        cell.swiTch.hidden = NO;
 
    }else{
        cell.swiTch.hidden = YES;

    }
    cell.lineV.hidden = NO;
    if((indexPath.section==0&&indexPath.row==1)||(indexPath.section==1&&indexPath.row==3)){
        cell.lineV.hidden = YES;

    }
    cell.topH.constant = 18;
    if (indexPath.row==0) {
        cell.topH.constant = 8;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[playVolume playMusic];
    if(indexPath.section==0&&indexPath.row==1){
        ACSetLanguageVC *pushVC = [[ACSetLanguageVC  alloc] init];
        [self.navigationController pushViewController:pushVC animated:YES];
    }
    
    if(indexPath.section==1){
        if(indexPath.row==0){
            [self openUrl:@"https://fair-chalk-fc5.notion.site/Privacy-Policy-63a04c8f370449c09b61fadb28d5dbea?pvs=4"];
        }else if (indexPath.row==1){
            // openURL: 方法在 iOS 10 以后已被弃用，替换为 openURL:options:completionHandler:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id6470910061?action=write-review"]];
            //id 字符串后续的数字为当前 App 对应的 Apple ID可以在 App Store Connect 后台查到
        }else if (indexPath.row==2){
            [self launchMailApp];
        }else if (indexPath.row==3){
            [self shareTItle];
        }
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 50;
    }
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
        headerV.backgroundColor = UIColor.mainBlackColor;
        
        UILabel *label = [headerV createLabelFrame:CGRectMake(16, 10, 200, 30) textColor:kWhiteColor font:kFont(12)];
        label.text =KLanguage(@"General");
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(16, 40, kScreenW-32, 20)];
        view.backgroundColor = [UIColor colorWithHexString:@"#272226"];
        
        [headerV addSubview:view];
        kViewRadius(view, 10);
        kViewRadius(headerV, 1);
        return headerV;
    }else{
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
        headerV.backgroundColor = UIColor.mainBlackColor;
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(16, -10, kScreenW-32, 20)];
        view1.backgroundColor = [UIColor colorWithHexString:@"#272226"];
        [headerV addSubview:view1];
        
        UILabel *label = [headerV createLabelFrame:CGRectMake(16, 20, 200, 30) textColor:kWhiteColor font:kFont(12)];
        label.text = KLanguage(@"Others");
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(16, 50, kScreenW-32, 20)];
        view.backgroundColor = [UIColor colorWithHexString:@"#272226"];
        [headerV addSubview:view];
        kViewRadius(view, 10);
        kViewRadius(view1, 10);

        kViewRadius(headerV, 1);
        return headerV;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{

        return 60;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section==0){
        return [UIView new];
    }
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    headerV.backgroundColor = UIColor.mainBlackColor;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(16, -10, kScreenW-32, 20)];
    view1.backgroundColor = [UIColor colorWithHexString:@"#272226"];
    kViewRadius(view1, 10);
    [headerV addSubview:view1];
    kViewRadius(headerV, 1);
    UILabel *label = [headerV createLabelFrame:CGRectMake(20, 30, kScreenW-32, 20) textColor:kWhiteColor font:kMediunFont(15)];
    // 获取App版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];


    label.text = kStringFormat(@"%@ %@",KLanguage(@"App Version"),appVersion);
    
   
    return headerV;
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
        urlL.text = KLanguage(@"Settings");
        [_topV createLineFrame:CGRectMake(0, kNavBarHeight-1, kScreenW, 1) lineColor:kRGB(32, 32, 32)];


        
    }
    return _topV;
}
-(void)backAction{
    //[playVolume playMusic];

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 使用系统邮件客户端发送邮件
-(void)launchMailApp
{
    NSString *mailAddress=@"yzktech666@163.com";
    NSString *url=[NSString stringWithFormat:@"mailto:%@",mailAddress];
    [self openUrl:url];
    
    
}
-(void)openUrl:(NSString *)urlStr{
    //注意url中包含协议名称，iOS根据协议确定调用哪个应用，例如发送邮件是“sms://”其中“//”可以省略写成“sms:”(其他协议也是如此)
    NSURL *url=[NSURL URLWithString:urlStr];
    UIApplication *application=[UIApplication sharedApplication];
    if(![application canOpenURL:url]){
        NSLog(@"无法打开\"%@\"，请确保此应用已经正确安装.",url);
        return;
    }
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        
    }];
    
}

-(void)shareTItle{
    //分享的标题
    NSString *textToShare = @"Auto Cliker";
    //分享的图片
    UIImage *imageToShare = [UIImage imageNamed:@"APP_icon"];
    //分享的url
    //    NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];
    
    NSArray *activityItems = @[textToShare,imageToShare];
    
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
