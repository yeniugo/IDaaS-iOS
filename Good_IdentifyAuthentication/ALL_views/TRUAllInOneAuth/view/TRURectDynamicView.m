//
//  TRURectDynamicView.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/8/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRURectDynamicView.h"
#import "UILabel+Alignment.h"
@interface TRURectDynamicView ()

/**
 动态口令
 */
@property (nonatomic,strong) UILabel *passwordLB;

/**
 进度条
 */
@property (nonatomic,strong) UIProgressView *progressView;

/**
 扫码按钮
 */
@property (nonatomic,strong) UIButton *scanBtn;

/**
 二维码按钮
 */
@property (nonatomic,strong) UIButton *qrBtn;
@end

@implementation TRURectDynamicView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *passwordLB = [[UILabel alloc] init];
        [self addSubview:passwordLB];
        self.passwordLB = passwordLB;
        passwordLB.textAlignment = NSTextAlignmentCenter;
        
        UIProgressView *progressView = [[UIProgressView alloc] init];
        CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI );
        [progressView setTransform:rotate];
        progressView.trackTintColor = RGBACOLOR(51, 51, 51,0.2);
        progressView.progressTintColor = RGBCOLOR(0, 150, 255);
        [self addSubview:progressView];
        self.progressView = progressView;
        
        UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [scanBtn setBackgroundImage:[UIImage imageNamed:@"scanBlue"] forState:UIControlStateNormal];
        [self addSubview:scanBtn];
        self.scanBtn = scanBtn;
        [scanBtn addTarget:self action:@selector(scanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *qrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [qrBtn setBackgroundImage:[UIImage imageNamed:@"qrcodeBlue"] forState:UIControlStateNormal];
        [self addSubview:qrBtn];
        self.qrBtn = qrBtn;
        [qrBtn addTarget:self action:@selector(qrButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setHasScanBtn:(BOOL)hasScanBtn{
    _hasScanBtn = hasScanBtn;
    if (hasScanBtn) {
        self.passwordLB.frame = CGRectMake(35*PointWidthRatioX, 40*PointWidthRatioX, 178*PointWidthRatioX, 33*PointWidthRatioX);
        self.passwordLB.font = [UIFont systemFontOfSize:44*PointWidthRatioX];
        self.progressView.frame = CGRectMake(35*PointWidthRatioX, 92*PointWidthRatioX, 178*PointWidthRatioX, 1);
        self.scanBtn.frame = CGRectMake(262*PointWidthRatioX, 44*PointWidthRatioX, 27*PointWidthRatioX, 27*PointWidthRatioX);
        self.qrBtn.frame = CGRectMake(319*PointWidthRatioX, 44*PointWidthRatioX, 27*PointWidthRatioX, 27*PointWidthRatioX);
    }else{
        self.passwordLB.frame = CGRectMake(35*PointWidthRatioX, 40*PointWidthRatioX, 178*PointWidthRatioX, 33*PointWidthRatioX);
        self.passwordLB.font = [UIFont systemFontOfSize:44*PointWidthRatioX];
        self.progressView.frame = CGRectMake(35*PointWidthRatioX, 92*PointWidthRatioX, 178*PointWidthRatioX, 1);
        self.scanBtn.frame = CGRectMake(305*PointWidthRatioX, 44*PointWidthRatioX, 27*PointWidthRatioX, 27*PointWidthRatioX);
    }
}

- (void)setPercent:(CGFloat)percent{
    _percent = percent;
    self.progressView.progress = 1 - percent;
}

-(void)setPasswordStr:(NSString *)passwordStr{
    _passwordStr = passwordStr;
    self.passwordLB.text = passwordStr;
    [self.passwordLB textAlignmentLeftAndRight];
}

- (void)scanButtonClick:(UIButton *)btn{
    if (self.scanButtonClick) {
        self.scanButtonClick();
    }
}

- (void)qrButtonClick:(UIButton *)btn{
    if (self.qrButtonClick) {
        self.qrButtonClick();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
