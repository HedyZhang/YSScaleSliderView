
//
//  QGCreditSliderView.h
//  CreditWallet
//
//  Created by zhanghaidi on 2017/3/28.
//  Copyright © 2017年 zhanghaidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSScaleSlider;
@interface YSScaleSliderView : UIView

@property (nonatomic, strong) YSScaleSlider *slider;
@property (nonatomic, strong) UILabel *minValueLabel;
@property (nonatomic, strong) UILabel *maxValueLabel;

/**
 计量单位
 */
@property (nonatomic, strong) NSString *units;

@property (nonatomic, assign) int step;

/**
 刻度线 刻度数量
 */
@property (nonatomic,assign) NSInteger scaleLineNumber;

/**
 当前滑块所处 刻度的索引
 */
@property (nonatomic,assign ) NSInteger currentIdx;



@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;


- (void)setSliderCurrentIndex:(int)index;

@end
