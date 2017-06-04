//
//  QGCreditSliderView.m
//  CreditWallet
//
//  Created by zhanghaidi on 2017/3/28.
//  Copyright © 2017年 zhanghaidi. All rights reserved.
//

#import "YSScaleSliderView.h"
#import "YSScaleSlider.h"

#define kSliderThumbSize 32.0
#define THUMBNAIL_THUMB_MAGIN 15.0

#define kColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

@interface YSScaleSliderView ()

@property (nonatomic, strong) UILabel *thumbnailLabel;

@end

@implementation YSScaleSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.slider];
        [self addSubview:self.minValueLabel];
        [self addSubview:self.maxValueLabel];
        [self addSubview:self.thumbnailLabel];
    }
    return self;
}

- (void)setSliderCurrentIndex:(int)index {
    self.slider.value = (float)index / self.scaleLineNumber;
    [self setThumbnailTextEnd];
}

- (CGPoint)getThumbCenter {
    //当前拇指的坐标的point
    CGRect trackRect = [self.slider trackRectForBounds:self.slider.bounds];
    CGRect thumbRect = [self.slider thumbRectForBounds:self.slider.bounds trackRect:trackRect value:self.slider.value];
    return thumbRect.origin;
}

- (CGRect)getThumbRect {
    CGRect trackRect = [self.slider trackRectForBounds:self.slider.bounds];
    CGRect thumbRect = [self.slider thumbRectForBounds:self.slider.bounds trackRect:trackRect value:self.slider.value];
    return thumbRect;
}

//按下开始滑动
- (void)scrubbingDidBegin {
    [self setThumbnailTextEnd];
}

//滑动中
- (void)scrubberIsScrolling {
    int currentScale = [self getCurrentScale];
    NSString *currentValueString = [NSString stringWithFormat:@"%d%@", (currentScale + 1) * self.step, self.units];
    self.thumbnailLabel.attributedText = [self valueAttributedStringWithText:currentValueString];
    CGPoint point = [self getThumbCenter];
    if (currentScale != self.scaleLineNumber) {
        self.thumbnailLabel.center = CGPointMake(point.x + 15, point.y - self.thumbnailLabel.frame.size.height / 2.f  - THUMBNAIL_THUMB_MAGIN);
    } else {
        self.thumbnailLabel.center = CGPointMake(point.x, point.y - self.thumbnailLabel.frame.size.height / 2.f  - THUMBNAIL_THUMB_MAGIN);
    }
}

//结束滑动
- (void)scrubbingDidEnd {
    [self setThumbnailTextEnd];
}

//获取当前刻度
- (int)getCurrentScale {
    CGFloat thumbDiameter = [self getThumbRect].size.width;
    CGFloat W = CGRectGetWidth(self.frame);
    CGFloat oneW = (W-thumbDiameter) / self.scaleLineNumber;
    CGFloat offX = [self getThumbCenter].x - thumbDiameter*0.5+oneW*0.5;
    offX = MAX(0, offX);
    offX = MIN(offX, CGRectGetWidth(self.frame));
    
    CGFloat idx = offX/oneW;
    int cIdx = (int)idx;
    cIdx = MIN(cIdx, (int)self.scaleLineNumber);
    cIdx = MAX(cIdx, 0);
    return cIdx;
}

/**
 设置slider滚动时文本的位置
 */
- (void)setThumbnailTextScrolling {
    int currentValue = self.slider.value * (_maximumValue - _minimumValue);
    NSString *currentValueString = [NSString stringWithFormat:@"%d%@", currentValue + (int)_minimumValue, self.units];
    self.thumbnailLabel.attributedText = [self valueAttributedStringWithText:currentValueString];
}

/**
 设置slider滚动结束时文本的位置
 */
- (void)setThumbnailTextEnd {
    int currentScale = [self getCurrentScale];
    self.slider.value = (float)currentScale / self.scaleLineNumber;
    NSString *currentValueString = [NSString stringWithFormat:@"%d%@", (currentScale + 1) * self.step, self.units];
    self.thumbnailLabel.attributedText = [self valueAttributedStringWithText:currentValueString];
    CGPoint point = [self getThumbCenter];
    if (currentScale != self.scaleLineNumber) {
        self.thumbnailLabel.center = CGPointMake(point.x + 15, point.y - self.thumbnailLabel.frame.size.height / 2.f  - THUMBNAIL_THUMB_MAGIN);
    } else {
        self.thumbnailLabel.center = CGPointMake(point.x, point.y - self.thumbnailLabel.frame.size.height / 2.f  - THUMBNAIL_THUMB_MAGIN);
    }
}

- (NSAttributedString *)valueAttributedStringWithText:(NSString *)valueText {
    NSString *valueString = [valueText substringToIndex:valueText.length - 1];
    NSMutableAttributedString *valueAttributedString = [[NSMutableAttributedString alloc] initWithString:valueString];
    NSDictionary *valueAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:22],
                                         NSForegroundColorAttributeName:kColorWithHex(0xA08A59)};
    [valueAttributedString addAttributes:valueAttributedDic range:NSMakeRange(0, valueAttributedString.length)];
    
    
    NSString *unitString = [valueText substringFromIndex:valueText.length - 1];
    NSMutableAttributedString *unitAttributedString = [[NSMutableAttributedString alloc] initWithString:unitString];
    NSDictionary *unitAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                        NSForegroundColorAttributeName:kColorWithHex(0xA08A59)};
    
    [unitAttributedString addAttributes:unitAttributedDic range:NSMakeRange(0, unitAttributedString.length)];
    
    [valueAttributedString appendAttributedString:unitAttributedString];
    return valueAttributedString;
}


- (void)setMinimumValue:(float)minimumValue {
    _minimumValue = minimumValue;
    self.minValueLabel.text = [NSString stringWithFormat:@"%.0f%@", _minimumValue, self.units];
}

- (void)setMaximumValue:(float)maximumValue {
    _maximumValue = maximumValue;
    self.maxValueLabel.text = [NSString stringWithFormat:@"%.0f%@", _maximumValue, self.units];
}

#pragma mark - Getter

- (YSScaleSlider *)slider {
    if (!_slider) {
        _slider = [[YSScaleSlider alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        _slider.center = CGPointMake(_slider.center.x, _slider.frame.size.height / 2.f);
        [_slider setThumbImage:[UIImage imageNamed:@"home_progress_thumbnail"] forState:UIControlStateNormal];
        UIImage * minimumTrackImage = [UIImage imageNamed:@"home_progress_minimumTrack"];
        [_slider setMinimumTrackImage:minimumTrackImage forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:[UIImage imageNamed:@"home_progress_maximumTrack"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(scrubbingDidBegin) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(scrubberIsScrolling) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(scrubbingDidEnd) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel];
        _slider.layer.cornerRadius = minimumTrackImage.size.height / 2.f;
    }
    return _slider;
}

- (UILabel *)minValueLabel {
    if (!_minValueLabel) {
        _minValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.slider.frame) + 10, 100, 20)];
        _minValueLabel.textColor = kColorWithHex(0xA08A59);
        _minValueLabel.font = [UIFont systemFontOfSize:12];
    }
    return _minValueLabel;
}

- (UILabel *)maxValueLabel {
    if (!_maxValueLabel) {
        _maxValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, CGRectGetMaxY(self.slider.frame) + 10, 100, 20)];
        _maxValueLabel.textColor = kColorWithHex(0xA08A59);
        _maxValueLabel.font = [UIFont systemFontOfSize:12];
        _maxValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _maxValueLabel;
}

- (UILabel *)thumbnailLabel {
    if (!_thumbnailLabel) {
        _thumbnailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
        _thumbnailLabel.font = [UIFont boldSystemFontOfSize:22];
        _thumbnailLabel.textAlignment = NSTextAlignmentCenter;
        _thumbnailLabel.textColor = kColorWithHex(0xA08A59);
    }
    return _thumbnailLabel;
}


@end
