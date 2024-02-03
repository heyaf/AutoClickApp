//
//  ACSetLanguageVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/9.
//

#import "ACSetLanguageVC.h"
#import "ACLanguageTBCell.h"
#import "ACTabViewController.h"
@interface ACSetLanguageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *topV;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *nameArr;

@end

@implementation ACSetLanguageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.mainBlackColor;
    NSString *language = [kUserDefaults objectForKey:@"appLanguage"];
    self.index = 0;
    if ([language isEqualToString:@"zh-Hans"]) {
        self.index = 4;
    } else if ([language isEqualToString:@"ru"]){
        self.index = 1;
    }else if ([language isEqualToString:@"fr"]){
        self.index = 2;
    }else if ([language isEqualToString:@"de"]){
        self.index = 3;
    }else if ([language isEqualToString:@"zh-HK"]){
        self.index = 5;
    }else if ([language isEqualToString:@"ja"]){
        self.index = 6;
    }
    self.nameArr = @[@"English",@"Русский",@"Français",@"Deutsch",@"简体中文",@"繁體中文",@"日本語"];
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.topV];
    
}
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-kSafeAreaBottom) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 76;
        _tableview.backgroundColor = UIColor.mainBlackColor;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"ACLanguageTBCell" bundle:nil] forCellReuseIdentifier:@"ACLanguageTBCell"];
        
    }
    return _tableview;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACLanguageTBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACLanguageTBCell"];
    cell.titleL.text = self.nameArr[indexPath.row];
    if(self.index == indexPath.row){
        cell.selectL.hidden = NO;
    }else{
        cell.selectL.hidden = YES;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[playVolume playMusic];
    if (indexPath.row==0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
    }else if (indexPath.row==4){
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
    }else if (indexPath.row==6){
        [[NSUserDefaults standardUserDefaults] setObject:@"ja" forKey:@"appLanguage"];
    }else if (indexPath.row==1){
        [[NSUserDefaults standardUserDefaults] setObject:@"ru" forKey:@"appLanguage"];
    }else if (indexPath.row==2){
        [[NSUserDefaults standardUserDefaults] setObject:@"fr" forKey:@"appLanguage"];
    }else if (indexPath.row==3){
        [[NSUserDefaults standardUserDefaults] setObject:@"de" forKey:@"appLanguage"];
    }else if (indexPath.row==5){
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-HK" forKey:@"appLanguage"];
    }
    [kUserDefaults setBool:true forKey:@"changL"];
    ACTabViewController *tabBarVC = [[ACTabViewController alloc] init];
    self.view.window.rootViewController = tabBarVC;
    
    self.index= indexPath.row;
    [tableView reloadData];

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
        urlL.frame = CGRectMake(20, 8, searchBgv.width-40, 21);
        urlL.textAlignment = NSTextAlignmentCenter;
        urlL.text = @"Language";
        
        [_topV createLineFrame:CGRectMake(0, kNavBarHeight-1, kScreenW, 1) lineColor:kRGB(32, 32, 32)];
        
    }
    return _topV;
}

-(void)backAction{
    //[playVolume playMusic];

    [self.navigationController popViewControllerAnimated:YES];
}
@end
