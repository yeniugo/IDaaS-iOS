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
#import "AppDelegate.h"
#import "TRUhttpManager.h"
#import "TRUTokenUtil.h"
#import "YZXGesturesView.h"
@interface TRUGestureModify2ViewController ()

@property (nonatomic, strong) UILabel *topLabel;
//手势解锁页面
@property (nonatomic, strong) YZXGesturesView             *YZXGesturesView;
//手势解锁提示文本
@property (strong, nonatomic) UILabel *hintLabel;
//设置手势成功id
@property (nonatomic, copy) NSArray             *selectedID;
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
    self.title = @"重置手势";
    self.linelabel.hidden = YES;
    self.navigationBar.hidden = NO;
    //iconImgview lotview
    CGFloat lastY = 100;
    
    if (self.ISrebinding) {
        self.leftItemBtn.hidden = YES;
    }
    
    
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
    //用户协议
//    UILabel * txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW/2.f - 115, SCREENH - 40, 160, 20)];
//    [self.view addSubview:txtLabel];
//    txtLabel.text = @"使用此App,即表示同意该";
//    txtLabel.font = [UIFont systemFontOfSize:14];
//    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:agreementBtn];
//    agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 40, 90, 20);
//    [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
//    [agreementBtn setTitleColor:DefaultGreenColor forState:UIControlStateNormal];
//    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [agreementBtn addTarget:self action:@selector(lookUserAgreement) forControlEvents:UIControlEventTouchUpInside];
//    
//    if (kDevice_Is_iPhoneX) {
//        txtLabel.frame =CGRectMake(SCREENW/2.f - 122, SCREENH - 80, 165, 20);
//        agreementBtn.frame = CGRectMake(SCREENW/2.f +35, SCREENH - 80, 90, 20);
//    }
    
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
        _YZXGesturesView.backgroundColor = [UIColor clearColor];
        
        __weak typeof(self) weakSelf = self;
        //设置手势，记录设置的密码，待确定后确定
        _YZXGesturesView.gestureBlock = ^(NSArray *selectedID) {
            //            weak_self.selectedID = selectedID;
            
            [weakSelf verifyGesture:[selectedID componentsJoinedByString:@""]];
        };
        _YZXGesturesView.gestureErrorBlock = ^{
            weakSelf.hintLabel.text = @"手势长度不足4个，请重新输入";
            weakSelf.hintLabel.textColor = [UIColor redColor];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(weakSelf.firstGesture.length){
                    weakSelf.hintLabel.text = @"请再次输入手势";
                }else{
                    weakSelf.hintLabel.text = @"请输入手势";
                }
                weakSelf.hintLabel.textColor = [UIColor darkGrayColor];
            });
        };
    }
    return _YZXGesturesView;
}

- (void)verifyGesture:(NSString *)gesture {
    if (self.firstGesture.length) {
        if ([self.firstGesture isEqualToString:gesture]) {
            [self registerGesture:gesture];
            self.hintLabel.textColor = [UIColor darkGrayColor];
            self.hintLabel.text = @"验证手势成功";
        }else{
            self.hintLabel.textColor = [UIColor darkGrayColor];
            self.hintLabel.text = @"两次手势不一致，请重新输入";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.firstGesture = nil;
                [self.YZXGesturesView resetNormal];
                self.hintLabel.textColor = [UIColor darkGrayColor];
                self.hintLabel.text = @"请输入手势";
            });
        }
    }else{
        self.firstGesture = gesture;
        [self.YZXGesturesView resetNormal];
        self.hintLabel.textColor = [UIColor darkGrayColor];
        self.hintLabel.text = @"请再次输入手势";
    }
}



- (void)registerGesture:(NSString *)gesture {
    if (TRUEnterAPPAuthView.lockid==2) {
        [TRUEnterAPPAuthView unlockView];
    }
    __weak typeof(self) weakSelf = self;
    NSString *encryptedGesture = [self encryptGesture:gesture];
    if (_ISrebinding) {
        [TRUEnterAPPAuthView dismissAuthView];
        [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeture];
        [TRUFingerGesUtil saveGesturePwd:encryptedGesture];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSNumber *printNum = [[NSNumber alloc] initWithInt:0];
        [def setObject:printNum forKey:@"VerifyFingerNumber"];
        [def setObject:printNum forKey:@"VerifyFingerNumber2"];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        if(delegate.thirdAwakeTokenStatus==1){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
        }
        if(delegate.thirdAwakeTokenStatus==2){
            //                [weakSelf getNetToken];
        }
        if (delegate.thirdAwakeTokenStatus==8) {
            [weakSelf getAuthToken];
        }
    }else{
        if (self.oldEncryptedGesture.length == 0 || encryptedGesture.length == 0) {
            return;
        }
        [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeture];
        [TRUFingerGesUtil saveGesturePwd:encryptedGesture];
        [self.navigationController popToRootViewControllerAnimated:NO];
        //            [HAMLogOutputWindow printLog:@"popToRootViewControllerAnimated"];
    }
}

- (void)getAuthToken{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *phone = [TRUUserAPI getUser].phone;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    //    NSString *uuid = [xindunsdk getCIMSUUID:userid];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",delegate.appid,delegate.apid,userid];
    NSArray *ctxx = @[@"appid",delegate.appid,@"apid",delegate.apid,@"userid",userid];
    //    NSString *sign = [NSString stringWithFormat:@"%@%@",delegate.appid,delegate.apid];
    //    NSArray *ctxx = @[@"appid",delegate.appid,@"apid",delegate.apid];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/getcode"] withParts:dictt onResult:^(int errorno, id responseBody){
        YCLog(@"error = %d",errorno);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"status"] = @(errorno);
        if (errorno == 0 || responseBody != nil) {
            NSString *code = responseBody;
            if(code.length>0){
                NSDictionary *resDic = [xindunsdk decodeServerResponse:responseBody];
                if ([resDic[@"code"] intValue] == 0) {
                    dic[@"code"] = resDic[@"resp"][@"code"];
                }
            }else{
                dic[@"code"] = @"";
            }
        }else{
            dic[@"code"] = @"";
        }
        YCLog(@"dic = %@",dic[@"code"]);
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        if (delegate.appCompletionBlock) {
//                        [HAMLogOutputWindow printLog:@"getNetToken dic1111"];
            delegate.appCompletionBlock(dic);
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

- (void)getNetToken{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *phone = [TRUUserAPI getUser].phone;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/getoauth"] withParts:dictt onResult:^(int errorno, id responseBody){
        NSDictionary *dicc = nil;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = @"getNetToken";
        if(userid.length && [xindunsdk userInitializedInfo:userid] && phone.length){
            dic[@"phone"] = [TRUUserAPI getUser].phone;
        }
        if (errorno == 0 && responseBody) {
            dicc = [xindunsdk decodeServerResponse:responseBody];
            if ([dicc[@"code"] intValue] == 0) {
                dicc = dicc[@"resp"];
                //同步信息成功，信息完整，跳转页面
                NSString *tokenStr = dicc[@"access_token"];
                [TRUTokenUtil saveLocalToken:tokenStr];
                dic[@"status"] = @(errorno);
                dic[@"token"] = tokenStr;
                //!weakSelf.completionBlock ? : weakSelf.completionBlock(dic);
            }
        }else if(9008 == errorno){
            //秘钥失效
            [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
            [TRUUserAPI deleteUser];
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
            dic[@"status"] = @(errorno);
            //!weakSelf.completionBlock ? : weakSelf.completionBlock(dic);
        }else if (9019 == errorno){
            dic[@"status"] = @(errorno);
            //!weakSelf.completionBlock ? : weakSelf.completionBlock(dic);
        }else{
            dic[@"status"] = @(errorno);
            //!weakSelf.completionBlock ? : weakSelf.completionBlock(dic);
        }
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        if (delegate.appCompletionBlock) {
            delegate.appCompletionBlock(dic);
        }
    }];
}

#pragma mark - 用户协议 UserAgreement
-(void)lookUserAgreement{
    TRULicenseAgreementViewController *lisenceVC = [[TRULicenseAgreementViewController alloc] init];
    [self.navigationController pushViewController:lisenceVC animated:YES];
}
@end

