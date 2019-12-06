//
//  YCAnimationNumberView.h
//  YCFlopAnimation
//
//  Created by zyc on 2017/11/17.
//  Copyright © 2017年 YC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCAnimationNumberView : UIView

///是否是声纹
@property (nonatomic, assign) BOOL isVoice;
///背景颜色
@property (nonatomic, strong) UIColor *bgColor;
///font
@property (nonatomic, strong) UIFont *textFont;
/// 间距 默认是3.f
@property (nonatomic, assign) CGFloat spacing;
/// 赋值
@property (nonatomic, strong) NSString *text;
///赋值
-(void)setNumberStr:(NSString *)numstr isFirst:(BOOL)isFirst;


@end
