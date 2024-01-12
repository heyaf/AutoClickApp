//
//  ACDocumentScanDetailVC.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACDocumentScanDetailVC : UIViewController
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, assign) NSInteger indexRow;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, copy) void (^refreshBlock) (void);

@end

NS_ASSUME_NONNULL_END
