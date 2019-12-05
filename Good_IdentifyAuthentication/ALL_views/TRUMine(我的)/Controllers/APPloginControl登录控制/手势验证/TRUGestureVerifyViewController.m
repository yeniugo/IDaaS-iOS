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

//忘记手势的逻辑
//#import "TRUForgetFingerOrGestureViewController.h"
#import "TRULicenseAgreementViewController.h"
#import "TRUEnterAPPAuthView.h"
#import <Lottie/Lottie.h>
#import "xindunsdk.h"
#import "TRUCompanyAPI.h"
#import <YYWebImage.h>
#import <AudioToolbox/AudioToolbox.h>
#import "gesAndFingerNVController.h"
#import "AppDelegate.h"
#import "TRUhttpManager.h"
@interface TRUGestureVerifyViewController ()
//@property (nonatomic, strong) LOTAnimationView *identifylotView;
@property (nonatomic, strong) LOTAnimationView *loadlotView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) HUIPatternLockView *patternLockView;
//@property (nonatomic, assign) BOOL isAuth;
@end

@implementation TRUGestureVerifyViewController
{
//    NSInteger toallVerNum;
    int iunmber;
    NSString *msgstr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    TRUBaseNavigationController *nav = self.navigationController;
//    [nav setNavBarColor:DefaultGreenColor];
    self.title = @"验证手势";
//    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBCOLOR(94, 95, 96), NSFontAttributeName : [UIFont systemFontOfSize:NavTitleFont]}];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSNumber *printNum = [def objectForKey:@"VerifyFingerNumber"];
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
//    _identifylotView= [LOTAnimationView animationNamed:@"GestureAppend.json"];
//    _identifylotView.size = CGSizeMake(160, 160);
//    _identifylotView.centerX = self.view.centerX;
//    _identifylotView.centerY = iconImgview.centerY;
//    [self.view addSubview:_identifylotView];
//    _identifylotView.hidden = YES;
    
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
    if (isPad) {
            patternLockView.size = CGSizeMake(SCREENW/2.0, SCREENW/2.0);
    //        patternLockView.y = SCREENH/4.0;
    }
    patternLockView.centerX = self.view.width / 2.0;
    if (kDevice_Is_iPhoneX) {
        patternLockView.y = topLabel.bottom + 60;
    }else{
        patternLockView.y = topLabel.bottom + 20;
    }
    if (isPad) {
        patternLockView.centerY = SCREENH / 2.0;
        topLabel.bottom = patternLockView.y - 20;
        iconImgview.bottom = topLabel.y - 20;
//        topLabel.font = [UIFont systemFontOfSize:15];
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
        forgetBtn.frame = CGRectMake(SCREENW/2.f -40, SCREENH - 50, 80, 30);
        [forgetBtn setTitle:@"忘记手势？" forState:UIControlStateNormal];
        [forgetBtn setTitleColor:RGBCOLOR(247, 153, 15) forState:UIControlStateNormal];
        forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
        if (kDevice_Is_iPhoneX){
            forgetBtn.frame = CGRectMake(SCREENW/2.f -40, SCREENH - 80, 80, 30);
        }
    }else{
        //用户协议
        UILabel * txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW/2.f - 115, SCREENH - 40, 160, 20)];
        [self.view addSubview:txtLabel];
        txtLabel.text = @"使用此App,即表示同意该";
        txtLabel.font = [UIFont systemFontOfSize:14];
        txtLabel.hidden = YES;
        UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:agreementBtn];
        agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 40, 90, 20);
        [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
        [agreementBtn setTitleColor:RGBCOLOR(247, 153, 15) forState:UIControlStateNormal];
        agreementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [agreementBtn addTarget:self action:@selector(lookUserAgreement) forControlEvents:UIControlEventTouchUpInside];
        agreementBtn.hidden = YES;
        if (kDevice_Is_iPhoneX) {
            txtLabel.frame =CGRectMake(SCREENW/2.f - 122, SCREENH - 80, 165, 20);
            agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 80, 90, 20);
        }
    }
}
//
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
//        _identifylotView.hidden = NO;
        if (self.completionBlock) {
            self.completionBlock();
        }
//        [_identifylotView playWithCompletion:^(BOOL animationFinished) {
//            if (animationFinished) {
//
//            }
//        }];
        if (self.closeGesAuth) {
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
            if (self.isDoingAuth) {
                //                        self.isAuth = YES;
                
                //                        [TRUEnterAPPAuthView dismissAuthView];
//                [TRULockWindow dismissAuthView];
                [self refreshtoken];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }else{
            if (self.isDoingAuth) {
                self.topLabel = nil;
                [self.patternLockView resetDotsState];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
                //                        [TRUEnterAPPAuthView dismissAuthView];
//                [TRULockWindow dismissAuthView];
                [self refreshtoken];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }
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
                ssss = @"我们将通过邮箱登录之后，重新绘制手势。";
            }else if ([modeStr isEqualToString:@"2"]){
                ssss = @"我们将通过短信登录之后，重新绘制手势。";
            }else if ([modeStr isEqualToString:@"3"]){
                ssss = @"我们将通过用户名密码登录之后，重新绘制手势。";
            }
        }
        
    }else{
        ssss = @"我们将通过短信/邮箱/用户名密码登录之后，重新绘制手势。";
    }
    
    [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:ssss confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        TRUCheckBingController *vc = [[TRUCheckBingController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } cancelBlock:^{
        
    }];
}

- (void)refreshtoken{
    __weak typeof(self) weakSelf = self;
    NSString *mainuserid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *paras = [xindunsdk encryptByUkey:mainuserid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/token/gen"] withParts:dictt onResult:^(int errorno, id responseBody){
        YCLog(@"111111111111111+");
        //        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"refreshtoken error = %d",errorno]];
        if(errorno==0){
            YCLog(@"%@",responseBody);
            if (responseBody!=nil) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                if([dic[@"code"] intValue]==0){
                    dic = dic[@"resp"];
                    NSString *refreshToken = dic[@"refresh_token"];
                    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"refresh_token"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
                    [TRULockSWindow dismissAuthView];
                }
            }
        }else if(errorno == -5004){
            [weakSelf showHudWithText:@"网络错误，稍后请重试"];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    YCLog(@"TRUGestureVerifyViewController disappear");
//    if (!self.isAuth) {
//        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//        if (delegate.soureSchme.length) {
//            if (delegate.thirdAwakeTokenStatus==8) {
//                NSString *cimsURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
//                NSString* urlStr = [NSString stringWithFormat:@"%@://auth?scheme=trusfortcims&type=auth&cimsurl=%@&code=%@&status=%@",delegate.soureSchme,cimsURL,@"",@"3000"];
//                delegate.soureSchme = nil;
//                delegate.thirdAwakeTokenStatus = 0;
//                if (@available(iOS 10.0,*)) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
//                        YCLog(@"TRUGestureVerifyViewController openurl %d",success);
//                    }];
//                }else{
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//                }
//            }
//        }
//    }
}

#pragma mark - 用户协议 UserAgreement
-(void)lookUserAgreement{
    TRULicenseAgreementViewController *lisenceVC = [[TRULicenseAgreementViewController alloc] init];
    [self.navigationController pushViewController:lisenceVC animated:YES];
}
@end
