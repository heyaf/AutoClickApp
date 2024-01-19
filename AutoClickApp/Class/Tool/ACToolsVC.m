//
//  ACToolsVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/27.
//

#import "ACToolsVC.h"
#import "ACToolListTBCell.h"
#import "ACPrivacyAblumVC.h"
#import "ACPrivacyBrowseVC.h"
//#import "ACImageCropViewController.h"
#import "ACDocumentScanVC.h"
#import "ACHandleVC.h"
#import "ACGridLayoutVC.h"
#import "ACSettingVC.h"
#import "ACImageCrop/ACImageCropVC.h"

@interface ACToolsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *imageNameArr;
@property (nonatomic, strong) UIView *lineV;

@property (nonatomic, strong) UIButton *vipBtn;

@end

@implementation ACToolsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.mainBlackColor;
    self.titleArr = @[KLanguage(@"Privacy album"),KLanguage(@"Privacy browser"),KLanguage(@"Handheld barrage"),KLanguage(@"Document scanning"),KLanguage(@"Image cropping"),KLanguage(@"Grid layout")];
    self.imageNameArr = @[@"tool_icon1",@"tool_icon2",@"tool_icon3",@"tool_icon4",@"tool_icon5",@"tool_icon6",@"tool_icon7"];
    [self setNav];
}

-(void)setNav{
    
    UILabel *label = [self.navigationController.navigationBar createLabelFrame:CGRectMake(16, 10, 280, 24) textColor:UIColor.whiteColor font:kBoldFont(24)];
    label.text = KLanguage(@"auto clicker");
    
    UIButton *setBtn = [UIButton buttonWithType:0];
    setBtn.frame = CGRectMake(kScreenW-45, 7, 34, 34);
    [setBtn setImage:kIMAGE_Name(@"set_icon") forState:0];
    [self.navigationController.navigationBar addSubview:setBtn];
    [setBtn addTarget:self action:@selector(setClicked) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.lineV = [self.navigationController.navigationBar createLineFrame:CGRectMake(0, 43, kScreenW, 1) lineColor:kRGB(32, 32, 32)];
    UIButton *vipBtn = [UIButton buttonWithType:0];
    vipBtn.frame = CGRectMake(kScreenW-45 *2, 7, 34, 34);
    [vipBtn setImage:kIMAGE_Name(@"svp") forState:0];
    [self.navigationController.navigationBar addSubview:vipBtn];
    [vipBtn addTarget:self action:@selector(vipBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [vipBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.vipBtn = vipBtn;

    [self.view addSubview:self.tableView];
}
-(void)vipBtnAction{
    ACPayTwoViewController *vc = [ACPayTwoViewController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.reloadVip = ^{
        self.vipBtn.hidden = [vipTool isVip];
        [self.tableView reloadData];
    };
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.lineV.hidden = NO;
    self.vipBtn.hidden = [vipTool isVip];
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.lineV.hidden = YES;


}
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-kTabBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.mainBlackColor;
       
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }
        _tableView.scrollEnabled = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"ACToolListTBCell" bundle:nil] forCellReuseIdentifier:@"ACToolListTBCell"];
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACToolListTBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACToolListTBCell"];
    cell.leftImageV.image = kIMAGE_Name(self.imageNameArr[indexPath.row]);
    cell.titleL.text = self.titleArr[indexPath.row];
    cell.vipIcon.hidden = true;
    if ((indexPath.row == 0 || indexPath.row == 1 ||indexPath.row == 3) && ![vipTool isVip]) {
        cell.vipIcon.hidden = false;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //[playVolume playMusic];
//    if ((indexPath.row == 0 || indexPath.row == 1 ||indexPath.row == 3) && ![vipTool isVip]) {
//        [self vipBtnAction];
//    }
    if(indexPath.row==0){
        ACPrivacyAblumVC *pushVC = [[ACPrivacyAblumVC  alloc] init];
        pushVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pushVC animated:YES];
    }else if (indexPath.row==1){
        ACPrivacyBrowseVC *pushVC = [[ACPrivacyBrowseVC  alloc] init];
        pushVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pushVC animated:YES];
    }else if (indexPath.row==4){
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:nil pushPhotoPickerVc:YES];
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            ACImageCropVC *pushVC = [[ACImageCropVC  alloc] init];
            pushVC.hidesBottomBarWhenPushed = true;
            pushVC.originalImage = photos[0];
            pushVC.ratio = 0.56;
            pushVC.clipType = WEClipImageMoveBox;
            pushVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pushVC animated:YES];
        }];
        imagePickerVc.iconThemeColor = UIColor.mainBlackColor;
        imagePickerVc.allowTakeVideo = NO;
        imagePickerVc.allowTakePicture = NO;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPreview = NO;
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }else if (indexPath.row==3){
        ACDocumentScanVC *pushVC = [[ACDocumentScanVC  alloc] init];
        pushVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pushVC animated:YES];

    }else if (indexPath.row==2){
        ACHandleVC *pushVC = [[ACHandleVC  alloc] init];
        pushVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pushVC animated:YES];
    }else if (indexPath.row==5){
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:nil pushPhotoPickerVc:YES];
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            ACGridLayoutVC *pushVC = [[ACGridLayoutVC  alloc] init];
            pushVC.oriImage = photos[0];
            pushVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pushVC animated:YES];
        }];
        imagePickerVc.iconThemeColor = UIColor.mainBlackColor;
        imagePickerVc.allowTakeVideo = NO;
        imagePickerVc.allowTakePicture = NO;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPreview = NO;
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerVc animated:YES completion:nil];

    }
}
//设置
-(void)setClicked{
    ACSettingVC *pushVC = [[ACSettingVC  alloc] init];
    pushVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pushVC animated:YES];
    //[playVolume playMusic];

}

@end
