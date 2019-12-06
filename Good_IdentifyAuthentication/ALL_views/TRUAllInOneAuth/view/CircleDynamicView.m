//
//  CircleDynamicView.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/8/9.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "CircleDynamicView.h"
#import "MYCircleView.h"
#import "UILabel+Alignment.h"
@interface CircleDynamicView ()
@property (nonatomic,strong) MYCircleView *myCicleView;

/**
 动态口令，四个字
 */
@property (nonatomic,strong) UILabel *dynamicLB;

/**
 动态口令数字
 */
@property (nonatomic,strong) UILabel *passwordLB;

/**
 倒计时
 */
@property (nonatomic,strong) UILabel *countLB;
@end


@implementation CircleDynamicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat w = frame.size.width*0.76;
        CGFloat h = w;
        CGFloat x = frame.size.width*0.12;
        CGFloat y = (frame.size.height - h)/2.0;
        CGRect circleFrame = CGRectMake(x, y, w, h);
        MYCircleView *myCicleView = [[MYCircleView alloc] initWithFrame:circleFrame];
        [self addSubview:myCicleView];
        self.myCicleView = myCicleView;
        
        
        
        UILabel *dynamicLB = [[UILabel alloc] init];
        dynamicLB.font = [UIFont systemFontOfSize:16*PointHeightRatioX3];
        dynamicLB.text = @"动态口令";
        dynamicLB.textAlignment = NSTextAlignmentCenter;
        dynamicLB.textColor = RGBCOLOR(51, 51, 51);
        [self addSubview:dynamicLB];
        self.dynamicLB = dynamicLB;
        dynamicLB.frame = CGRectMake(0, y + 0.25 * w - 15*PointHeightRatioX3/2 , SCREENW, 15*PointHeightRatioX3);
//        [dynamicLB textAlignmentLeftAndRight];
        
        UILabel *passwordLB = [[UILabel alloc] init];
        passwordLB.font = [UIFont systemFontOfSize:60*PointHeightRatioX3];
        if ([UIScreen mainScreen].scale > 2.1) {
            passwordLB.font = [UIFont systemFontOfSize:50*PointHeightRatioX3];
        }
        passwordLB.textAlignment = NSTextAlignmentCenter;
        passwordLB.textColor = RGBCOLOR(51, 51, 51);
        [self addSubview:passwordLB];
        passwordLB.frame = CGRectMake(89*PointWidthRatioX, 0.5*frame.size.height -50*PointHeightRatioX3/2 , SCREENW-89*2*PointWidthRatioX, 50*PointHeightRatioX3);
        self.passwordLB = passwordLB;
//        [passwordLB textAlignmentLeftAndRight];
        
        UILabel *countLB = [[UILabel alloc] init];
        countLB.font = [UIFont systemFontOfSize:14*PointHeightRatioX3];
        countLB.textAlignment = NSTextAlignmentCenter;
        countLB.textColor = RGBCOLOR(153,153,153);
        [self addSubview:countLB];
        countLB.frame = CGRectMake(0, y + 0.75 * h - 14*PointHeightRatioX3/2.0 , SCREENW, 14 *PointHeightRatioX3);
        self.countLB = countLB;
    }
    return self;
}

- (void)setPercent:(CGFloat)percent{
    _percent = percent;
    self.myCicleView.percent = percent;
    int time = 30*percent;
    self.countLB.text = [NSString stringWithFormat:@"%d秒后失效",30-time-1];
}

- (void)setPasswordStr:(NSString *)passwordStr{
    _passwordStr = passwordStr;
    self.passwordLB.text = passwordStr;
    [self.passwordLB textAlignmentLeftAndRight];
}

@end
