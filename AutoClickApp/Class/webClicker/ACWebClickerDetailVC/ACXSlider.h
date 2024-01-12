//
//  ACXSlider.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/31.
//

#import <UIKit/UIKit.h>
typedef void(^valueChangeBlock)(int index);
NS_ASSUME_NONNULL_BEGIN

@interface ACXSlider : UIControl

/**
 *  回调
 */
@property (nonatomic,copy)valueChangeBlock block;


/**
 *  初始化方法
 *
 *  @param frame
 *  @param titleArray         必传，传入节点数组
 *  @param firstAndLastTitles 首，末位置的title
 *  @param defaultIndex       必传，范围（0到(array.count-1)）
 *  @param sliderImage        传入画块图片
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame
                      titles:(NSArray *)titleArray
          firstAndLastTitles:(NSArray *)firstAndLastTitles
                defaultIndex:(CGFloat)defaultIndex
                 sliderImage:(UIImage *)sliderImage;

/**
 *  必传，范围（0到(array.count-1)）
 */
@property (nonatomic,assign)CGFloat defaultIndx;
@end

NS_ASSUME_NONNULL_END
