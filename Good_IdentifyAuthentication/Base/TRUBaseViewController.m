//
//  TRUBaseViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUBaseViewController.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "xindunsdk.h"
#import "TRUFingerGesUtil.h"
#import <AVFoundation/AVFoundation.h>



@interface TRUBaseViewController ()
@property (nonatomic, assign) __block BOOL showed9019Error;
/** hud */
@property (nonatomic, weak) MBProgressHUD *hud;


//@property (nonatomic, strong) 

@end

@implementation TRUBaseViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    self.showed9019Error = NO;
    
    self.view.backgroundColor = RGBCOLOR(247, 249, 250);
    //黑线 (maybe change image)
    if (kDevice_Is_iPhoneX) {
        _linelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 25, SCREENW, 1.f)];
    }else{
        _linelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREENW, 1.f)];
    }
    _linelabel.backgroundColor = RGBCOLOR(180, 180, 180);
    [self.view addSubview:_linelabel];
    
    self.scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (kDevice_Is_iPhoneX) {
        self.scanBtn.size = CGSizeMake(SCREENW/5.f - 10, 30);
        self.scanBtn.centerX = self.view.centerX;
        self.scanBtn.y = SCREENH - 50 - 30 - 35;
    }else{
        self.scanBtn.size = CGSizeMake(SCREENW/5.f - 10, 30);
        self.scanBtn.centerX = self.view.centerX;
        self.scanBtn.y = SCREENH - 50 - 30;
    }
    self.scanBtn.backgroundColor = [UIColor clearColor];
    [self.scanBtn addTarget:self action:@selector(scanQRButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)scanQRButtonClick{
}


- (void)showConfrimCancelDialogViewWithTitle:(NSString *)title msg:(NSString *)msg confrimTitle:(NSString *)confrimTitle cancelTitle:(NSString *)cancelTitle confirmRight:(BOOL)confirmRight confrimBolck:(void (^)())confrimBlock cancelBlock:(void (^)())cancelBlock{
    
    
    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:confrimTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (confrimBlock) {
            confrimBlock();
        }
    }];
    if (cancelTitle && cancelTitle.length > 0) {
        UIAlertAction *cancelAction =  [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
            
        }];
        if (confirmRight) {
            [alertVC addAction:cancelAction];
            [alertVC addAction:confrimAction];
        }else{
            [alertVC addAction:confrimAction];
            [alertVC addAction:cancelAction];
        }
    }else{
        [alertVC addAction:confrimAction];
    }
    
    UIViewController *controler = !self.navigationController ? self : self.navigationController;
    
    if (controler.presentedViewController && [controler.presentedViewController isKindOfClass:[UIAlertController class]]) {
        [controler.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [controler presentViewController:alertVC animated:YES completion:nil];
        }];
    }else{
        [controler presentViewController:alertVC animated:YES completion:nil];
    }
    
    
    
}

- (void)back2UnActiveRootVC{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    id delegate = [UIApplication sharedApplication].delegate;
    
    if ([delegate respondsToSelector:@selector(changeAvtiveRootVC)]) {
        [delegate performSelector:@selector(changeAvtiveRootVC) withObject:nil];
    }
#pragma clang diagnostic pop
}

- (void)back2LoginRootVC{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    id delegate = [UIApplication sharedApplication].delegate;
    if ([delegate respondsToSelector:@selector(changRestDataVC)]) {
        [delegate performSelector:@selector(changRestDataVC) withObject:nil];
    }
#pragma clang diagnostic pop
}
- (void)deal9008Error{
    [self showConfrimCancelDialogViewWithTitle:@"" msg:@"秘钥失效，请重新发起初始化" confrimTitle:@"确定" cancelTitle:nil confirmRight:NO confrimBolck:^{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
        [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
        [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
//        [xindunsdk deactivateAllUsers];
        [self back2LoginRootVC];
    } cancelBlock:nil];
}
- (void)deal9019Error{
    
    [self dele9019ErrorWithBlock:nil];
}
- (void)dele9019ErrorWithBlock:(void (^)())block{
    if (!self.showed9019Error) {
        __weak typeof(self) weakSelf = self;
        [self showConfrimCancelDialogViewWithTitle:@"" msg:@"当前账号已锁定，请与管理员联系" confrimTitle:@"确定" cancelTitle:nil confirmRight:NO confrimBolck:^{
            weakSelf.showed9019Error = NO;
            if (block) {
                block();
            }
        } cancelBlock:nil];
        self.showed9019Error = YES;
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//待审批
- (void)deal9021ErrorWithBlock:(void(^)())block{
    
    [self showConfrimCancelDialogViewWithTitle:@"" msg:@"您的账号申请已提交，管理员尚未审批通过，请勿重复提交。" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
        
        if (block) block();
        
    } cancelBlock:nil];
    
}
//已提交
- (void)deal9022ErrorWithBlock:(void(^)())block{
    
    [self showConfrimCancelDialogViewWithTitle:@"" msg:@"您的账号申请已提交，请联系管理员审批。" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
        if (block) block();
    } cancelBlock:nil];
}
//拒绝
- (void)deal9023ErrorWithBlock:(void(^)())block{
    [self showConfrimCancelDialogViewWithTitle:@"" msg:@"您的账号申请被拒绝，请联系管理员。" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
        if (block) block();
    } cancelBlock:nil];
}


static const char TRUHUDKey = '\0';
- (MBProgressHUD *)hud{
    MBProgressHUD *hud = objc_getAssociatedObject(self, &TRUHUDKey);
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        objc_setAssociatedObject(self, &TRUHUDKey,
                                 hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        hud.margin = 10.0;
        hud.label.font = [UIFont boldSystemFontOfSize:14.0 * PointHeightRatio6];
        [self.view addSubview:hud];
    }
    
    return (MBProgressHUD*)hud;
}

- (void)showHudWithText:(NSString *)text{
    //[self.hud showAnimated:NO];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = text;
    [self.hud showAnimated:YES];
    //    [self.hud hideAnimated:YES afterDelay:2.0];
}
- (void)showHudWithTitle:(NSString *)titel text:(NSString *)text{
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = titel;
    self.hud.detailsLabel.text = text;
    [self.hud showAnimated:YES];
    //    [self.hud hideAnimated:YES afterDelay:2.0];
    
}

- (void)showActivityWithText:(NSString *)text{
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.label.text = text;
    [self.hud showAnimated:YES];
}
- (void)hideHudDelay:(NSTimeInterval)delay{
    
    [self.hud hideAnimated:YES afterDelay:delay];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

