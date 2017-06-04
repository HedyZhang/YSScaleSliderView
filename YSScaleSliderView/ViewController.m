//
//  ViewController.m
//  YSScaleSliderView
//
//  Created by zhanghaidi on 2017/6/4.
//  Copyright © 2017年 zhanghaidi. All rights reserved.
//

#import "ViewController.h"
#import "YSScaleSliderView.h"


@interface ViewController ()
/**
 申请金额
 */
@property (nonatomic, strong) YSScaleSliderView *monenySlierView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.monenySlierView];
    // Do any additional setup after loading the view, typically from a nib.
}


- (YSScaleSliderView *)monenySlierView {
    if (!_monenySlierView) {
        _monenySlierView = [[YSScaleSliderView alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 70)];
        _monenySlierView.units = @"元";
        _monenySlierView.step = 1000;
        _monenySlierView.scaleLineNumber = 9;
        _monenySlierView.currentIdx = 3;
        _monenySlierView.minimumValue = 1000;
        _monenySlierView.maximumValue = 10000;
    }
    return _monenySlierView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
