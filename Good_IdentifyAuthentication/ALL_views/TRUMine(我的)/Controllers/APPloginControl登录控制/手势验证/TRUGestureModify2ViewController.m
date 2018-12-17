//
//  TFGestureModify2ViewController.m
//  Trusfort
//
//  Created by muhuaxin on 16/4/16.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUGestureModify2ViewController.h"
#import "HUIPatternLockView.h"
#import "AppDelegate.h"
#import "UINavigationBar+BackgroundColor.h"
#import "TRUFingerGesUtil.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import <Lottie/Lottie.h>
#import "TRULicenseAgreementViewController.h"
#import "TRUCompanyAPI.h"
#import <YYWebImage.h>
#import "TRUEnterAPPAuthView.h"


@interface TRUGestureModify2ViewController ()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) HUIPatternLockView *patternLockView;
@property (nonatomic, strong) LOTAnimationView *identifylotView;
@property (nonatomic, strong) LOTAnimationView *loadlotView;
@property (nonatomic, strong) NSString *firstGesture;

@end

@implementation TRUGestureModify2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}
#pragma mark - Private methods
-  (void)setupViews {
    __weak typeof(self) weakSelf = self;
    
    self.linelabel.hidden = YES;
    
    //iconImgview lotview
    CGFloat lastY = 100;
    
    UIImageView *iconImgview = [[UIImageView alloc] init];
    [self.view addSubview:iconImgview];
    NSString *imgurlstr = [TRUCompanyAPI getCompany].logo_url;
    [iconImgview yy_setImageWithURL:[NSURL URLWithString:imgurlstr] placeholder:[UIImage imageNamed:@"ges_bg"]];
    iconImgview.frame = CGRectMake(SCREENW/2.f - 50, 65, 100, 100);
    if (kDevice_Is_iPhoneX) {
        iconImgview.frame = CGRectMake(SCREENW/2.f - 50, 105, 100, 100);
    }else{
        iconImgview.frame = CGRectMake(SCREENW/2.f - 50, 65, 100, 100);
    }
    _identifylotView= [LOTAnimationView animationNamed:@"GestureAppend.json"];
    _identifylotView.size = CGSizeMake(160, 160);
    _identifylotView.centerX = self.view.centerX;
    _identifylotView.centerY = iconImgview.centerY;
    [self.view addSubview:_identifylotView];
    _identifylotView.hidden = YES;
    
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.font = [UIFont systemFontOfSize:15];
    topLabel.text = @"请输入新手势密码";
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
        [weakSelf verifyGesture:password gesDotCount:dotCounts];
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
    UILabel * txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW/2.f - 115, SCREENH - 40, 160, 20)];
    [self.view addSubview:txtLabel];
    txtLabel.text = @"使用此App,即表示同意该";
    txtLabel.font = [UIFont systemFontOfSize:14];
    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:agreementBtn];
    agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 40, 90, 20);
    [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [agreementBtn setTitleColor:RGBCOLOR(32, 144, 54) forState:UIControlStateNormal];
    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [agreementBtn addTarget:self action:@selector(lookUserAgreement) forControlEvents:UIControlEventTouchUpInside];
    
    if (kDevice_Is_iPhoneX) {
        txtLabel.frame =CGRectMake(SCREENW/2.f - 122, SCREENH - 80, 165, 20);
        agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 80, 90, 20);
    }
    
}

- (void)verifyGesture:(NSString *)gesture gesDotCount:(NSInteger)gesDotCount{
    UIColor *wrongLineColor = [UIColor redColor];
    
    if (gesDotCount < 4) {
        self.topLabel.text = @"至少连接4个点，请重画";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.topLabel.text = self.firstGesture.length > 0 ? @"请再次绘制手势" : @"绘制解锁图案";
            self.patternLockView.lineColor = lineDefaultColor;
            [self.patternLockView resetDotsState];
        });
        return;
    }
    
    if (self.firstGesture.length > 0) {
        if ([gesture isEqualToString:self.firstGesture]) {
            [self registerGesture:gesture];
            //request
        } else {
            self.topLabel.textColor = wrongLineColor;
            self.topLabel.text = @"图案错误，请重试";
            self.patternLockView.lineColor = wrongLineColor;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.patternLockView resetDotsState];
                [self.patternLockView setLineColor:lineDefaultColor];
                self.topLabel.text = @"请再次绘制手势";
                self.topLabel.textColor = [UIColor darkGrayColor];
            });
        }
        return;
    }
    
    self.firstGesture = gesture;
    
    [self.patternLockView resetDotsState];
    [self.patternLockView setLineColor:lineDefaultColor];
    self.topLabel.text = @"请再次绘制手势";
    
}

- (void)registerGesture:(NSString *)gesture {
    _identifylotView.hidden = NO;
    [_identifylotView playWithCompletion:^(BOOL animationFinished) {
        NSString *encryptedGesture = [self encryptGesture:gesture];
        if (_ISrebinding) {
            [TRUEnterAPPAuthView dismissAuthView];
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeture];
            [TRUFingerGesUtil saveGesturePwd:encryptedGesture];
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            NSNumber *printNum = [[NSNumber alloc] initWithInt:0];
            [def setObject:printNum forKey:@"VerifyFingerNumber"];
            [def setObject:printNum forKey:@"VerifyFingerNumber2"];
        }else{
            if (self.oldEncryptedGesture.length == 0 || encryptedGesture.length == 0) {
                return;
            }
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeture];
            [TRUFingerGesUtil saveGesturePwd:encryptedGesture];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }];
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
    YCLog(@"手势密码：%@", newges);
    NSString *userId = [TRUUserAPI getUser].userId;//[TFUserProfile
    return [xindunsdk encryptData:newges ForUser:userId];
}


#pragma mark - 用户协议 UserAgreement
-(void)lookUserAgreement{
    TRULicenseAgreementViewController *lisenceVC = [[TRULicenseAgreementViewController alloc] init];
    [self.navigationController pushViewController:lisenceVC animated:YES];
}
@end

