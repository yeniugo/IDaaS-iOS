//
//  TRUApplicationTopView.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/27.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUApplicationTopView.h"
#import "TRUHomeButton.h"
#import "TRUOtherButton.h"
#import "TRUDevicesManagerController.h"
#import "TRUSessionManagerViewController.h"
#import <Lottie/Lottie.h>


@interface TRUApplicationTopView()

@property (nonatomic, weak)LOTAnimationView *popLotView;

@end

@implementation TRUApplicationTopView
{
    UIImageView *deviceImgview;
    
}
-(void)drawRect:(CGRect)rect{
    UIColor *color = RGBCOLOR(32, 144, 54);
    [color set]; //设置线条颜色
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 1.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    [aPath moveToPoint:CGPointMake(0, 0)];
    [aPath addLineToPoint:CGPointMake(0, 220)];
    [aPath addQuadCurveToPoint:CGPointMake(SCREENW, 220) controlPoint:CGPointMake(SCREENW/2.f, 240)];
    [aPath addLineToPoint:CGPointMake(SCREENW, 0)];
    [aPath addLineToPoint:CGPointMake(0, 0)];
    [aPath fill];
    [aPath stroke];
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self customUI];
    }
    return self;
}

-(void)lotAnimationViewPlay:(TRUHomeButton *)btn{
    _popLotView.size = CGSizeMake(50, 50);
    _popLotView.centerX = btn.centerX;
    _popLotView.centerY = btn.centerY;
    _popLotView.hidden = NO;
}

-(void)customUI{
    
    __weak typeof(self) weakSelf = self;
    
    //动画
    LOTAnimationView *lotview = [LOTAnimationView animationNamed:@"topMenuClick.json"];
    [self addSubview:lotview];
    lotview.hidden = YES;
    _popLotView = lotview;
    
    self.backgroundColor = RGBCOLOR(234, 235, 236);
    CGFloat Y = 70;
    CGFloat gapY = 20;
    _identifyBtn = [[TRUHomeButton alloc] initWithFrame:CGRectMake(SCREENW/12.f, Y, SCREENW/6.f, SCREENW/6.f) withTitle:@"今日验证" image:@"topMenu1" andButtonClickEvent:^(TRUHomeButton *sender) {
//        YCLog(@"点击验证....");
//        [weakSelf lotAnimationViewPlay:sender];
//        [_popLotView playWithCompletion:^(BOOL animationFinished) {
//            if (animationFinished) {
//                self.popLotView.hidden = YES;
//            }
//        }];
    }];
    [self addSubview:_identifyBtn];
    UIImageView *newsImgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topMenuNews2"]];
    newsImgview.frame = CGRectMake(SCREENW/5.f, Y - 15, 16, 16);
    [self addSubview:newsImgview];
    
    _identifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    _identifyLabel.text = @"0";
    [_identifyLabel setTextColor:[UIColor whiteColor]];
    _identifyLabel.textAlignment = NSTextAlignmentCenter;
    _identifyLabel.font = [UIFont systemFontOfSize:9];
    [newsImgview addSubview:_identifyLabel];
    
    
    _requestBtn = [[TRUHomeButton alloc] initWithFrame:CGRectMake(SCREENW/4.f *3 , Y, SCREENW/6.f, SCREENW/6.f) withTitle:@"当前请求" image:@"topMenu3" andButtonClickEvent:^(TRUHomeButton *sender) {
//        YCLog(@"点击请求....");
        [weakSelf lotAnimationViewPlay:sender];
        [_popLotView playWithCompletion:^(BOOL animationFinished) {
            if (animationFinished) {
                self.popLotView.hidden = YES;
                if (_detailPushVC) {
                    _detailPushVC();
                }
            }
        }];
        
    }];
    [self addSubview:_requestBtn];
    _requestImgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topMenuNews"]];
    _requestImgview.frame = CGRectMake(SCREENW/7.f *6 + 3, Y - 15, 16, 16);
    [self addSubview:_requestImgview];
    
    _requestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    _requestLabel.text = @"0";
    [_requestLabel setTextColor:[UIColor whiteColor]];
    _requestLabel.textAlignment = NSTextAlignmentCenter;
    _requestLabel.font = [UIFont systemFontOfSize:10];
    [_requestImgview addSubview:_requestLabel];
    
    
    _deviceManagerBtn = [[TRUHomeButton alloc] initWithFrame:CGRectMake(SCREENW/12.f, Y + SCREENW/6.f + gapY, SCREENW/6.f, SCREENW/6.f) withTitle:@"设备管理" image:@"topMenu4" andButtonClickEvent:^(TRUHomeButton *sender) {
        [weakSelf lotAnimationViewPlay:sender];
        [_popLotView playWithCompletion:^(BOOL animationFinished) {
            if (animationFinished) {
                self.popLotView.hidden = YES;
                TRUDevicesManagerController *vc = [[TRUDevicesManagerController alloc] init];
                [self.MainVc.navigationController pushViewController:vc animated:YES];
            }
            
        }];
        
    }];
    [self addSubview:_deviceManagerBtn];
    deviceImgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topMenuNews"]];
    deviceImgview.frame = CGRectMake(SCREENW/5.f, Y + SCREENW/6.f+5, 16, 16);
    [self addSubview:deviceImgview];
    
    _deviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    _deviceLabel.text = @"";
    [_deviceLabel setTextColor:[UIColor whiteColor]];
    _deviceLabel.textAlignment = NSTextAlignmentCenter;
    _deviceLabel.font = [UIFont systemFontOfSize:10];
    [deviceImgview addSubview:_deviceLabel];
    
    
    
    _UseragreementBtn = [[TRUHomeButton alloc] initWithFrame:CGRectMake(SCREENW/4.f *3, Y + SCREENW/6.f + gapY, SCREENW/6.f , SCREENW/6.f ) withTitle:@"登录控制" image:@"topMenu2" andButtonClickEvent:^(TRUHomeButton *sender) {
        [weakSelf lotAnimationViewPlay:sender];
//        YCLog(@"登录控制....");
        
        [_popLotView playWithCompletion:^(BOOL animationFinished) {
            if (animationFinished) {
                self.popLotView.hidden = YES;
                TRUSessionManagerViewController *sessionVC = [[TRUSessionManagerViewController alloc] init];
                [weakSelf.MainVc.navigationController pushViewController:sessionVC animated:YES];
            }
            
        }];
        
    }];
    [self addSubview:_UseragreementBtn];
    
    _BigImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW/3.f, SCREENW/3.f)];
    [self addSubview:_BigImageview];
//    [_BigImageview setImage:[UIImage imageNamed:@"circular"]];
    _BigImageview.center = CGPointMake(self.center.x, self.center.y + 25);
}






-(void)bigViewsHidden:(float)alphaA{
    
    //动态图
    CGFloat imgviewW = (SCREENW/3.f - 60)*(1 - alphaA) + 55;
    _BigImageview.frame = CGRectMake(0, 0, imgviewW, imgviewW);
    _BigImageview.center = CGPointMake(self.center.x, (self.center.y + 25) + 73 *alphaA);
    
    _UseragreementBtn.alpha = 1-alphaA;
    _deviceManagerBtn.alpha = 1-alphaA;
    _requestBtn.alpha = 1-alphaA;
    _identifyBtn.alpha = 1-alphaA;
    deviceImgview.alpha = 1-alphaA;
    
    if (alphaA == 1) {

        _UseragreementBtn.hidden = YES;
        _deviceManagerBtn.hidden = YES;
        _requestBtn.hidden = YES;
        _identifyBtn.hidden = YES;


    }else{
        _UseragreementBtn.hidden = NO;
        _deviceManagerBtn.hidden = NO;
        _requestBtn.hidden = NO;
        _identifyBtn.hidden = NO;

    }

}



@end
