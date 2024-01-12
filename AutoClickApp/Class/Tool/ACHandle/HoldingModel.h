//
//  HoldingModel.h
//  HoldingBarrage
//
//  Created by 魏忠海 on 2018/8/21.
//  Copyright © 2018年 lingji001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HoldingModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *speed;

@property (nonatomic, copy) NSString *fontSize;

@property (nonatomic, copy) NSString *fontName;

@property (nonatomic, copy) UIColor *color;

@property (nonatomic, strong) NSArray <NSString *>*speedArray;

@property (nonatomic, strong) NSArray <NSString *>*fontSizeArray;

@property (nonatomic, strong) NSArray <NSString *>*fontNameArray;

@property (nonatomic, strong) NSArray <UIColor *>*colorArray;

@end
