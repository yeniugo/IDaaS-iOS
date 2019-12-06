//
//  TRUBottomScanView.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/8/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUBottomScanView.h"
#import "TRUAuthBtn.h"
#import "UIImage+Color.h"
#import "TRUAuthBtn.h"
@interface TRUBottomScanView ()
@property (nonatomic,strong) UIButton *scanBtn;
@property (nonatomic,strong) UIButton *qrBtn;
//@property (nonatomic,strong) UIImageView *scanIcon;
//@property (nonatomic,strong) UIImageView *qrIcon;
@property (nonatomic,strong) TRUAuthBtn *authBtn;
@property (nonatomic,strong) CALayer *scanLayer;
@property (nonatomic,strong) CALayer *qrLayer;
@property (nonatomic,strong) UIImageView *scanIcon;
@property (nonatomic,strong) UILabel *scanLabel;
@end

@implementation TRUBottomScanView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        CALayer *loginBtnShadow = [CALayer layer];
//        loginBtnShadow.frame = self.scanBtn.frame;
        loginBtnShadow.backgroundColor = RGBACOLOR(211,223,229,0.44).CGColor;
        loginBtnShadow.shadowOffset = CGSizeMake(0, 7);
        loginBtnShadow.shadowOpacity = 0.08;
        loginBtnShadow.cornerRadius = 10;
        self.scanLayer = loginBtnShadow;
        [self.layer addSublayer:loginBtnShadow];
        CALayer *loginBtnShadow1 = [CALayer layer];
//        loginBtnShadow1.frame = self.scanBtn.frame;
        loginBtnShadow1.backgroundColor = RGBACOLOR(211,223,229,0.44).CGColor;
        loginBtnShadow1.shadowOffset = CGSizeMake(0, 7);
        loginBtnShadow1.shadowOpacity = 0.08;
        loginBtnShadow1.cornerRadius = 10;
        self.qrLayer = loginBtnShadow1;
        [self.layer addSublayer:loginBtnShadow1];
        CGFloat h;
        if (kDevice_Is_iPhoneX) {
            h = self.bounds.size.height -34;
        }else{
            h = self.bounds.size.height;
        }
        UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        scanBtn.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:scanBtn];
        self.scanBtn = scanBtn;
        [scanBtn addTarget:self action:@selector(scanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *scanIcon = [[UIImageView alloc] init];
        scanIcon.image = [UIImage imageNamed:@"scanBlue"];
        scanIcon.frame = CGRectMake(0, 0, 32*PointWidthRatioX, 32*PointWidthRatioX);
        [scanBtn addSubview:scanIcon];
        [scanIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(scanBtn);
            make.top.equalTo(scanBtn.mas_top).with.offset(0.25*h);
        }];
        self.scanIcon = scanIcon;
        UILabel *scanLabel = [[UILabel alloc] init];
        [scanBtn addSubview:scanLabel];
        scanLabel.text = @"扫一扫";
        [scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(scanBtn);
            make.top.equalTo(scanIcon.mas_bottom).with.offset(0.15*h);
        }];
        self.scanLabel = scanLabel;
        
        UIButton *qrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [qrBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self addSubview:qrBtn];
        self.qrBtn = qrBtn;
        [qrBtn addTarget:self action:@selector(qrButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *qrIcon = [[UIImageView alloc] init];
        qrIcon.image = [UIImage imageNamed:@"qrcodeBlue"];
        qrIcon.frame = CGRectMake(0, 0, 32*PointWidthRatioX, 32*PointWidthRatioX);
        [qrBtn addSubview:qrIcon];
        
        [qrIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(qrBtn);
            make.top.equalTo(qrBtn.mas_top).with.offset(0.25*h);
        }];
        UILabel *qrLabel = [[UILabel alloc] init];
        [qrBtn addSubview:qrLabel];
        qrLabel.text = @"二维码";
        [qrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(qrBtn);
            make.top.equalTo(qrIcon.mas_bottom).with.offset(0.15*h);
        }];
        
        TRUAuthBtn *authBtn = [[TRUAuthBtn alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 60 * PointWidthRatioX)];
        [self addSubview:authBtn];
        self.authBtn = authBtn;
        authBtn.hidden = YES;
        [authBtn addTarget:self action:@selector(authBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanlogin"]];
//        [scanBtn addSubview:imageView];
//        imageView.frame = CGRectMake(34*PointWidthRatioX, 34*PointWidthRatioX, 32*PointWidthRatioX, 32*PointWidthRatioX);
    }
    return self;
}

- (void)setHasQRBtn:(BOOL)hasQRBtn{
    _hasQRBtn = hasQRBtn;
    if (hasQRBtn) {
        [self.scanBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.scanBtn setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(0, 0, 0, 0.01)] forState:UIControlStateHighlighted];
        [self.qrBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.qrBtn setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(0, 0, 0, 0.01)] forState:UIControlStateHighlighted];
        self.scanBtn.frame = CGRectMake(20*PointWidthRatioX, (self.frame.size.height -34.0)*6/40.0, 160*PointWidthRatioX, (self.frame.size.height -34.0)*28/40.0);
        self.qrBtn.frame = CGRectMake(195*PointWidthRatioX, (self.frame.size.height -34.0)*6/40.0, 160*PointWidthRatioX, (self.frame.size.height -34.0)*28/40.0);
        if (!kDevice_Is_iPhoneX) {
            self.scanBtn.frame = CGRectMake(20*PointWidthRatioX, (self.frame.size.height )*5.0/40.0, 160*PointWidthRatioX, (self.frame.size.height )*30.0/40.0);
            self.qrBtn.frame = CGRectMake(195*PointWidthRatioX, (self.frame.size.height )*5.0/40.0, 160*PointWidthRatioX, (self.frame.size.height )*30.0/40.0);
        }
        self.scanBtn.layer.cornerRadius = 8;
        self.scanBtn.layer.masksToBounds = YES;
        self.qrBtn.layer.cornerRadius = 8;
        self.qrBtn.layer.masksToBounds = YES;
        self.scanLayer.frame = self.scanBtn.frame;
        self.qrLayer.frame = self.qrBtn.frame;
        
        
    }else{
        CGFloat w = PointWidthRatioX*100*1.25;
        CGFloat h = w;
        CGFloat x = (SCREENW - w)/2.0;
        CGFloat y = (self.frame.size.height - h)/2.0+7.5*PointWidthRatioX;
        if (kDevice_Is_iPhoneX) {
            y = (self.frame.size.height -34 - h)/2.0+7.5*PointWidthRatioX;
        }
        
        self.scanBtn.frame = CGRectMake(x, y, w, h);
        [self.scanBtn setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
        [self.scanBtn setImage:[UIImage imageNamed:@"saoyisaopress"] forState:UIControlStateHighlighted];
        self.scanIcon.hidden = YES;
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanlogin"]];
//        [self.scanBtn addSubview:imageView];
//        imageView.frame = CGRectMake(34*PointWidthRatioX, 34*PointWidthRatioX, 32*PointWidthRatioX, 32*PointWidthRatioX);
        self.scanBtn.layer.cornerRadius = w/2;
        self.scanBtn.layer.masksToBounds = YES;
        self.qrBtn.hidden = YES;
        self.qrLayer.hidden = YES;
        self.scanLayer.hidden = YES;
        self.scanLabel.hidden = YES;
    }
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

- (void)authBtnClick:(UIButton *)btn{
    if (self.authBtnClick) {
        self.authBtnClick(self.model);
    }
}

- (void)setModel:(TRUPushAuthModel *)model{
    _model = model;
    if (model==nil) {
        self.authBtn.hidden = YES;
    }else{
        self.authBtn.hidden = NO;
        [self.authBtn setButtonTitle:[NSString stringWithFormat:@"正在登录【%@】",model.appname]];
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
