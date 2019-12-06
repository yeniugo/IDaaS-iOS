//
//  TFGestureVerifyViewController.m
//  Trusfort
//
//  Created by muhuaxin on 16/3/15.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUGestureVerifyViewController.h"
#import "HUIPatternLockView.h"
#import "AppDelegate.h"
#import "UINavigationBar+BackgroundColor.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "TRUFingerGesUtil.h"
#import "TRUBaseNavigationController.h"

#import "TRUCheckBingController.h"
#import <AudioToolbox/AudioToolbox.h>
//忘记手势的逻辑
//#import "TRUForgetFingerOrGestureViewController.h"
#import "TRULicenseAgreementViewController.h"
#import "TRUEnterAPPAuthView.h"
#import <Lottie/Lottie.h>
#import "xindunsdk.h"


@interface TRUGestureVerifyViewController ()
@property (nonatomic, strong) LOTAnimationView *identifylotView;
@property (nonatomic, strong) LOTAnimationView *loadlotView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) HUIPatternLockView *patternLockView;

@end

@implementation TRUGestureVerifyViewController
{
    //    NSInteger toallVerNum;
    int iunmber;
    NSString *msgstr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSNumber *printNum = [def objectForKey:@"VerifyFingerNumber"];
    if (!printNum) {
        iunmber = 0;
    }else{
        iunmber = printNum.intValue;
    }
    msgstr = @"您已录入错误手势5次，我们将通过短信/邮箱登录之后，重新绘制手势。";
    if (iunmber >= 5) {
        [self showConfrimCancelDialogViewWithTitle:@"" msg:msgstr confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
            //不删除本地文件，只是跳转绑定页面，初始化成功后，重新画手势
            TRUCheckBingController *vc = [[TRUCheckBingController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];

        } cancelBlock:^{

        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

#pragma mark - Private methods

- (void)setupViews {
    
    if (self.isDoingAuth) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.linelabel.hidden = YES;
    
    //iconImgview lotview
    CGFloat lastY = 100;
    
    UIImageView *iconImgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ges_bg"]];
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
    topLabel.text = @"请验证您的手势密码";
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
            _loadlotView.hidden = YES;
            [self.view addSubview:patternLockView];
        }
        
    }];
    
    if (self.isDoingAuth) {
        //忘记手势
        UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:forgetBtn];
        forgetBtn.frame = CGRectMake(SCREENW/2.f -40, SCREENH - 60, 80, 30);
        [forgetBtn setTitle:@"忘记手势？" forState:UIControlStateNormal];
        [forgetBtn setTitleColor:RGBCOLOR(32, 144, 54) forState:UIControlStateNormal];
        forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
        if (kDevice_Is_iPhoneX) {
            forgetBtn.frame = CGRectMake(SCREENW/2.f -40, SCREENH - 80, 80, 30);
        }
    }else{
        //用户协议
        UILabel * txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW/2.f - 122, SCREENH - 50, 165, 20)];
        [self.view addSubview:txtLabel];
        txtLabel.text = @"善认·一站式移动身份管理";
        txtLabel.font = [UIFont systemFontOfSize:14];
        UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:agreementBtn];
        agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 50, 90, 20);
        [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
        [agreementBtn setTitleColor:RGBCOLOR(32, 144, 54) forState:UIControlStateNormal];
        agreementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [agreementBtn addTarget:self action:@selector(lookUserAgreement) forControlEvents:UIControlEventTouchUpInside];
        
        if (kDevice_Is_iPhoneX) {
            txtLabel.frame =CGRectMake(SCREENW/2.f - 122, SCREENH - 80, 165, 20);
            agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 80, 90, 20);
        }
    }
    
}
- (void)verifyGesture:(NSString *)gesture {
    
    NSString *encryptedGesture = [self encryptGesture:gesture];
    if (!encryptedGesture) {
        return;
    }
    iunmber++;
    if([encryptedGesture isEqualToString:[TRUFingerGesUtil getGesturePwd]]){
        self.topLabel.textColor = [UIColor darkGrayColor];
        self.topLabel.text = @"手势密码验证成功";
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSNumber *printNum = [[NSNumber alloc] initWithInt:0];
        [def setObject:printNum forKey:@"VerifyFingerNumber"];
        _identifylotView.hidden = NO;
        [_identifylotView playWithCompletion:^(BOOL animationFinished) {
            if (animationFinished) {
                if (self.closeGesAuth) {
                    [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                    if (self.isDoingAuth) {
                        
                        [TRUEnterAPPAuthView dismissAuthView];
                    }else{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }else{
                    if (self.isDoingAuth) {
                        self.topLabel = nil;
                        [self.patternLockView resetDotsState];
                        [TRUEnterAPPAuthView dismissAuthView];
                    }else{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    
                }
            }
        }];
        
    }else{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        self.topLabel.text = [NSString stringWithFormat:@"您已录入错误手势%d次，还剩余%d次",iunmber,5-iunmber];
        self.topLabel.textColor = [UIColor redColor];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.patternLockView resetDotsState];
            //            self.topLabel.textColor = [UIColor darkGrayColor];
            //            self.topLabel.text = @"请验证您的手势密码";
        });
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSNumber *printNum = [[NSNumber alloc] initWithInt:iunmber];
        [def setObject:printNum forKey:@"VerifyFingerNumber"];
        if (iunmber == 5) {
            [self showConfrimCancelDialogViewWithTitle:@"" msg:msgstr confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                //不删除本地文件，只是跳转绑定页面，初始化成功后，重新画手势
                TRUCheckBingController *vc = [[TRUCheckBingController alloc] init];
                
                [self.navigationController pushViewController:vc animated:YES];
                
            } cancelBlock:^{
                
            }];
        }
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
//    NSLog(@"加密手势：%@", newges);
    NSString *userId = [TRUUserAPI getUser].userId;
//    return newges;
    return [xindunsdk encryptData:newges ForUser:userId];

}


#pragma mark - 忘记手势
-(void)forgetBtnClick{
    [self showConfrimCancelDialogViewWithTitle:@"" msg:@"我们将通过短信/邮箱登录之后，重新绘制手势。" confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        TRUCheckBingController *vc = [[TRUCheckBingController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } cancelBlock:^{
        
    }];
}
#pragma mark - 用户协议 UserAgreement
-(void)lookUserAgreement{
    TRULicenseAgreementViewController *lisenceVC = [[TRULicenseAgreementViewController alloc] init];
    [self.navigationController pushViewController:lisenceVC animated:YES];
}
@end
