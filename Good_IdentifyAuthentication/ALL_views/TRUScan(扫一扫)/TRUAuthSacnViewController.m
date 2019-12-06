//
//  TRUAuthSacnViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2016/12/26.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TRUAuthSacnViewController.h"
#import "TRUScanView.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUPushViewController.h"
#import "TRUPushingViewController.h"
#import "TRUBaseNavigationController.h"
#import "TRUPushAuthModel.h"
#import "TRUhttpManager.h"
#import "TRUMultipleAccountsViewController.h"
#import "AppDelegate.h"
@interface TRUAuthSacnViewController ()
@property (nonatomic, weak) UIView *maskView;

@property (nonatomic, weak) TRUScanView *scanView;
@property (nonatomic, assign) BOOL canSacn;
@end

@implementation TRUAuthSacnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
//    [self setUpNav];
    self.navigationBar.hidden = YES;
    [self setUPMaskView];
    [self setUPScanView];
    self.canSacn = YES;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.canSacn){
        if ([self checckVideoAuthorization]) {
            [self.scanView resumeAnimation];
            [self.scanView beginScanning];
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUpNav{
     self.title = @"Trusfort";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
- (void)setUPMaskView{
    UIView *maskView = [[UIView alloc] init];
    [self.view addSubview:self.maskView = maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.right.bottom.equalTo(self.view);
//        make.top.equalTo(self.view).offset(64.0);
        make.edges.equalTo(self.view);
    }];
    
    
    
}
- (void)setUPScanView{
    __weak typeof(self) weakSelf = self;
    TRUScanView *scanView = [[TRUScanView alloc] initWithScanLine];
    [scanView setScanResultBlock:^(NSString *result) {
//        YCLog(@"解析二维码 ： %@",result);
        if (result.length >0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSArray *arr = [result componentsSeparatedByString:@"?"];
            NSString *str;
            if (arr.count>0) {
                str = [arr lastObject];
            }
            arr = [str componentsSeparatedByString:@"&"];
            if (arr.count >0) {
                for (NSString *str in arr) {
                    NSArray *tmp = [str componentsSeparatedByString:@"="];
                    NSString *key = [tmp firstObject];
                    NSArray *value = [tmp lastObject];
                    if (key && value) {
                        dic[key] = value;
                    }
                }
            }
            
            NSString *op = dic[@"op"];
            NSString *authcode = dic[@"authcode"];
            
            
            if ([op isEqualToString:@"login"]) {
                NSString *userNo = [TRUUserAPI getUser].userId;
                if(0){
//                    [self popMultipleAccountsWithPushModel];
                }else{
                    if (userNo){
                        __weak typeof(self) weakSelf = self;
                        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
                        NSString *sign = authcode;
                        NSArray *ctxx = @[@"token",sign];
                        NSString *para = [xindunsdk encryptByUkey:userNo ctx:ctxx signdata:sign isDeviceType:YES];
                        NSDictionary *paramsDic = @{@"params" : para};
                        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/push/fetch"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
                            [self hideHudDelay:0.0];
                            NSDictionary *dic = nil;
                            if (errorno == 0 && responseBody) {
                                dic = [xindunsdk decodeServerResponse:responseBody];
                                if ([dic[@"code"] intValue] == 0) {
                                    dic = dic[@"resp"];
                                    TRUPushAuthModel *model = [TRUPushAuthModel modelWithDic:dic];
                                    model.token = authcode;
                                    if ([TRUUserAPI haveSubUser]) {
                                        [weakSelf popMultipleAccountsWithPushModel:model];
                                    }else{
                                        [weakSelf popAuthViewVCWithPushModel:model userNo:userNo];
                                    }
                                }
                            }else if (errorno == 9008){
                                [weakSelf deal9008Error];
                            }else if (9019 == errorno){
                                [weakSelf deal9019Error];
                            }else if (errorno == -5004){
                                [weakSelf showHudWithText:@"网络错误 请稍后重试"];
                                [weakSelf hideHudDelay:2.0];
                                [weakSelf performSelector:@selector(restartScan)  withObject:nil afterDelay:2.1];
                            }else if (errorno == 9002){
                                [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"二维码过期，请刷新二维码重新扫描" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                                    [weakSelf restartScan];
                                } cancelBlock:nil];
                            }else{
                                NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
                                [weakSelf showHudWithText:err];
                                [weakSelf hideHudDelay:2.0];
                                [weakSelf performSelector:@selector(restartScan)  withObject:nil afterDelay:2.1];
                            }
                        }];
                    }else{
                        [self showHudWithText:@"无效二维码"];
                        [self hideHudDelay:2.0];
                        [self performSelector:@selector(restartScan)  withObject:nil afterDelay:2.1];
                    }
                }
            }else{
                [self showConfrimCancelDialogViewWithTitle:@"" msg:@"无效二维码，请确认二维码来源！" confrimTitle:@"确认" cancelTitle:@"" confirmRight:YES confrimBolck:^{
                    [weakSelf restartScan];
                    
                } cancelBlock:nil];
            }
        }
    }];
    
    [self.maskView addSubview:self.scanView = scanView];
    [scanView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.bottom.equalTo(self.maskView);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"放入框内，自动扫描";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:14.0];
    tipLabel.textColor = [UIColor whiteColor];
    
    [self.maskView addSubview:tipLabel];
    [tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.maskView);
        make.top.equalTo(self.scanView.scanView.mas_bottom).offset(10.0 * PointHeightRatio6);
    }];
    
    UIButton *pinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.maskView addSubview:pinBtn];
    [pinBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.maskView).offset(20.0);
        make.right.equalTo(self.maskView).offset(-20.0);
        make.bottom.equalTo(self.maskView).offset(-40.0);
        //        make.height.equalTo(@80.0);
    }];
    UIButton *calcelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [calcelBtn setBackgroundImage:[UIImage imageNamed:@"facecancle"] forState:UIControlStateNormal];
    [calcelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:calcelBtn];
    
    if (kDevice_Is_iPhoneX) {
        [calcelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.maskView).offset(25.0);
            make.top.equalTo(self.maskView).offset(50.0);
            make.width.height.equalTo(@40.0);
        }];
    }else{
        [calcelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.maskView).offset(25.0);
            make.width.height.equalTo(@40.0);
        }];
    }
}

- (void)popMultipleAccountsWithPushModel:(TRUPushAuthModel*)pushModel{
    
    TRUMultipleAccountsViewController *vc = [[TRUMultipleAccountsViewController alloc] init];
    vc.selected = YES;
    vc.pushModel = pushModel;
    [vc setBackBlock:^(NSString *userId) {
        __weak typeof(self) weakSelf = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf dismissViewControllerAnimated:YES completion:nil];
//        });
        [self.navigationController popViewControllerAnimated:YES];
        TRUPushingViewController *authVC = [[TRUPushingViewController alloc] init];
        authVC.pushModel = pushModel;
        authVC.userNo = userId;
        [authVC setDismissBlock:^(BOOL confirm) {
//            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *rootnav = delegate.window.rootViewController;
            [rootnav pushViewController:authVC animated:YES];
        }
        
//        TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:authVC];
//
//        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:nav animated:YES completion:nil];
        
    }];
    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:^{
////        self.navigationController.navigationBarHidden = NO;
//    }];
//    [self.navigationController popViewControllerAnimated:NO];
//    [self.navigationController pushViewController:vc animated:YES];
    UINavigationController *pushNav = self.navigationController;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [pushNav pushViewController:vc animated:YES];
    });
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)popAuthViewVCWithPushModel:(TRUPushAuthModel*)pushModel userNo:(NSString *)userNo{
    UINavigationController *pushNav = self.navigationController;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __weak typeof(self) weakSelf = self;
        TRUPushingViewController *authVC = [[TRUPushingViewController alloc] init];
        authVC.pushModel = pushModel;
        authVC.userNo = userNo;
        [authVC setDismissBlock:^(BOOL confirm) {
            [self dismissViewControllerAnimated:YES completion:nil];
            //        [self.navigationController popViewControllerAnimated:YES];
        }];
        //        TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:authVC];
        //    [self.navigationController popViewControllerAnimated:NO];
        //    [self presentViewController:nav animated:YES completion:nil];
        //    [self.navigationController pushViewController:authVC animated:YES];
        //    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:nav animated:YES completion:nil];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        UINavigationController *nav = delegate.window.rootViewController;
        [pushNav pushViewController:authVC animated:YES];
    });
    [self.navigationController popViewControllerAnimated:NO];
    [self.scanView stopScaning];
    [self.scanView stopAnimation];
    self.canSacn = NO;
}

- (void)cancelBtnClick{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    if(self.navigationController.childViewControllers.count>1){
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)restartScan{
    [self.scanView beginScanning];
    [self.scanView resumeAnimation];
}
- (BOOL)checckVideoAuthorization{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusAuthorized) {
        [self showConfrimCancelDialogViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } cancelBlock:^{
            
        }];
        return NO;
    }
    return YES;
}
@end
