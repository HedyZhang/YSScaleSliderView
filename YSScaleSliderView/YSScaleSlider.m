//
//  QGCreditSlider.m
//  CreditWallet
//
//  Created by zhanghaidi on 2017/3/30.
//  Copyright © 2017年 zhanghaidi. All rights reserved.
//

#import "YSScaleSlider.h"

@implementation YSScaleSlider

//解决自定义slider 大头针，两边有空隙的问题，并解决大头针的y轴偏移
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    rect.origin.x = rect.origin.x - 10 ;
    rect.size.width = rect.size.width + 20;
    rect.origin.y = rect.origin.y + 2;
    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value], 10 , 10);
}

@end
