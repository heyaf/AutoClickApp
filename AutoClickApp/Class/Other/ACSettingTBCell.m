//
//  ACSettingTBCell.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/9.
//

#import "ACSettingTBCell.h"

@implementation ACSettingTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView addSubview:self.swiTch];
    BOOL stopPlay = [kUserDefaults boolForKey:@"stopPlay"];
    self.swiTch.on = !stopPlay;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UISwitch *)swiTch{
    if(!_swiTch){
        _swiTch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenW-40-40, 4, 40, 24)];
        _swiTch.onTintColor = [UIColor colorWithHexString:@"#AF52DE"];
        _swiTch.backgroundColor = [UIColor colorWithHexString:@"#272226"];
        
        [_swiTch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _swiTch;
}
-(void)switchAction:(UISwitch *)switchU{
    
    if (switchU.isOn) {
        [kUserDefaults setBool:NO forKey:@"stopPlay"];

    }else{
        
        [kUserDefaults setBool:YES forKey:@"stopPlay"];


    }
    //[playVolume playMusic];
}
@end
