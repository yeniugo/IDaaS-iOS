//
//  TFGestureSettingViewController.m
//  Trusfort
//
//  Created by muhuaxin on 16/3/20.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUGestureSettingViewController.h"
#import "TRUGestureVerifyViewController.h"
#import "HUIPatternLockView.h"
#import "AppDelegate.h"
#import "TRUFingerGesUtil.h"
#import "UINavigationBar+BackgroundColor.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import <Lottie/Lottie.h>
#import "TRULicenseAgreementViewController.h"
#import "TRUCompanyAPI.h"
#import <YYWebImage.h>
#import "YZXGesturesView.h"
#import "TRUEnterAPPAuthView.h"

@interface TRUGestureSettingViewController ()

@property (nonatomic, strong) YZXGesturesView             *YZXGesturesView;


//手势解锁提示文本
@property (strong, nonatomic) UILabel *hintLabel;
//设置手势成功id
@property (nonatomic, copy) NSArray             *selectedID;


@property (nonatomic, strong) NSString *firstGesture;

@end

@implementation TRUGestureSettingViewController
{
    int iunmber;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    
    
}

#pragma mark - Private methods

- (void)setupViews {
    __weak typeof(self) weakSelf = self;
    self.title = @"开启手势验证";
    self.linelabel.hidden = YES;
    CGFloat lastY = 100;
    //iconImgview lotview
    
    
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
//        _YZXGesturesView = [[YZXGesturesView alloc] initWithFrame:CGRectMake(40, SCREENH / 2.0 - (SCREENW - 80.0) / 2.0, SCREENW - 80.0, SCREENW - 80.0)];
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

-(void)registerGesture:(NSString *)gesture {
    NSString *encryptedGesture = [self encryptGesture:gesture];
    if (encryptedGesture.length == 0) {
        return;
    }
    [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeture];
    [TRUFingerGesUtil saveGesturePwd:encryptedGesture];
    
    __weak typeof(self) weakSelf = self;
    if (weakSelf.backBlocked) {
        weakSelf.backBlocked();
    }
    [self.navigationController popViewControllerAnimated:YES];
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

    NSString *userId = [TRUUserAPI getUser].userId;

    return  [xindunsdk encryptData:newges ForUser:userId];

}
- (void)resetGesOrForgetGes:(UIButton *)btn{
    NSString *buttonTitle = [btn titleForState:UIControlStateNormal];
    if ([buttonTitle isEqualToString:@"切换账号"]) {

    } else if ([buttonTitle isEqualToString:@"重新设置"]) {
        self.firstGesture = nil;
        self.hintLabel.text = @"绘制解锁图案";
    }
}

#pragma mark - 用户协议 UserAgreement
-(void)lookUserAgreement{
    TRULicenseAgreementViewController *lisenceVC = [[TRULicenseAgreementViewController alloc] init];
    [self.navigationController pushViewController:lisenceVC animated:YES];
}

@end
