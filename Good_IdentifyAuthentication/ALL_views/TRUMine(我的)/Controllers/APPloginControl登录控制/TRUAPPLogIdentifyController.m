//
//  TRUAPPLogIdentifyController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/29.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUAPPLogIdentifyController.h"
#import "TRULogIdentifyCell.h"
#import "TRUFingerGesUtil.h"
#import "TRUGestureSettingViewController.h"
#import "TRUVerifyFingerprintViewController.h"
#import "TRUGestureVerifyViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "TRUGestureModify1ViewController.h"
#import "TRUVerifyFaceViewController.h"
#import "AppDelegate.h"
#import "TRUSchemeTokenViewController.h"
#import "TRUEnterAPPAuthView.h"
//#import "TRUGestureVerify2ViewController.h"

@interface TRUAPPLogIdentifyController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *txtArr;
@property (nonatomic, assign) BOOL lastAuthSuccess;//上次指纹是否设置成功
@property (nonatomic, assign) BOOL isShowAuth;//是否该显示手势验证2

@end

@implementation TRUAPPLogIdentifyController
{
    BOOL isOnGesture;
    BOOL isOnFingerprint;
    BOOL isOnFaceID;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    TRUBaseNavigationController *nav = self.navigationController;
    nav.cancelGesture = YES;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAppAuth) name:@"pushAuthVC" object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if ([UIApplication sharedApplication].applicationState!=UIApplicationStateActive) {
//        return;
//    }
    [self verifyPush];
//    [self requestData];
    
}

- (void)showAppAuth{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.thirdAwakeTokenStatus == 8 || delegate.thirdAwakeTokenStatus ==2) {
//        [self loginComplete];
        if (([TRUFingerGesUtil getLoginAuthGesType]!=TRULoginAuthGesTypeNone)||([TRUFingerGesUtil getLoginAuthFingerType]!=TRULoginAuthFingerTypeNone)) {
            [self loginComplete];
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)verifyPush{
    int authNumber = 0;
    //手势
    if ([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeture) {
        
        authNumber = authNumber + 1;
    }
    //指纹
    if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeFinger) {
        
        authNumber = authNumber + 1;
    }
    //人脸
    if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeFace) {
        
        authNumber = authNumber + 1;
    }
//    if (!authNumber) {
//        //        self.navigationItem.leftBarButtonItem;
//        TRUBaseNavigationController *nav = self.navigationController;
//        nav.leftBtn.hidden = YES;
//    }else{
//        TRUBaseNavigationController *nav = self.navigationController;
////        nav.leftBtn.hidden = NO;
//        nav.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[nav setLeftBarbutton]];
//    }
    __weak typeof(self) weakSelf = self;
    if(self.lastAuthSuccess==NO && authNumber>0){
        self.isShowAuth = NO;
//        [HAMLogOutputWindow printLog:@"登录控制push  1"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf loginComplete];
//            [HAMLogOutputWindow printLog:@"登录控制push  2"];
        });
    }else{
//        [self showHudWithText:@""];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self hideHudDelay:0.0];
//            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//            if ((delegate.thirdAwakeTokenStatus == 2 || delegate.thirdAwakeTokenStatus == 8)&(authNumber>0)) {
//                [weakSelf loginComplete];
//            }
//        });
        
    }
    
    if (authNumber>0) {
        self.lastAuthSuccess = YES;
    }else{
        self.lastAuthSuccess = NO;
    }
    
}

-(void)requestData{
    isOnGesture = isOnFaceID = isOnFingerprint = NO;
    //同步用户验证方式
    if (!_txtArr) {
        _txtArr = [NSMutableArray array];
    }
//    [_txtArr removeAllObjects];
    _txtArr = nil;
    NSArray *array;
    //首先判断用户是不是iPhone X且支持Face ID验证
    if ([self checkFaceIDAvailable]) {
//        array = @[@"手势验证",@"FaceID验证"];
        if ([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeture) {
            array = @[@[@"手势验证",@"手势修改"],@[@"FaceID验证"]];
        }else{
            array = @[@[@"手势验证"],@[@"FaceID验证"]];
        }
    }else{
        if ([self checkFingerAvailable]) {
//            array = @[@"手势验证",@"指纹验证"];
            if ([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeture) {
                array = @[@[@"手势验证",@"手势修改"],@[@"指纹验证"]];
            }else{
                array = @[@[@"手势验证"],@[@"指纹验证"]];
            }
        }else{
//            array = @[@"手势验证"];
            if ([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeture) {
                array = @[@[@"手势验证",@"手势修改"]];
            }else{
                array = @[@[@"手势验证"]];
            }
        }
    }
    _txtArr = array;
//    [_txtArr addObject:array];
    
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
    //手势
    if ([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeture) {
        isOnGesture = YES;
//        [arr addObject:@"手势修改"];
    }
    //指纹
    if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeFinger) {
        isOnFingerprint = YES;
    }
    //人脸
    if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeFace) {
        isOnFaceID = YES;
    }
    
//    [_txtArr addObject:arr];
    [_myTableView reloadData];
    [self refreshLeftBar];
}

- (void)refreshLeftBar{
    int authNumber = 0;
    //手势
    if ([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeture) {
        
        authNumber = authNumber + 1;
    }
    //指纹
    if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeFinger) {
        
        authNumber = authNumber + 1;
    }
    //人脸
    if ([TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeFace) {
        
        authNumber = authNumber + 1;
    }
    if (!authNumber) {
        //        self.navigationItem.leftBarButtonItem;
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            TRUBaseNavigationController *nav = self.navigationController;
//            nav.navigationItem.leftBarButtonItem = nil;
//        });
        self.leftItemBtn.hidden = YES;
    }else{
//        TRUBaseNavigationController *nav = self.navigationController;
//        nav.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[nav setLeftBarbutton]];
        self.leftItemBtn.hidden = NO;
    }
}

- (void)loginComplete{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"登录控制push  thirdAwakeTokenStatus=%d",delegate.thirdAwakeTokenStatus]];
    if (1) {
        delegate.isNeedPush = NO;
        switch (delegate.thirdAwakeTokenStatus) {
            case 1:
            {
                if (delegate.isMainSDK) {
//                    [HAMLogOutputWindow printLog:@"登录控制push  3"];
                    delegate.isNeedPush = YES;
                    TRUSchemeTokenViewController *tokenVC = [[TRUSchemeTokenViewController alloc] init];
                    tokenVC.schemetype = 1;
                    __weak typeof(self) weakSelf = self;
                    __weak AppDelegate *weakDelegate = delegate;
                    if ([delegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                        //                        UINavigationController *rootnav = delegate.window.rootViewController;
                        [delegate.window.rootViewController presentViewController:tokenVC animated:YES completion:nil];
//                        [HAMLogOutputWindow printLog:@"登录控制push  4"];
                    }else{
                        if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
//                            [HAMLogOutputWindow printLog:@"登录控制push  5"];
                            UINavigationController *rootnav = delegate.window.rootViewController;
                            [rootnav pushViewController:tokenVC animated:YES];
                        }
                    }
                }else{
//                    [HAMLogOutputWindow printLog:@"登录控制push  6"];
                    TRUSchemeTokenViewController *tokenVC = [[TRUSchemeTokenViewController alloc] init];
                    tokenVC.schemetype = 1;
                    __weak typeof(self) weakSelf = self;
                    __weak AppDelegate *weakDelegate = delegate;
                    tokenVC.completionBlock= ^(NSDictionary *tokenDic) {
                        NSString *urlStr;
                        if([tokenDic[@"status"] intValue]==0){
                            if ([tokenDic[@"phone"] length]) {
                                urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getLocalToken&status=%d&token=%@&phone=%@",weakDelegate.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"token"],tokenDic[@"phone"]];
                            }else{
                                urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getLocalToken&status=%d&token=%@",weakDelegate.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"token"]];
                            }
                            
                        }else{
                            if ([tokenDic[@"phone"] length]) {
                                urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getLocalToken&status=%d&phone=%@",weakDelegate.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"phone"]];
                            }else{
                                urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getLocalToken&status=%d",weakDelegate.soureSchme,[tokenDic[@"status"] intValue]];
                            }
                            
                        }
                        //                    [weakDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                        if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                            UINavigationController *rootnav = weakDelegate.window.rootViewController;
                            [rootnav popToRootViewControllerAnimated:YES];
                        }
                        weakDelegate.soureSchme = nil;
                        weakDelegate.thirdAwakeTokenStatus = 0;
                        //weakSelf.fromThirdAwake = NO;
                        if (@available(iOS 10.0,*)) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                                
                            }];
                        }else{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                        }
                    };
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:tokenVC];
                        //                    [weakDelegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
                        if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                            UINavigationController *rootnav = weakDelegate.window.rootViewController;
                            [rootnav pushViewController:tokenVC animated:YES];
                        }
                    });
                }
                
            }
                break;
            case 2:
            {
                if (delegate.isMainSDK) {
                    delegate.isNeedPush = YES;
                    TRUSchemeTokenViewController *tokenVC = [[TRUSchemeTokenViewController alloc] init];
                    tokenVC.schemetype = 2;
                    __weak typeof(self) weakSelf = self;
                    __weak AppDelegate *weakDelegate = delegate;
                    if ([delegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                        //                        UINavigationController *rootnav = delegate.window.rootViewController;
                        [delegate.window.rootViewController presentViewController:tokenVC animated:YES completion:nil];
                    }else{
                        if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                            UINavigationController *rootnav = delegate.window.rootViewController;
                            [rootnav pushViewController:tokenVC animated:YES];
                        }
                    }
                }else{
                    delegate.isNeedPush = YES;
                    TRUSchemeTokenViewController *tokenVC = [[TRUSchemeTokenViewController alloc] init];
                    tokenVC.schemetype = 2;
                    tokenVC.isShowAuth = self.isShowAuth;
                    __weak typeof(self) weakSelf = self;
                    __weak AppDelegate *weakDelegate = delegate;
                    //                NSString *sourceScheme = delegate.soureSchme;
                    tokenVC.completionBlock= ^(NSDictionary *tokenDic) {
                        NSString *urlStr;
                        if([tokenDic[@"status"] intValue]==0){
                            if ([tokenDic[@"phone"] length]) {
                                urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getNetToken&status=%d&token=%@&phone=%@",weakDelegate.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"token"],tokenDic[@"phone"]];
                            }else{
                                urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getNetToken&status=%d&token=%@",weakDelegate.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"token"]];
                            }
                            
                        }else{
                            if ([tokenDic[@"phone"] length]) {
                                urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getNetToken&status=%d&phone=%@",weakDelegate.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"phone"]];
                            }else{
                                urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=getNetToken&status=%d",weakDelegate.soureSchme,[tokenDic[@"status"] intValue]];
                            }
                        }
                        
                        if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                            UINavigationController *rootnav = weakDelegate.window.rootViewController;
                            //                        [rootnav popViewControllerAnimated:YES];
                            [rootnav popToRootViewControllerAnimated:YES];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                weakDelegate.soureSchme = nil;
                                weakDelegate.thirdAwakeTokenStatus = 0;
                                YCLog(@"soureSchme清空");
                                //weakDelegate.fromThirdAwake = NO;
                                if (@available(iOS 10.0,*)) {
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                                        
                                    }];
                                }else{
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                                }
                            });
                        }
                    };
                    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:tokenVC];
                    //                [delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
                    if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                        UINavigationController *rootnav = weakDelegate.window.rootViewController;
                        [rootnav pushViewController:tokenVC animated:YES];
                    }
                }
                
            }
                break;
            case 3:
            {
                TRUSchemeTokenViewController *tokenVC = [[TRUSchemeTokenViewController alloc] init];
                tokenVC.schemetype = 3;
                __weak typeof(self) weakSelf = self;
                __weak AppDelegate *weakDelegate = delegate;
                tokenVC.completionBlock= ^(NSDictionary *tokenDic) {
                    NSString *urlStr;
                    if([tokenDic[@"phone"] length]){
                        urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=logout&status=%d&phone=%@",weakDelegate.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"phone"]];
                    }else{
                        urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=logout&status=%d",weakDelegate.soureSchme,[tokenDic[@"status"] intValue]];
                    }
//                    [weakDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                    if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                        UINavigationController *rootnav = weakDelegate.window.rootViewController;
//                        [rootnav popViewControllerAnimated:YES];
                        [rootnav popToRootViewControllerAnimated:YES];
                    }
                    weakDelegate.soureSchme = nil;
                    weakDelegate.thirdAwakeTokenStatus = 0;
                    //weakSelf.fromThirdAwake = NO;
                    if (@available(iOS 10.0,*)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                            
                        }];
                    }else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                };
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:tokenVC];
//                    [weakDelegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
                    if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                        UINavigationController *rootnav = weakDelegate.window.rootViewController;
                        [rootnav pushViewController:tokenVC animated:YES];
                    }
                });
            }
                break;
            case 4:
            {
                TRUSchemeTokenViewController *tokenVC = [[TRUSchemeTokenViewController alloc] init];
                tokenVC.schemetype = 4;
                __weak typeof(self) weakSelf = self;
                __weak AppDelegate *weakDelegate = delegate;
                tokenVC.completionBlock= ^(NSDictionary *tokenDic) {
                    NSString *urlStr;
                    if ([tokenDic[@"phone"] length]) {
                        urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=unBind&status=%d&phone=%@",weakDelegate.soureSchme,[tokenDic[@"status"] intValue],tokenDic[@"phone"]];
                    }else{
                        urlStr = [NSString stringWithFormat:@"%@://back?scheme=trusfortcims&type=unBind&status=%d",weakDelegate.soureSchme,[tokenDic[@"status"] intValue]];
                    }
                    
                    weakDelegate.soureSchme = nil;
                    weakDelegate.thirdAwakeTokenStatus = 0;
                    //weakSelf.fromThirdAwake = NO;
//                    [weakDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                    if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                        UINavigationController *rootnav = weakDelegate.window.rootViewController;
                        [rootnav popToRootViewControllerAnimated:YES];
                    }
                    if (@available(iOS 10.0,*)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                            
                        }];
                    }else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                    
                };
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:tokenVC];
//                    [weakDelegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
                    if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                        UINavigationController *rootnav = weakDelegate.window.rootViewController;
                        [rootnav pushViewController:tokenVC animated:YES];
                    }
                });
            }
                break;
            case 8:
            {
                delegate.isNeedPush = YES;
                TRUSchemeTokenViewController *tokenVC = [[TRUSchemeTokenViewController alloc] init];
                tokenVC.schemetype = 8;
                tokenVC.isShowAuth = NO;
                __weak typeof(self) weakSelf = self;
                __weak AppDelegate *weakDelegate = delegate;
                //                NSString *sourceScheme = delegate.soureSchme;
                NSString *cimsURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
                tokenVC.completionBlock= ^(NSDictionary *tokenDic) {
                    NSString *urlStr;
                    urlStr = [NSString stringWithFormat:@"%@://auth?scheme=trusfortcims&type=auth&cimsurl=%@&code=%@@&status=%d",weakDelegate.soureSchme,cimsURL,tokenDic[@"code"],[tokenDic[@"status"] intValue]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                            UINavigationController *rootnav = weakDelegate.window.rootViewController;
                            //                        [rootnav popViewControllerAnimated:YES];
                            [rootnav popToRootViewControllerAnimated:YES];
                            weakDelegate.soureSchme = nil;
                            weakDelegate.thirdAwakeTokenStatus = 0;
                            //                            weakDelegate.isNeedPush = NO;
                        }
                    });
                    YCLog(@"soureSchme清空");
                    //weakDelegate.fromThirdAwake = NO;
                    if (@available(iOS 10.0,*)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                            
                        }];
                    }else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                    
                };
                //                TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:tokenVC];
                //                [delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
                if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *rootnav = weakDelegate.window.rootViewController;
                    [rootnav pushViewController:tokenVC animated:YES];
                }
            }
                break;
            case 11:
            {
                delegate.isNeedPush = YES;
                TRUSchemeTokenViewController *tokenVC = [[TRUSchemeTokenViewController alloc] init];
                tokenVC.schemetype = 11;
                tokenVC.isShowAuth = NO;
                __weak typeof(self) weakSelf = self;
                __weak AppDelegate *weakDelegate = delegate;
                //                NSString *sourceScheme = delegate.soureSchme;
                NSString *cimsURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
                tokenVC.completionBlock== ^(NSDictionary *tokenDic){
                    NSString *urlStr;
                    NSString *cimsurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
                    if ([delegate.soureSchme containsString:@"://"]) {
                        urlStr = [NSString stringWithFormat:@"%@auth1?scheme=trusfortcims&type=auth1&code=%@&status=%ld&cimsurl=%@&statusmessage=%@",weakDelegate.soureSchme,tokenDic[@"code"],[tokenDic[@"codeerror"] integerValue],cimsurl,tokenDic[@"message"]];
                    }else{
                        urlStr = [NSString stringWithFormat:@"%@://auth1?scheme=trusfortcims&type=auth1&code=%@&status=%ld&cimsurl=%@&statusmessage=%@",weakDelegate.soureSchme,tokenDic[@"code"],[tokenDic[@"codeerror"] integerValue],cimsurl,tokenDic[@"message"]];
                    }
                    if (@available(iOS 10.0,*)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                            
                        }];
                    }else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                    
                };
                if ([weakDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *rootnav = weakDelegate.window.rootViewController;
                    [rootnav pushViewController:tokenVC animated:YES];
                }
            }
                break;
            default:
                break;
        }
    }
}

-(void)customUI{
    
    self.title = @"请设置您的APP登录方式";
    if(self.isFromSetting){
        self.title = @"安全保护";
    }
    TRUBaseNavigationController *nav = self.navigationController;
//    [nav setNavBarColor: DefaultGreenColor];
//    self.navigationController.navigationBarHidden = NO;
    //图标
//    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENW/2.f - 65, 64+26, 130, 120)];
//    [self.view addSubview:iconImgView];
//    iconImgView.image = [UIImage imageNamed:@"APPAuth"];

    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight+10, SCREENW, 50*4 +30) style:UITableViewStylePlain];
    [self.view addSubview:_myTableView];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = [UIColor whiteColor];
    [_myTableView registerNib:[UINib nibWithNibName:@"TRULogIdentifyCell" bundle:nil] forCellReuseIdentifier:@"TRULogIdentifyCell"];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableFooterView = [UIView new];
    _myTableView.scrollEnabled = NO;
    _myTableView.backgroundColor = RGBCOLOR(247, 249, 250);
    
    if (kDevice_Is_iPhoneX) {
//        iconImgView.frame = CGRectMake(SCREENW/2.f - 65, 64+50, 130, 120);
        _myTableView.frame = CGRectMake(0, kNavBarAndStatusBarHeight+10, SCREENW, 50*4 +30);
    }else{
//        iconImgView.frame = CGRectMake(SCREENW/2.f - 65, 64+26, 130, 120);
        _myTableView.frame = CGRectMake(0, kNavBarAndStatusBarHeight+10, SCREENW, 50*4 +30);
    }
}
#pragma mark -UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _txtArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _txtArr[section];
    return [arr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRULogIdentifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRULogIdentifyCell" forIndexPath:indexPath];
    cell.backgroundColor = RGBCOLOR(247, 249, 250);
    if (cell == nil) {
        cell = [[TRULogIdentifyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TRULogIdentifyCell"];
    }
    cell.txtLabel.text = _txtArr[indexPath.section][indexPath.row];
    NSString *str = _txtArr[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.isOnButton.hidden = YES;
    cell.iconImageView.hidden = YES;
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            cell.ArrowIcon.hidden = YES;
            cell.iconImageView.hidden = NO;
            cell.iconImageView.image = [UIImage imageNamed:@"gestureicon"];
            cell.isOnSwitch.hidden = NO;
            cell.isOnSwitch.on = isOnGesture;
        }else{
            cell.ArrowIcon.hidden = NO;
            cell.isOnSwitch.hidden = YES;
        }
    }else{
//        cell.isOnButton.hidden = YES;
        cell.isOnSwitch.hidden = NO;
        cell.iconImageView.hidden = NO;
        cell.ArrowIcon.hidden = YES;
        if ([str isEqualToString:@"FaceID验证"]) {
            cell.iconImageView.image = [UIImage imageNamed:@"faceicon"];
            cell.isOnSwitch.on = isOnFaceID;
        }else{//指纹
            cell.iconImageView.image = [UIImage imageNamed:@"fingericon"];
            cell.isOnSwitch.on = isOnFingerprint;
        }
    }
    
//    if (indexPath.section == 1) {
//        if (isOnGesture && indexPath.row == 0) {
////            cell.isOnButton.selected = YES;
//            cell.isOnSwitch.on = YES;
//        }else if(isOnFingerprint && indexPath.row == 1){
////            cell.isOnButton.selected = YES;
//            cell.isOnSwitch.on = YES;
//        }else if(isOnFaceID && indexPath.row == 1){
////            cell.isOnButton.selected = YES;
//            cell.isOnSwitch.on = YES;
//        }else{
////            cell.isOnButton.selected = NO;
//            cell.isOnSwitch.on = NO;
//        }
//    }
    
    
    
    
    __weak typeof(self) weakSelf = self;
//    [cell setIsOnBlock:^(UIButton* btn){
//        if (indexPath.row == 0) {//手势
//            [weakSelf openCloseGesVerify:btn];
//        }else{//指纹
//            if ([str isEqualToString:@"FaceID验证"]) {
//                [weakSelf openCloseFaceVefiry:btn];
//            }else{
//                [weakSelf openCloseFingerVefiry:btn];
//            }
//        }
//    }];
    
    [cell setIsOnSwitchBlock:^(UISwitch *switchBtn) {
        if (indexPath.section == 0) {//手势
            [weakSelf openCloseGesVerifyBySwitch:switchBtn];
        }else{//指纹
            if ([str isEqualToString:@"FaceID验证"]) {
                [weakSelf openCloseFaceVefiryBySwitch:switchBtn];
            }else{
                [weakSelf openCloseFingerVefiryBySwitch:switchBtn];
            }
        }
    }];
    return cell;
}
#pragma mark 开启/关闭 手势/指纹验证
- (void)openCloseGesVerify:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.isSelected) {
        
        TRUGestureSettingViewController *gesVC = [[TRUGestureSettingViewController alloc] init];
        gesVC.backBlocked =^(){
            [self requestData];
            
        };
        [self.navigationController pushViewController:gesVC animated:YES];
        
//        if (isOnFingerprint) {//说明之前是指纹验证
//            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"开启手势解锁将会关闭指纹解锁" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
//                [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
//
//                TRUGestureSettingViewController *gesVC = [[TRUGestureSettingViewController alloc] init];
//                [self.navigationController pushViewController:gesVC animated:YES];
//                gesVC.backBlocked=^(){
//                    [self requestData];
//                };
//            } cancelBlock:^{
//                btn.selected = !btn.selected;
//            }];
//        }else{
//            TRUGestureSettingViewController *gesVC = [[TRUGestureSettingViewController alloc] init];
//            gesVC.backBlocked =^(){
//                [self requestData];
//            };
//            [self.navigationController pushViewController:gesVC animated:YES];
//        }
    }else{
        if (isOnGesture) {
            [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您要关闭手势验证吗？" confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                [self requestData];
                
//                TRUGestureVerify2ViewController *gesVC = [[TRUGestureVerify2ViewController alloc] init];
//                gesVC.closeGesAuth = YES;
//                [self.navigationController pushViewController:gesVC animated:YES];
            } cancelBlock:^{
                btn.selected = !btn.selected;
            }];
        }
    }
}


- (void)openCloseGesVerifyBySwitch:(UISwitch *)switchBtn{
//    switchBtn.on = !switchBtn.isOn;
    if (switchBtn.isOn) {
        TRUGestureSettingViewController *gesVC = [[TRUGestureSettingViewController alloc] init];
        gesVC.backBlocked =^(){
            [self requestData];
        };
        [self.navigationController pushViewController:gesVC animated:YES];
        
        //        if (isOnFingerprint) {//说明之前是指纹验证
        //            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"开启手势解锁将会关闭指纹解锁" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        //                [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
        //
        //                TRUGestureSettingViewController *gesVC = [[TRUGestureSettingViewController alloc] init];
        //                [self.navigationController pushViewController:gesVC animated:YES];
        //                gesVC.backBlocked=^(){
        //                    [self requestData];
        //                };
        //            } cancelBlock:^{
        //                btn.selected = !btn.selected;
        //            }];
        //        }else{
        //            TRUGestureSettingViewController *gesVC = [[TRUGestureSettingViewController alloc] init];
        //            gesVC.backBlocked =^(){
        //                [self requestData];
        //            };
        //            [self.navigationController pushViewController:gesVC animated:YES];
        //        }
    }else{
        if (isOnGesture) {
            [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您要关闭手势验证吗？" confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                [self requestData];
                
                //                TRUGestureVerify2ViewController *gesVC = [[TRUGestureVerify2ViewController alloc] init];
                //                gesVC.closeGesAuth = YES;
                //                [self.navigationController pushViewController:gesVC animated:YES];
            } cancelBlock:^{
                switchBtn.on = !switchBtn.isOn;
            }];
        }
    }
}

- (void)openCloseFingerVefiry:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        
        TRUVerifyFingerprintViewController *fingerVC = [[TRUVerifyFingerprintViewController alloc] init];
        fingerVC.openFingerAuth = YES;
        [self.navigationController pushViewController:fingerVC animated:YES];
        fingerVC.backBlocked =^(BOOL ison){
            [self requestData];
            
        };
        
//        if (isOnGesture) {//手势开启
//            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"开启指纹解锁将会关闭手势解锁" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
//                [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
//                TRUVerifyFingerprintViewController *fingerVC = [[TRUVerifyFingerprintViewController alloc] init];
//                fingerVC.openFingerAuth = YES;
//                [self.navigationController pushViewController:fingerVC animated:YES];
//                fingerVC.backBlocked =^(BOOL ison){
//                    [self requestData];
//                };
//            } cancelBlock:^{
//                btn.selected = !btn.selected;
//            }];
//        }else{
//            TRUVerifyFingerprintViewController *fingerVC = [[TRUVerifyFingerprintViewController alloc] init];
//            fingerVC.openFingerAuth = YES;
//            [self.navigationController pushViewController:fingerVC animated:YES];
//            fingerVC.backBlocked =^(BOOL ison){
//                [self requestData];
//            };
//        }
    }else{
        [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您确定要关闭指纹登录验证" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
        } cancelBlock:^{
            btn.selected = !btn.selected;
        }];
        
    }
}

- (void)openCloseFingerVefiryBySwitch:(UISwitch *)switchBtn{
//    switchBtn.on = !switchBtn.isOn;
//    switchBtn.enabled = NO;
    if (switchBtn.isOn) {
        
        TRUVerifyFingerprintViewController *fingerVC = [[TRUVerifyFingerprintViewController alloc] init];
        fingerVC.openFingerAuth = YES;
        [self.navigationController pushViewController:fingerVC animated:YES];
        fingerVC.backBlocked =^(BOOL ison){
            [self requestData];
            
        };
//        switchBtn.enabled = YES;
        //        if (isOnGesture) {//手势开启
        //            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"开启指纹解锁将会关闭手势解锁" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        //                [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
        //                TRUVerifyFingerprintViewController *fingerVC = [[TRUVerifyFingerprintViewController alloc] init];
        //                fingerVC.openFingerAuth = YES;
        //                [self.navigationController pushViewController:fingerVC animated:YES];
        //                fingerVC.backBlocked =^(BOOL ison){
        //                    [self requestData];
        //                };
        //            } cancelBlock:^{
        //                btn.selected = !btn.selected;
        //            }];
        //        }else{
        //            TRUVerifyFingerprintViewController *fingerVC = [[TRUVerifyFingerprintViewController alloc] init];
        //            fingerVC.openFingerAuth = YES;
        //            [self.navigationController pushViewController:fingerVC animated:YES];
        //            fingerVC.backBlocked =^(BOOL ison){
        //                [self requestData];
        //            };
        //        }
    }else{
        [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您确定要关闭指纹登录验证" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
            [self refreshLeftBar];
        } cancelBlock:^{
            switchBtn.on  = !switchBtn.isOn;
        }];
//        switchBtn.enabled = YES;
    }
}

- (void)openCloseFaceVefiry:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        
        TRUVerifyFaceViewController *faceVC = [[TRUVerifyFaceViewController alloc] init];
        faceVC.openFaceAuth = YES;
        [self.navigationController pushViewController:faceVC animated:YES];
        faceVC.backBlocked =^(BOOL ison){
            [self requestData];
            
        };
        
//        if (isOnFaceID) {//人脸开启
//            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"开启FaceID解锁将会关闭手势解锁" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
//
//                [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
//                TRUVerifyFaceViewController *faceVC = [[TRUVerifyFaceViewController alloc] init];
//                faceVC.openFaceAuth = YES;
//                [self.navigationController pushViewController:faceVC animated:YES];
//
//            } cancelBlock:^{
//                btn.selected = !btn.selected;
//            }];
//        }else{
//            TRUVerifyFaceViewController *faceVC = [[TRUVerifyFaceViewController alloc] init];
//            faceVC.openFaceAuth = YES;
//            [self.navigationController pushViewController:faceVC animated:YES];
//            faceVC.backBlocked =^(BOOL ison){
//                [self requestData];
//            };
//        }
    }else{
        [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您确定要关闭FaceID登录验证" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
        } cancelBlock:^{
            btn.selected = !btn.selected;
        }];
    }
}

- (void)openCloseFaceVefiryBySwitch:(UISwitch *)switchBtn{
//    switchBtn.on = !switchBtn.isOn;
    if (switchBtn.isOn) {
        
        TRUVerifyFaceViewController *faceVC = [[TRUVerifyFaceViewController alloc] init];
        faceVC.openFaceAuth = YES;
        [self.navigationController pushViewController:faceVC animated:YES];
        faceVC.backBlocked =^(BOOL ison){
            [self requestData];
            
        };
        
        //        if (isOnFaceID) {//人脸开启
        //            [self showConfrimCancelDialogViewWithTitle:@"" msg:@"开启FaceID解锁将会关闭手势解锁" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        //
        //                [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
        //                TRUVerifyFaceViewController *faceVC = [[TRUVerifyFaceViewController alloc] init];
        //                faceVC.openFaceAuth = YES;
        //                [self.navigationController pushViewController:faceVC animated:YES];
        //
        //            } cancelBlock:^{
        //                btn.selected = !btn.selected;
        //            }];
        //        }else{
        //            TRUVerifyFaceViewController *faceVC = [[TRUVerifyFaceViewController alloc] init];
        //            faceVC.openFaceAuth = YES;
        //            [self.navigationController pushViewController:faceVC animated:YES];
        //            faceVC.backBlocked =^(BOOL ison){
        //                [self requestData];
        //            };
        //        }
    }else{
        [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您确定要关闭FaceID登录验证" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
            [self refreshLeftBar];
        } cancelBlock:^{
            switchBtn.on = !switchBtn.isOn;
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//        NSArray *arr = _txtArr[0];
        if (indexPath.row > 0) {
            TRUGestureModify1ViewController *modify1VC = [[TRUGestureModify1ViewController alloc] init];
            [self.navigationController pushViewController:modify1VC animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 0;
    }else{
        return 30;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UIView *iview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 30)];
        iview.backgroundColor = RGBCOLOR(247, 249, 250);
        return iview;
    }
}

- (BOOL)checkFingerAvailable{
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        return NO;
    }
    LAContext *ctx = [[LAContext alloc] init];
    
    if (![ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]){
        return NO;
    }
    return YES;
}

- (BOOL)checkFaceIDAvailable{
    
    LAContext *ctx = [[LAContext alloc] init];
    if (@available(iOS 11.0, *)) {
        if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]){
            if (ctx.biometryType == LABiometryTypeFaceID) {
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
        
    } else {
        YCLog(@"系统版本低于11.0");
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end


