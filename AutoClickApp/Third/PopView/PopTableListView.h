//
//  PopTableListView.h
//  PopView
//
//  Created by 李林 on 2018/2/28.
//  Copyright © 2018年 李林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopTableListView : UIView
- (instancetype)initWithTitles:(NSArray <NSString *>*)titles imgNames:(NSArray <NSString *>*)imgNames;
@property (nonatomic, copy) void (^selectTitleBlock) (NSInteger index);
@end
