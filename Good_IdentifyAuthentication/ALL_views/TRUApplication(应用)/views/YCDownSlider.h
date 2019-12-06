//
//  YCDownSlider.h
//  lottie_jsonTest
//
//  Created by zyc on 2017/10/23.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCDownSlider : UIView

/**
 滑块值变化调用的block 变化都会调用
 */
@property (copy, nonatomic) void(^sliderValueChanged)(CGFloat Value);

/**
 手势停止时，滑块值变化调用的block 变化都会调用
 */
@property (copy, nonatomic) void(^sliderValueEnd)(CGFloat Value);

@end
