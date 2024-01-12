//
//  ACImageCropViewController.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/7.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , WEClipImageType) {
    WEClipImageMoveImage,
    WEClipImageMoveBox
};

@protocol WEClipImageViewControllerDelegate <NSObject>

- (void)finishClipImage:(UIImage*)image;

- (void)clipImageClean;

@end
@interface ACImageCropViewController : UIViewController
/** 裁切宽高 */
@property (nonatomic,assign) CGSize clipSize;
/** 宽高比例 */
@property (nonatomic,assign) CGFloat ratio;
/** 原始图片 */
@property (nonatomic,strong) UIImage* originalImage;
/** 裁图类型 */
@property (nonatomic,assign) WEClipImageType clipType;

@property (nonatomic,assign) id <WEClipImageViewControllerDelegate> delegate;
@end

