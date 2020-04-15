//
//  TFGestureModify1ViewController.m
//  Trusfort
//
//  Created by muhuaxin on 16/4/16.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUGestureModify1ViewController.h"
#import "TRUGestureModify2ViewController.h"
#import "HUIPatternLockView.h"
#import "AppDelegate.h"
#import "UINavigationBar+BackgroundColor.h"
#import "xindunsdk.h"
#import "TRUFingerGesUtil.h"
#import "TRUUserAPI.h"
#import <Lottie/Lottie.h>
#import "TRULicenseAgreementViewController.h"

@interface TRUGestureModify1ViewController ()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) HUIPatternLockView *patternLockView;
@property (nonatomic, strong) LOTAnimationView *identifylotView;
@property (nonatomic, strong) LOTAnimationView *loadlotView;

@end

@implementation TRUGestureModify1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

#pragma mark - Private methods

- (void)setupViews {
    
    __weak typeof(self) weakSelf = self;
    
//    self.title = @"重置手势";
    
    self.linelabel.hidden = YES;
    
    //iconImgview lotview
    CGFloat lastY = 100;
    
    UIImageView *iconImgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"roundicon"]];
    [self.view addSubview:iconImgview];
    iconImgview.frame = CGRectMake(SCREENW/2.f - 50, 60, 100, 100);
    if (kDevice_Is_iPhoneX) {
        iconImgview.frame = CGRectMake(SCREENW/2.f - 50, 100, 100, 100);
    }else{
        iconImgview.frame = CGRectMake(SCREENW/2.f - 50, 60, 100, 100);
    }
    _identifylotView= [LOTAnimationView animationNamed:@"GestureAppend.json"];
    _identifylotView.size = CGSizeMake(160, 160);
    _identifylotView.centerX = self.view.centerX;
    _identifylotView.centerY = iconImgview.centerY;
    [self.view addSubview:_identifylotView];
    _identifylotView.hidden = YES;
    
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.font = [UIFont systemFontOfSize:15];
    topLabel.text = @"请输入原手势";
    topLabel.textColor = [UIColor darkGrayColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.frame = CGRectMake(0, lastY + 75, SCREEN_WIDTH, 20);
    [self.view addSubview:topLabel];
    self.topLabel = topLabel;
    
    if (kDevice_Is_iPhoneX) {
        topLabel.frame = CGRectMake(0, lastY + 115, SCREEN_WIDTH, 20);
    }else{
        topLabel.frame = CGRectMake(0, lastY + 75, SCREEN_WIDTH, 20);
    }
    
    //指纹矩阵出现前的动画
    _loadlotView= [LOTAnimationView animationNamed:@"Gestureloading.json"];
    _loadlotView.size = CGSizeMake(230, 230);
    _loadlotView.centerX = self.view.width / 2.0;
    _loadlotView.y = topLabel.bottom + 30;
    [self.view addSubview:_loadlotView];
    
    //指纹矩阵
    UIImage *normalDotImage = [UIImage imageNamed:@"ges_normal"];
    UIImage *highlightedDotImage = [UIImage imageNamed:@"ges_selected"];
    HUIPatternLockView *patternLockView = [[HUIPatternLockView alloc] init];
    patternLockView.backgroundColor = [UIColor clearColor];
    patternLockView.size = CGSizeMake(252, 252);
    patternLockView.centerX = self.view.width / 2.0;
    if (kDevice_Is_iPhoneX) {
        patternLockView.y = topLabel.bottom + 60;
    }else{
        patternLockView.y = topLabel.bottom + 20;
    }
    patternLockView.normalDotImage = normalDotImage;
    patternLockView.highlightedDotImage = highlightedDotImage;
    patternLockView.lineWidth = 6;
    patternLockView.lineColor = lineDefaultColor;
    patternLockView.didDrawPatternWithPassword = ^(HUIPatternLockView *lockView, NSUInteger dotCounts, NSString *password){
        [weakSelf verifyGesture:password];
    };
    self.patternLockView = patternLockView;
    
    [_loadlotView playWithCompletion:^(BOOL animationFinished) {
        //在动画完成后，添加指纹矩阵
        
        if (animationFinished) {
            weakSelf.loadlotView.hidden = YES;
            [weakSelf.view addSubview:patternLockView];
        }
        
    }];
    
    
    
    //用户协议
//    UILabel * txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW/2.f - 122, SCREENH - 50, 165, 20)];
//    [self.view addSubview:txtLabel];
//    txtLabel.text = @"善认·一站式移动身份管理";
//    txtLabel.font = [UIFont systemFontOfSize:14];
//    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:agreementBtn];
//    agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 50, 90, 20);
//    [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
//    [agreementBtn setTitleColor:RGBCOLOR(32, 144, 54) forState:UIControlStateNormal];
//    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [agreementBtn addTarget:self action:@selector(lookUserAgreement) forControlEvents:UIControlEventTouchUpInside];
//    if (kDevice_Is_iPhoneX) {
//        txtLabel.frame =CGRectMake(SCREENW/2.f - 122, SCREENH - 80, 165, 20);
//        agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 80, 90, 20);
//    }
    
}

- (void)verifyGesture:(NSString *)gesture {
    NSString *encryptedGesture = [self encryptGesture:gesture];
    UIColor *wrongLineColor = [UIColor redColor];
    if (!encryptedGesture) {
        return;
    }
    if ([encryptedGesture isEqualToString:[TRUFingerGesUtil getGesturePwd]]) {
        _topLabel.text = @"验证成功";
        _identifylotView.hidden = NO;
        [_identifylotView playWithCompletion:^(BOOL animationFinished) {
            [self.patternLockView resetDotsState];
            [self.patternLockView setLineColor:lineDefaultColor];
            TRUGestureModify2ViewController *modifyViewController = [[TRUGestureModify2ViewController alloc] init];
            modifyViewController.oldEncryptedGesture = encryptedGesture;
            [self.navigationController pushViewController:modifyViewController animated:NO];
        }];
    }else{
        self.topLabel.text = @"图案错误，请重试";
        self.topLabel.textColor = wrongLineColor;
        self.patternLockView.lineColor = wrongLineColor;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.topLabel.text = @"手势密码不正确请重试";
            [self.patternLockView resetDotsState];
            [self.patternLockView setLineColor:lineDefaultColor];
            self.topLabel.textColor = [UIColor darkGrayColor];
        });
        
    }
}

- (NSString *)encryptGesture:(NSString *)gesture {
    if (gesture.length == 0) {
        return nil;
    }
    char buf[256] = {0};
    const char *ges = [gesture UTF8String];
    for (int i=0;i<strlen(ges)/3;i++){
        int pid = ges[i*3+1] - '0';
        switch(pid){
            case 0:
                snprintf(buf, 256, "%sA00,B00,", buf);
                break;
            case 1:
                snprintf(buf, 256, "%sA01,B00,", buf);
                break;
            case 2:
                snprintf(buf, 256, "%sA02,B00,", buf);
                break;
            case 3:
                snprintf(buf, 256, "%sA00,B01,", buf);
                break;
            case 4:
                snprintf(buf, 256, "%sA01,B01,", buf);
                break;
            case 5:
                snprintf(buf, 256, "%sA02,B01,", buf);
                break;
            case 6:
                snprintf(buf, 256, "%sA00,B02,", buf);
                break;
            case 7:
                snprintf(buf, 256, "%sA01,B02,", buf);
                break;
            case 8:
                snprintf(buf, 256, "%sA02,B02,", buf);
                break;
        }
    }
    NSString *newges = [NSString stringWithFormat:@"%s", buf];
    NSLog(@"加密手势：%@", newges);
    NSString *userId =[TRUUserAPI getUser].userId;
    return [xindunsdk encryptData:newges ForUser:userId];
}



#pragma mark - 用户协议 UserAgreement
-(void)lookUserAgreement{
    TRULicenseAgreementViewController *lisenceVC = [[TRULicenseAgreementViewController alloc] init];
    [self.navigationController pushViewController:lisenceVC animated:YES];
}
@end

