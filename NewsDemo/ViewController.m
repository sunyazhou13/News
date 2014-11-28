//
//  ViewController.m
//  NewsDemo
//
//  Created by sunyazhou on 14/11/16.
//  Copyright (c) 2014年 百度时代网络技术(北京)有限公司. All rights reserved.
//

#import "ViewController.h"
#import <POP.h>
#import "FBTweak.h"
#import "FBTweakShakeWindow.h"
#import "FBTweakInline.h"
#import "FBTweakViewController.h"
#import "DVSwitch.h"
#import "newsDemo-swift.h"


@interface ViewController ()
@property (strong, nonatomic) DVSwitch *switcher;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    FBTweak *animationDurationTweak = FBTweakInline(@"Content", @"Animation", @"Duration",2.0,1.0,3.0);
    animationDurationTweak.stepValue = [NSNumber numberWithFloat:0.1f];
    animationDurationTweak.precisionValue = [NSNumber numberWithFloat:3.0f];
    
    FBTweak *animationToValueTweak = FBTweakInline(@"Content", @"Animation", @"ToValue",10240,1000,10000);
    animationToValueTweak.stepValue = @(1000);
    
    animationDurationTweak.precisionValue = [NSNumber numberWithFloat:1.0f];
    
    if (self.switcher == nil) {
        self.switcher = [[DVSwitch alloc] initWithStringsArray:@[@"", @""]];
        self.switcher.frame = CGRectMake(50, 200, 240, 120);
        self.switcher.cornerRadius = 60;        
    }
    self.switcher.backgroundColor = [UIColor greenColor];
    self.switcher.sliderColor = [UIColor whiteColor];
    self.switcher.sliderOffset = 1;
    [self.view addSubview:self.switcher];\
    __weak __typeof(self) weakSelf = self;
    
    [self.switcher setPressedHandler:^(NSUInteger index) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (index == 1) {
            strongSelf.switcher.backgroundColor = [UIColor blackColor];
        }else {
            strongSelf.switcher.backgroundColor = [UIColor greenColor];
        }
        
        NSLog(@"Did press position on first switch at index: %lu", (unsigned long)index);
        
    }];
   
}

/*!
 *  触发的时候加动画效果
 *
 *  @param sender button
 */
- (IBAction)animationButtonClick:(UIButton *)sender {
    
    POPBasicAnimation *animation = [[POPBasicAnimation alloc] init];
    animation.property = [self animationProperty];
    animation.fromValue = @(0);
    animation.toValue = @(10250);
    animation.duration = 2.0f;
    //普通的动画效果
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //修改animation的时间函数
//    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.12 :1 :0.11 :0.94];
    animation.duration = FBTweakValue(@"Content", @"Animation", @"Duration", 2.0);
    animation.toValue = @(FBTweakValue(@"Content", @"Animation", @"ToValue", 10240));
    
    [self.label pop_addAnimation:animation forKey:@"numberLabelAnimation"];
    
}

/*!
 *  返回pop需要的动画属性和回调
 *
 *  @return POPMutableAnimatableProperty
 */
- (POPMutableAnimatableProperty *) animationProperty {
    return [POPMutableAnimatableProperty
            propertyWithName:@"com.baidu.animation"
            initializer:^(POPMutableAnimatableProperty *prop) {
                prop.writeBlock = ^(id obj, const CGFloat valuse[]) {
                    //这里改label.text
                    UILabel *label = (UILabel *)obj;
                    NSNumber *number = @(valuse[0]);
                    double num = [number doubleValue];
                    NSString *kbs = [NSString stringWithFormat:@"%.2lf kbp/s",num];
                    label.text = kbs;
                };
            }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
