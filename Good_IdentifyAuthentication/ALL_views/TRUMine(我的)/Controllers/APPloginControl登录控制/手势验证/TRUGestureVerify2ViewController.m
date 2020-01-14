//
//  TRUGestureVerify2ViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/4/18.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUGestureVerify2ViewController.h"
#import "HUIPatternLockView.h"
#import "AppDelegate.h"
#import "UINavigationBar+BackgroundColor.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "TRUFingerGesUtil.h"
#import "TRUBaseNavigationController.h"

#import "TRUCheckBingController.h"

//忘记手势的逻辑
//#import "TRUForgetFingerOrGestureViewController.h"
#import "TRULicenseAgreementViewController.h"
#import "TRUEnterAPPAuthView.h"
#import <Lottie/Lottie.h>
#import "xindunsdk.h"
#import "TRUCompanyAPI.h"
#import <YYWebImage.h>
#import <AudioToolbox/AudioToolbox.h>
#import "YZXGesturesView.h"
@interface TRUGestureVerify2ViewController ()
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) YZXGesturesView             *YZXGesturesView;
//手势解锁提示文本
@property (strong, nonatomic) UILabel *hintLabel;
//设置手势成功id
@property (nonatomic, copy) NSArray             *selectedID;
@end

@implementation TRUGestureVerify2ViewController
{
    //    NSInteger toallVerNum;
    int iunmber;
    NSString *msgstr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSNumber *printNum = [def objectForKey:@"VerifyFingerNumber2"];
    if (!printNum) {
        iunmber = 0;
    }else{
        iunmber = printNum.intValue;
    }
    
    NSString *activeStr = [TRUCompanyAPI getCompany].activation_mode;
    
    if (activeStr.length>0) {
        NSArray *arr = [activeStr componentsSeparatedByString:@","];
        if (arr.count>0) {
            NSString *modeStr = arr[0];
            if ([modeStr isEqualToString:@"1"]) {//激活方式 激活方式(1:邮箱,2:手机,3:工号)
                msgstr = @"您已录入错误手势5次，我们将通过邮箱登录之后，重新绘制手势。";
            }else if ([modeStr isEqualToString:@"2"]){
                msgstr = @"您已录入错误手势5次，我们将通过短信登录之后，重新绘制手势。";
            }else if ([modeStr isEqualToString:@"3"]){
                msgstr = @"您已录入错误手势5次，我们将通过用户名密码登录之后，重新绘制手势。";
            }else if ([modeStr isEqualToString:@"4"]){
                ssss = @"我们将通过用户名密码登录加手机号之后，重新绘制手势。";
            }else if ([modeStr isEqualToString:@"5"]){
                ssss = @"我们将通过用户名密码登录加邮箱之后，重新绘制手势。";
            }
        }
        
    }else{
        msgstr = @"您已录入错误手势5次，我们将通过短信/邮箱/用户名密码登录之后，重新绘制手势。";
    }
    
    
    if (iunmber >= 5) {
        [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:msgstr confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
            //不删除本地文件，只是跳转绑定页面，初始化成功后，重新画手势
            TRUCheckBingController *vc = [[TRUCheckBingController alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        } cancelBlock:^{
            
        }];
    }
    
    TRUBaseNavigationController *nav = self.navigationController;
    nav.backBlock = nil;
    [TRUEnterAPPAuthView unlockView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

#pragma mark - Private methods

- (void)setupViews {
    self.title = @"验证手势";
    if (self.isDoingAuth) {
        UIImage *img = [[UIImage imageNamed:@"backbtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setBackgroundImage:img forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(navPop) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(0, 0, 30, 30);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.linelabel.hidden = YES;
    
    //iconImgview lotview
    CGFloat lastY = 100;
    
    
    
    self.hintLabel = [[UILabel alloc] init];
    self.hintLabel.frame = CGRectMake(0, SCREENH / 2.0 - (SCREENW - 80.0) / 2.0 - 40, SCREENW, 20);
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.hintLabel];
    self.hintLabel.textColor = [UIColor darkGrayColor];
    self.hintLabel.text = @"请输入手势";
    if (kDevice_Is_iPhoneX) {
        self.hintLabel.frame = CGRectMake(0, lastY + 115, SCREEN_WIDTH, 20);
    }else{
        self.hintLabel.frame = CGRectMake(0, lastY + 75, SCREEN_WIDTH, 20);
    }
    [self.view addSubview:self.YZXGesturesView];
    if (self.isDoingAuth) {
        //忘记手势
        UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:forgetBtn];
        forgetBtn.frame = CGRectMake(SCREENW/2.f -40, SCREENH - 50, 80, 30);
        [forgetBtn setTitle:@"忘记手势？" forState:UIControlStateNormal];
        [forgetBtn setTitleColor:DefaultGreenColor forState:UIControlStateNormal];
        forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
        if (kDevice_Is_iPhoneX){
            forgetBtn.frame = CGRectMake(SCREENW/2.f -40, SCREENH - 80, 80, 30);
        }
    }else{
        //用户协议
//        UILabel * txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW/2.f - 115, SCREENH - 40, 160, 20)];
//        [self.view addSubview:txtLabel];
//        txtLabel.text = @"使用此App,即表示同意该";
//        txtLabel.font = [UIFont systemFontOfSize:14];
//        UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.view addSubview:agreementBtn];
//        agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 40, 90, 20);
//        [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
//        [agreementBtn setTitleColor:DefaultGreenColor forState:UIControlStateNormal];
//        agreementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [agreementBtn addTarget:self action:@selector(lookUserAgreement) forControlEvents:UIControlEventTouchUpInside];
//        
//        if (kDevice_Is_iPhoneX) {
//            txtLabel.frame =CGRectMake(SCREENW/2.f - 122, SCREENH - 80, 165, 20);
//            agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 80, 90, 20);
//        }
    }
}

- (YZXGesturesView *)YZXGesturesView
{
    if (!_YZXGesturesView) {
        CGRect frame = CGRectZero;
        frame.size = CGSizeMake(252, 252);
        if (kDevice_Is_iPhoneX) {
            frame.origin.y = self.hintLabel.bottom + 60;
        }else{
            frame.origin.y = self.hintLabel.bottom + 20;
        }
        frame.origin.x = (self.view.width - 252)/2.0;
        _YZXGesturesView = [[YZXGesturesView alloc] initWithFrame:frame];
//        _YZXGesturesView = [[YZXGesturesView alloc] initWithFrame:CGRectMake(40, SCREENH / 2.0 - (SCREENW - 80.0) / 2.0, SCREENW - 80.0, SCREENW - 80.0)];
        _YZXGesturesView.backgroundColor = [UIColor clearColor];
        
        __weak typeof(self) weakSelf = self;
        //设置手势，记录设置的密码，待确定后确定
        _YZXGesturesView.gestureBlock = ^(NSArray *selectedID) {
            //            weak_self.selectedID = selectedID;
//            [weakSelf.YZXInfoView changSuccessWithArray:selectedID];
            [weakSelf verifyGesture:[selectedID componentsJoinedByString:@""]];
        };
        _YZXGesturesView.gestureErrorBlock = ^{
            weakSelf.hintLabel.text = @"手势长度不足4个，请重新输入";
            weakSelf.hintLabel.textColor = [UIColor redColor];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.hintLabel.text = @"请输入手势";
                weakSelf.hintLabel.textColor = [UIColor darkGrayColor];
            });
        };
    }
    return _YZXGesturesView;
}

-(void)navPop{
    [self.navigationController popViewControllerAnimated:YES];
//    [HAMLogOutputWindow printLog:@"popViewControllerAnimated"];
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
        self.hintLabel.textColor = [UIColor darkGrayColor];
        self.hintLabel.text = @"手势密码验证成功";
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSNumber *printNum = [[NSNumber alloc] initWithInt:0];
        [def setObject:printNum forKey:@"VerifyFingerNumber2"];
        
        if (self.completionBlock) {
            self.completionBlock();
        }
        if (self.closeGesAuth) {
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
            if (self.isDoingAuth) {
                
                [TRUEnterAPPAuthView dismissAuthView];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
                //                        [HAMLogOutputWindow printLog:@"popToRootViewControllerAnimated"];
            }
        }else{
            if (self.isDoingAuth) {
                self.topLabel   = nil;
                
                [TRUEnterAPPAuthView dismissAuthView];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
                //                        [HAMLogOutputWindow printLog:@"popToRootViewControllerAnimated"];
            }
        }
        //        [_identifylotView playWithCompletion:^(BOOL animationFinished) {
        //            if (animationFinished) {
        //
        //            }
        //        }];
    }else{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        self.topLabel.text = [NSString stringWithFormat:@"您已录入错误手势%d次，还剩余%d次",iunmber,5-iunmber];
        self.topLabel.textColor = [UIColor redColor];
        self.hintLabel.text = [NSString stringWithFormat:@"您已录入错误手势%d次，还剩余%d次",iunmber,5-iunmber];
        self.hintLabel.textColor = [UIColor redColor];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            [self.patternLockView resetDotsState];
            //            self.topLabel.textColor = [UIColor darkGrayColor];
            //            self.topLabel.text = @"请验证您的手势密码";
            [self.YZXGesturesView unlockFailure];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.YZXGesturesView resetNormal];
            });
        });
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSNumber *printNum = [[NSNumber alloc] initWithInt:iunmber];
        [def setObject:printNum forKey:@"VerifyFingerNumber2"];
        if (iunmber == 5) {
            [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:msgstr confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
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
    //    YCLog(@"加密手势：%@", newges);
    NSString *userId = [TRUUserAPI getUser].userId;
    //    return newges;
    return [xindunsdk encryptData:newges ForUser:userId];
    
}


#pragma mark - 忘记手势
-(void)forgetBtnClick{
    NSString *activeStr = [TRUCompanyAPI getCompany].activation_mode;
    NSString *ssss;
    if (activeStr.length>0) {
        NSArray *arr = [activeStr componentsSeparatedByString:@","];
        if (arr.count>0) {
            NSString *modeStr = arr[0];
            if ([modeStr isEqualToString:@"1"]) {//激活方式 激活方式(1:邮箱,2:手机,3:工号)
                ssss = @"您需要通过邮箱验证身份，然后重新设置手势";
            }else if ([modeStr isEqualToString:@"2"]){
                ssss = @"您需要通过短信验证身份，然后重新设置手势";
            }else if ([modeStr isEqualToString:@"3"]){
                ssss = @"您需要通过密码验证身份，然后重新设置手势";
            }
        }
        
    }else{
        ssss = @"您需要通过短信/邮箱/密码验证身份，然后重新设置手势";
    }
    [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:ssss confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
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
