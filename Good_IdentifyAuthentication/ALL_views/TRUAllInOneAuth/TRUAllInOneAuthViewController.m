//
//  TRUAllInOneAuthViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/8/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUAllInOneAuthViewController.h"
#import "CircleDynamicView.h"
#import "TRURectDynamicView.h"
#import "TRUBottomScanView.h"
#import "TRUPortalView.h"
#import "MJRefresh.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "TRUFingerGesUtil.h"
#import "TRUAPPLogIdentifyController.h"
#import "TRUAuthorizedWebViewController.h"
#import "TRUPushAuthModel.h"
#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import "TRUPushingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TRUAuthSacnViewController.h"
#import "TRUQRShowViewController.h"
#import "TRUPersonalViewController1.h"
#import "TRUEnterAPPAuthView.h"
#import <AFNetworking.h>
#import "TRUCompanyAPI.h"
#import "TRUMTDTool.h"
//#import "TrusfortDevId.h"
#import "TRUTimeSyncUtil.h"
#import "UIScrollView+UITouch.h"
#import "TRUWebLoginManagerViewController.h"
@interface TRUAllInOneAuthViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) TRUBottomScanView *bottomScanView;
@property (nonatomic,strong) CircleDynamicView *circleDynamicView;
@property (nonatomic,strong) TRUPortalView *portalView;
@property (nonatomic,strong) TRURectDynamicView *rectView;

/**
 微门户数据
 */
@property (nonatomic,strong) NSMutableArray *dataArray;

/**
 推送数据
 */
@property (nonatomic,strong) NSMutableArray *pushModelList;

@property (nonatomic, weak) NSTimer *pushTimer;
@property (nonatomic,strong) CADisplayLink *dislink;
@property (nonatomic,assign) BOOL firstRun;
@property (nonatomic,assign) BOOL isShowLock;
@property (nonatomic,assign) int updateStatus;
@end

@implementation TRUAllInOneAuthViewController
static double dytime = 0.0;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [TRUMTDTool uploadDevInfo];
    [self setCustomUI];
    [self refreshData];
    [self getPushInfo];
    [self syncTime];
    [self showFinger];
//    [self dismisslock];
//    self.isShowLock = YES;
//    if (TRUEnterAPPAuthView.lockid==1) {
//        [TRUEnterAPPAuthView unlockView];
//    }
    self.firstRun = YES;
//    [self startCountdown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"MineIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick)];
    TRUCompanyModel *model = [TRUCompanyAPI getCompany];
//    model.hasSessionControl = 1;
    if (model.hasSessionControl) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"webloginIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtoken) name:@"needpushToken" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAppAuth) name:@"pushAuthVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"needRefreshPush" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"needRefreshPush" object:nil];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.thirdAwakeTokenStatus==0) {
        [self checkUpdataWithPlist];
        [self checkPlist];
    }
}

-(void)checkPlist{
    id delegate = [UIApplication sharedApplication].delegate;
    if ([delegate respondsToSelector:@selector(checkUpdataWithPlist)]) {
        [delegate performSelector:@selector(checkUpdataWithPlist) withObject:nil];
        
    }
}

- (void)leftBarButtonClick{
    TRUWebLoginManagerViewController *weblogin = [[TRUWebLoginManagerViewController alloc] init];
    [self.navigationController pushViewController:weblogin animated:YES];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self getPushInfo];
//}

- (void)refreshList{
//    YCLog(@"test");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getPushInfo];
    });
    
}

- (void)checkUpdataWithPlist{
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/javascript",nil];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *spcode = [[NSUserDefaults standardUserDefaults] objectForKey:@"spcode"];
    NSString *updateUrl = [NSString stringWithFormat:@"%@/api/ios/cims.html?spcode=%@",baseUrl,spcode];
    updateUrl = [NSString stringWithFormat:@"%@/api/ios/cims.html",baseUrl];
    [manager GET:updateUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            YCLog(@"dic = %@",responseObject);
            TRUCompanyModel *model1 = [TRUCompanyAPI getCompany];
            TRUCompanyModel *model2 = [TRUCompanyModel modelWithDic:responseObject];
            [TRUCompanyAPI saveCompany:model2];
//            TRUCompanyModel *model3 = [TRUCompanyAPI getCompany];
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            
            if (model1.hasQrCode == model2.hasQrCode && model1.hasProtal == model2.hasProtal && model1.hasFace == model2.hasFace && model1.hasVoice == model2.hasVoice && model1.hasMtd == model2.hasMtd && model1.hasSessionControl == model2.hasSessionControl) {
//                [self showConfrimCancelDialogViewWithTitle:nil msg:@"配置文件已是最新" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:nil cancelBlock:nil];
//                self.updateStatus = 1;
//                [TrusfortDfsSdk enableSensor:model2.hasMtd];
            }else{
                [self showConfrimCancelDialogViewWithTitle:nil msg:@"配置文件已经更新，重启App" confrimTitle:@"确定" cancelTitle:nil confirmRight:NO confrimBolck:^{
//                    [TrusfortDfsSdk enableSensor:model2.hasMtd];
                    [delegate restUIForApp];
                } cancelBlock:nil];
//                self.updateStatus = 2;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YCLog(@"error");
    }];
}

- (void)showlock{
    for (UIView *view in self.view.subviews) {
        if (view.tag==1111) {
            return;
        }
    }
    UIView* view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds]; //获取当前视图控制器
    UIViewController *vc = self; //截取当前视图为图片
    imageV.image = [self snapshot:vc.view];
    
    // 添加毛玻璃效果
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = [UIScreen mainScreen].bounds;
    [imageV addSubview:effectview];
    view.tag = 1111; [view addSubview:imageV];
    [self.view addSubview:view];
}

// 获取当前屏幕显示的 viewcontroller


// 截取当前视图为图片
- (UIImage *)snapshot:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dismisslock{
    for (UIView *view in self.view.subviews) {
        if (view.tag==1111) {
            [view removeFromSuperview];
        }
    }
}

- (void)showFinger{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if ([TRUFingerGesUtil getLoginAuthType] != TRULoginAuthTypeNone) {
        if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeFinger) {
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFinger];
        }else if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeFace){
            [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeFace];
        }else if ([TRUFingerGesUtil getLoginAuthType] == TRULoginAuthTypeGesture){
            [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeture];
        }
        [TRUFingerGesUtil saveLoginAuthType:TRULoginAuthTypeNone];
        if (delegate.thirdAwakeTokenStatus==2 || delegate.thirdAwakeTokenStatus==8) {
            //            [TRUEnterAPPAuthView showLoading];
        }else{
            //            [TRUEnterAPPAuthView showAuthView];
        }
        [TRUEnterAPPAuthView showAuthView];
    }else{
        if ([TRUFingerGesUtil getLoginAuthGesType] != TRULoginAuthGesTypeNone || [TRUFingerGesUtil getLoginAuthFingerType] != TRULoginAuthFingerTypeNone) {
            if (delegate.thirdAwakeTokenStatus==2 || delegate.thirdAwakeTokenStatus==8) {
                //                [TRUEnterAPPAuthView showLoading];
            }else{
                //                [TRUEnterAPPAuthView showAuthView];
            }
            if (delegate.launchWithAuth) {
                delegate.launchWithAuth = NO;
                return;
            }
            [TRUEnterAPPAuthView showAuthView];
        }
    }
    
}

- (void)pushtoken{
    //    [HAMLogOutputWindow printLog:@"showapppush1"];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    //    [HAMLogOutputWindow printLog:@"TRUBaseTabBarController pushtoken0"];
    if (delegate.tokenPushVC!=nil) {
        //        [HAMLogOutputWindow printLog:@"TRUBaseTabBarController pushtoken3"];
        if (delegate.thirdAwakeTokenStatus==8) {
            return;
        }
        //        [HAMLogOutputWindow printLog:@"TRUBaseTabBarController pushtoken1"];
        if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = delegate.window.rootViewController;
//            [nav popToRootViewControllerAnimated:NO];
            //            [HAMLogOutputWindow printLog:@"popToRootViewControllerAnimated"];
            //        [TRUEnterAPPAuthView showAuthViewWithCompletionBlock:^{
            //
            //        }];
            //            [HAMLogOutputWindow printLog:@"TRUBaseTabBarController pushtoken2"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                [HAMLogOutputWindow printLog:@"showapppush2"];
                if (delegate.tokenPushVC) {
//                    [HAMLogOutputWindow printLog:@"showapppush3"];
                }else{
                    //                    [HAMLogOutputWindow printLog:@"showapppush4"];
                }
                [nav pushViewController:delegate.tokenPushVC animated:YES];
                delegate.tokenPushVC = nil;
            });
            
        }
    }else{
        if (delegate.appPushVC!=nil) {
            if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = delegate.window.rootViewController;
                
                if (nav.childViewControllers.count>1) {
//                    [nav popToRootViewControllerAnimated:NO];
                    //                    [HAMLogOutputWindow printLog:@"popToRootViewControllerAnimated"];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //                    [HAMLogOutputWindow printLog:@"showapppush22"];
                    //TODO: delegate.window.rootViewController
                    
                    [(UINavigationController *)(delegate.window.rootViewController) pushViewController:delegate.appPushVC animated:NO];
                    delegate.appPushVC = nil;
                });
                
            }
        }
    }
    
}

- (void)showAppAuth{
//    [HAMLogOutputWindow printLog:@"showscheme1"];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
//        [HAMLogOutputWindow printLog:@"showscheme2"];
        UINavigationController *rootnav = delegate.window.rootViewController;
        [rootnav pushViewController:delegate.appPushVC animated:NO];
        delegate.appPushVC = nil;
    }
}

- (void)rightBarButtonClick{
    TRUPersonalViewController1 *vc = [[TRUPersonalViewController1 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setCustomUI{
//    self.view.backgroundColor = DefaultGreenColor;
    [self.navigationBar setBackgroundImage:[self ls_imageWithColor:DefaultGreenColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:NavTitleFont]}];
    self.title = @"认证";
    self.linelabel.hidden = YES;
    int type ;
    TRUCompanyModel *companyModel = [TRUCompanyAPI getCompany];
    if (companyModel.hasProtal) {
        if (companyModel.hasQrCode) {
            type = 2;
        }else{
            type = 3;
        }
    }else{
        if (companyModel.hasQrCode) {
            type = 1;
        }else{
            type = 0;
        }
    }
//    type = 0;
    __weak typeof(self) weakSelf = self;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.backgroundColor = DefaultGreenColor;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
        [weakSelf getPushInfo];
        [weakSelf syncTime];
        [weakSelf.scrollView.mj_header endRefreshing];
    }];
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    scrollView.mj_header = header;
//    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREENW, SCREENH - kNavBarAndStatusBarHeight);
    scrollView.contentSize = CGSizeMake(SCREENW, SCREENH - kNavBarAndStatusBarHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO; 
    switch (type) {
        case 0:
        {
            self.scrollView.hidden = NO;
            TRUBottomScanView *bottomScanView = [[TRUBottomScanView alloc] initWithFrame:CGRectMake(0, (SCREENH - kNavBarAndStatusBarHeight - kTabBarBottom)*0.6 , SCREENW, (SCREENH - kNavBarAndStatusBarHeight -kTabBarBottom)*0.4+kTabBarBottom)];
            bottomScanView.backgroundColor = ViewDefaultBgColor1;
            bottomScanView.hasQRBtn = NO;
            self.bottomScanView = bottomScanView;
            bottomScanView.authBtnClick = ^(TRUPushAuthModel * _Nonnull model) {
                TRUPushingViewController *authVC = [[TRUPushingViewController alloc] init];
                authVC.userNo = [TRUUserAPI getUser].userId;
                authVC.pushModel = model;
                [authVC setDismissBlock:^(BOOL confirm) {
                    [weakSelf.pushModelList removeObject:model];
                    [weakSelf getPushInfo];
                }];
                [self.navigationController pushViewController:authVC animated:YES];
            };
            bottomScanView.scanButtonClick = ^{
                [weakSelf scanBtnClick];
            };

            [self.scrollView addSubview:bottomScanView];
            CircleDynamicView *circleDynamicView = [[CircleDynamicView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, (SCREENH - kNavBarAndStatusBarHeight - kTabBarBottom)*0.6)];
            circleDynamicView.backgroundColor = DefaultGreenColor;
            self.circleDynamicView = circleDynamicView;
            [self.scrollView addSubview:circleDynamicView];
        }
            break;
        case 1:
        {
            self.scrollView.hidden = NO;
            TRUBottomScanView *bottomScanView = [[TRUBottomScanView alloc] initWithFrame:CGRectMake(0, (SCREENH - kNavBarAndStatusBarHeight - kTabBarBottom)*0.6, SCREENW, (SCREENH - kNavBarAndStatusBarHeight - kTabBarBottom)*0.4+kTabBarBottom)];
            bottomScanView.backgroundColor = ViewDefaultBgColor1;
            bottomScanView.hasQRBtn = YES;
            self.bottomScanView = bottomScanView;
            bottomScanView.scanButtonClick = ^{
                [weakSelf scanBtnClick];
            };
            bottomScanView.qrButtonClick = ^{
                TRUQRShowViewController *vc = [[TRUQRShowViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            bottomScanView.authBtnClick = ^(TRUPushAuthModel * _Nonnull model) {
                TRUPushingViewController *authVC = [[TRUPushingViewController alloc] init];
                authVC.userNo = [TRUUserAPI getUser].userId;
                authVC.pushModel = model;
                [authVC setDismissBlock:^(BOOL confirm) {
                    [weakSelf.pushModelList removeObject:model];
                    [weakSelf getPushInfo];
                }];
                [weakSelf.navigationController pushViewController:authVC animated:YES];
            };
            [self.scrollView addSubview:bottomScanView];
            CircleDynamicView *circleDynamicView = [[CircleDynamicView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, (SCREENH - kNavBarAndStatusBarHeight - kTabBarBottom)*0.6)];
            circleDynamicView.backgroundColor = DefaultGreenColor;
            self.circleDynamicView = circleDynamicView;
            [self.scrollView addSubview:circleDynamicView];
        }
            break;
        case 2:
        {
            self.scrollView.hidden = NO;
            TRUPortalView *portalView = [[TRUPortalView alloc] initWithFrame:CGRectMake(0, 120 *PointWidthRatioX , SCREENW , SCREENH - kNavBarAndStatusBarHeight - 120 *PointWidthRatioX)];
            portalView.backgroundColor = ViewDefaultBgColor1;
            self.portalView = portalView;
//            portalView.refreshBlock = ^{
//                [weakSelf refreshData];
//                [weakSelf getPushInfo];
//            };
            portalView.authBtnClick = ^(TRUPushAuthModel * _Nonnull model) {
                TRUPushingViewController *authVC = [[TRUPushingViewController alloc] init];
                authVC.userNo = [TRUUserAPI getUser].userId;
                authVC.pushModel = model;
                [authVC setDismissBlock:^(BOOL confirm) {
                    [weakSelf.pushModelList removeObject:model];
                    [weakSelf getPushInfo];
                    [weakSelf refreshData];
                }];
                [weakSelf.navigationController pushViewController:authVC animated:YES];
            };
            portalView.portalClick = ^(TRUPortalModel * _Nonnull cellmodel) {
                if (cellmodel.appName.length==0) {
                    return;
                }
                if([cellmodel.type isEqualToString:@"h5"]){
                    [weakSelf getTokenWithRefreshTokenAndTokenByUseridwithappid:cellmodel.appId withResult:^(NSString *token) {
                        NSString *urlstr = [NSString stringWithFormat:@"%@?token=%@",cellmodel.h5Url,token];
                        if([cellmodel.h5Url hasSuffix:@"?token="]){
                            urlstr = [NSString stringWithFormat:@"%@%@",cellmodel.h5Url,token];
                        }
                        TRUAuthorizedWebViewController *webview = [[TRUAuthorizedWebViewController alloc] init];
                        webview.urlStr = urlstr;
                        [weakSelf.navigationController pushViewController:webview animated:YES];
                    }];
                }else if([cellmodel.type isEqualToString:@"scheme"]){
                    NSString *urlStr = cellmodel.iosSchema;
                    if(![urlStr containsString:@"://"]){
                        urlStr = [NSString stringWithFormat:@"%@://",urlStr];
                    }
                    NSString *downloadStr = cellmodel.iosDownloadUrl;
                    if (@available(iOS 10.0,*)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                            if (!success) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr] options:nil completionHandler:^(BOOL success) {
                                    if (!success) {
                                        [weakSelf showHudWithText:@"下载地址错误"];
                                        [weakSelf hideHudDelay:2];
                                    }
                                }];
                            }
                        }];
                    }else{
                        BOOL canopen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                        if (!canopen) {
                            canopen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr]];
                            if (!canopen) {
                                [weakSelf showHudWithText:@"下载地址错误"];
                                [weakSelf hideHudDelay:2];
                            }
                        }
                    }
                }
            };
            [self.scrollView addSubview:portalView];
            TRURectDynamicView *rectView = [[TRURectDynamicView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 120*PointWidthRatioX)];
            rectView.hasScanBtn = YES;
            self.rectView = rectView;
            rectView.scanButtonClick = ^{
                [weakSelf scanBtnClick];
            };
            rectView.qrButtonClick = ^{
                TRUQRShowViewController *vc = [[TRUQRShowViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            rectView.backgroundColor = DefaultGreenColor;
            [self.scrollView addSubview:rectView];
        }
            break;
        case 3:
        {
            self.scrollView.hidden = NO;
            TRUPortalView *portalView = [[TRUPortalView alloc] initWithFrame:CGRectMake(0, 120 *PointWidthRatioX, SCREENW, SCREENH - kNavBarAndStatusBarHeight - 120 *PointWidthRatioX)];
            portalView.backgroundColor = ViewDefaultBgColor1;
            self.portalView = portalView;
//            portalView.refreshBlock = ^{
//                [weakSelf refreshData];
//                [weakSelf getPushInfo];
//            };
            portalView.authBtnClick = ^(TRUPushAuthModel * _Nonnull model) {
                TRUPushingViewController *authVC = [[TRUPushingViewController alloc] init];
                authVC.userNo = [TRUUserAPI getUser].userId;
                authVC.pushModel = model;
                [authVC setDismissBlock:^(BOOL confirm) {
                    [weakSelf.pushModelList removeObject:model];
                    [weakSelf getPushInfo];
                    [weakSelf refreshData];
                }];
                [weakSelf.navigationController pushViewController:authVC animated:YES];
            };
            portalView.portalClick = ^(TRUPortalModel * _Nonnull cellmodel) {
//                NSString *urlStr = cellmodel.schema;
                if (cellmodel.appName.length==0) {
                    return;
                }
                if([cellmodel.type isEqualToString:@"h5"]){
                    [weakSelf getTokenWithRefreshTokenAndTokenByUseridwithappid:cellmodel.appId withResult:^(NSString *token) {
                        NSString *urlstr = [NSString stringWithFormat:@"%@?token=%@",cellmodel.h5Url,token];
                        if([cellmodel.h5Url hasSuffix:@"?token="]){
                            urlstr = [NSString stringWithFormat:@"%@%@",cellmodel.h5Url,token];
                        }
                        TRUAuthorizedWebViewController *webview = [[TRUAuthorizedWebViewController alloc] init];
                        webview.urlStr = urlstr;
                        [weakSelf.navigationController pushViewController:webview animated:YES];
                    }];
                }else if([cellmodel.type isEqualToString:@"scheme"]){
                    NSString *urlStr = cellmodel.iosSchema;
                    if(![urlStr containsString:@"://"]){
                        urlStr = [NSString stringWithFormat:@"%@://",urlStr];
                    }
                    NSString *downloadStr = cellmodel.iosDownloadUrl;
                    if (@available(iOS 10.0,*)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                            if (!success) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr] options:nil completionHandler:^(BOOL success) {
                                    if (!success) {
                                        [weakSelf showHudWithText:@"下载地址错误"];
                                        [weakSelf hideHudDelay:2];
                                    }
                                }];
                            }
                        }];
                    }else{
                        BOOL canopen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                        if (!canopen) {
                            canopen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr]];
                            if (!canopen) {
                                [weakSelf showHudWithText:@"下载地址错误"];
                                [weakSelf hideHudDelay:2];
                            }
                        }
                    }
                }
            };
            [self.scrollView addSubview:portalView];
            TRURectDynamicView *rectView = [[TRURectDynamicView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 120*PointWidthRatioX)];
            rectView.hasScanBtn = NO;
            self.rectView = rectView;
            rectView.scanButtonClick = ^{
                [weakSelf scanBtnClick];
            };
            rectView.backgroundColor = DefaultGreenColor;
            [self.scrollView addSubview:rectView];
        }
            break;
        default:
            break;
    }
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
}

- (void)scanBtnClick{
    __weak typeof(self) weakSelf = self;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        TRUAuthSacnViewController *scanVC = [[TRUAuthSacnViewController alloc] init];
        [self.navigationController pushViewController:scanVC animated:YES];
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                TRUAuthSacnViewController *scanVC = [[TRUAuthSacnViewController alloc] init];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    [weakSelf.navigationController pushViewController:scanVC animated:YES];
                });
            }else{
                [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
                    //                    [self dismissViewControllerAnimated:YES completion:nil];
                    //                    [self.navigationController popViewControllerAnimated:YES];
                    //                    if([TRUUserAPI haveSubUser]){
                    //                        [self.navigationController popViewControllerAnimated:YES];
                    //                    }else{
                    //                        [self dismissViewControllerAnimated:YES completion:nil];
                    //                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    //                    [HAMLogOutputWindow printLog:@"popViewControllerAnimated"];
                } cancelBlock:nil];
            }
        }];
        //
    }else if (authStatus ==AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } cancelBlock:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self checkLoginAuth];
    [self getPushInfo];
    [self startCountdown];
    
//    if (!self.isShowLock) {
//        [self showlock];
//    }
}

- (void)setSystemBarStyle{
    if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //        return UIStatusBarStyleDarkContent;
        } else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //        return UIStatusBarStyleDefault;
        }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.dislink invalidate];
    self.dislink = nil;
}

- (void)checkLoginAuth{
    //既没有手势又没有指纹
    if ([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeNone && [TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeNone) {
        [self showConfrimCancelDialogViewWithTitle:@"" msg:@"请设置您的APP登录方式" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
            TRUAPPLogIdentifyController *settingVC = [[TRUAPPLogIdentifyController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        } cancelBlock:nil];
    }
}

- (void)syncTime{
    [TRUTimeSyncUtil syncTimeWithResult:^(int error) {
        [self hideHudDelay:0.0];
        if (error == 0) {
//            [self showHudWithText:@"校准成功"];
//            [self hideHudDelay:2.0];
        }else if (error == -5004){
            [self showHudWithText:@"网络错误，稍后请重试"];
            [self hideHudDelay:2.0];
        }else if (9008 == error){
            [self deal9008Error];
        }else{
            NSString *err = [NSString stringWithFormat:@"其他错误（%d）",error];
            [self showHudWithText:err];
            [self hideHudDelay:2.0];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });
    }];
}

- (void)refreshData{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    if (userid) {
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
        NSDictionary *paramsDic = @{@"params" : paras};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getAppList"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
            [weakSelf hideHudDelay:0.0];
            weakSelf.dataArray = [NSMutableArray array];
            if (errorno == 0) {
                if (responseBody) {
                    NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                    int code = [dic[@"code"] intValue];
                    if (code == 0) {
                        NSArray *dataArr = dic[@"resp"];
//                        NSArray *dataArr;
//                        NSMutableArray *tempArray = [NSMutableArray array];
//                        for (int i = 0; i < 5; i++) {
//                            TRUPortalModel *model = [[TRUPortalModel alloc] init];
//                            model.appName = [NSString stringWithFormat:@"%d",i];
//                            [tempArray addObject:[model yy_modelToJSONObject]];
//                        }
//                        dataArr = tempArray;
                        if (dataArr.count>0) {
                            for (int i = 0; i< dataArr.count; i++) {
                                NSDictionary *dic = dataArr[i];
                                TRUPortalModel *model = [TRUPortalModel modelWithDic:dic];
                                [weakSelf.dataArray addObject:model];
                            }
                            if(dataArr.count%3==1){
                                TRUPortalModel *model = [weakSelf.dataArray lastObject];
                                model.cellType = 1;
                                TRUPortalModel *model1 = [[TRUPortalModel alloc] init];
                                [weakSelf.dataArray addObject:model1];
                                TRUPortalModel *model2 = [[TRUPortalModel alloc] init];
                                model2.cellType = 2;
                                [weakSelf.dataArray addObject:model2];
                            }else if(dataArr.count%3==2){
                                TRUPortalModel *model = weakSelf.dataArray[weakSelf.dataArray.count-2];
                                model.cellType = 1;
                                TRUPortalModel *model1 = [[TRUPortalModel alloc] init];
                                model1.cellType = 2;
                                [weakSelf.dataArray addObject:model1];
                            }else{
                                TRUPortalModel *model1 = weakSelf.dataArray[weakSelf.dataArray.count-1];
                                model1.cellType = 2;
                                TRUPortalModel *model2 = weakSelf.dataArray[weakSelf.dataArray.count-3];
                                model2.cellType = 1;
                            }
                            
                        }else{
                            
                        }
                        [weakSelf.portalView stopRefresh];
                        weakSelf.portalView.dataArray = weakSelf.dataArray;
                        
                    }
                }else{
                    
                }
                
            }else if (errorno == 0 && !responseBody){
                //                _topView.requestImgview.hidden = YES;
                //                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            }else if (-5004 == errorno){
                [weakSelf showHudWithText:@"网络错误，稍后请重试"];
                [weakSelf hideHudDelay:2.0];
            }else if (9008 == errorno){
                [weakSelf deal9008Error];
            }else if (9019 == errorno){
                [weakSelf deal9019Error];
            }else if (9025 == errorno){
                [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您的设备已被锁定，请联系管理员！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                } cancelBlock:^{
                }];
            }else{
                NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
                //[NSString stringWithFormat:@"其他错误 %d", error];
                [weakSelf showHudWithText:err];
                [weakSelf hideHudDelay:2.0];
            }
        }];
    }
}

- (void)getTokenWithRefreshTokenAndTokenByUseridwithappid:(NSString *)appid withResult:(void (^)(NSString* token))onResult{
    __weak typeof(self) weakSelf = self;
    NSString *mainuserid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *paras = [xindunsdk encryptByUkey:mainuserid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/token/gen"] withParts:dictt onResult:^(int errorno, id responseBody){
        //        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"refreshtoken error = %d",errorno]];
        if(errorno==0){
            YCLog(@"%@",responseBody);
            if (responseBody!=nil) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                if([dic[@"code"] intValue]==0){
                    dic = dic[@"resp"];
                    NSString *refreshToken = dic[@"refresh_token"];
                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                    NSString *sign = [NSString stringWithFormat:@"%@%@%@",mainuserid,refreshToken,appid];
                    NSArray *ctxx = @[@"userId",mainuserid,@"refreshToken",refreshToken,@"appId",appid];
                    NSString *paras = [xindunsdk encryptByUkey:mainuserid ctx:ctxx signdata:sign isDeviceType:NO];
                    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
                    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/token/refresh"] withParts:dictt onResult:^(int errorno, id responseBody){
                        YCLog(@"errorno = %d",errorno);
                        //                        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"token error = %d",errorno]];
                        if (errorno==0) {
                            if (responseBody!=nil) {
                                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                                if ([dic[@"code"] intValue]==0) {
                                    dic = dic[@"resp"];
                                    NSString *token = dic[@"access_token"];
                                    onResult(token);
                                }
                            }
                        }else{
                            [weakSelf showHudWithText:[NSString stringWithFormat:@"%d错误",errorno]];
                            [weakSelf hideHudDelay:2.0];
                        }
                    }];
                }
            }
        }else{
            
        }
    }];
}

- (void)getPushInfo{
    if (!_pushModelList) {
        _pushModelList = [NSMutableArray new];
    }
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    if (userid) {
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:YES];
        NSDictionary *paramsDic = @{@"params" : paras};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/push/getlist"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
            [weakSelf hideHudDelay:0.0];
            [weakSelf.pushModelList removeAllObjects];
            if (errorno == 0) {
                if (responseBody) {
                    NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                    int code = [dic[@"code"] intValue];
                    if (code == 0) {
                        NSArray *dataArr = dic[@"resp"];;
                        if (dataArr.count>0) {
                            for (int i = 0; i< dataArr.count; i++) {
                                NSDictionary *dic = dataArr[i];
                                TRUPushAuthModel *model = [TRUPushAuthModel modelWithDic:dic];
                                [weakSelf.pushModelList addObject:model];
                            }
                        }
                        NSInteger badgeNumber = self.pushModelList.count;
                        //更新  当前请求的数量
                        if (badgeNumber>0) {
                            [weakSelf startPushCounterAndRefresh];
                            //                            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
                            //                        _topView.requestImgview.hidden = NO;
                            //                        _topView.requestLabel.text = [NSString stringWithFormat:@"%ld",(long)badgeNumber];
                            weakSelf.portalView.model = [weakSelf fristPushModel];
                            weakSelf.bottomScanView.model = [weakSelf fristPushModel];
                        }else{
                            //                            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
                            weakSelf.portalView.model = nil;
                            weakSelf.bottomScanView.model = nil;
                        }
                    }
                }else{
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                    weakSelf.portalView.model = nil;
                    weakSelf.bottomScanView.model = nil;
                }
            }else if (errorno == 0 && !responseBody){
                //                _topView.requestImgview.hidden = YES;
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            }else if (-5004 == errorno){
                [weakSelf showHudWithText:@"网络错误，稍后请重试"];
                [weakSelf hideHudDelay:2.0];
            }else if (9008 == errorno){
                [weakSelf deal9008Error];
            }else if (9019 == errorno){
                [weakSelf deal9019Error];
            }else if (9025 == errorno){
                [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"您的设备已被锁定，请联系管理员！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                } cancelBlock:^{
                }];
            }else{
                if (userid && userid.length > 0) {
                    NSDictionary *dic = [xindunsdk userInitializedInfo:userid];
                    NSInteger errcode = [dic[@"status"] integerValue];
                    NSError *myerror = [NSError errorWithDomain:@"com.trusfort.usererror" code:errcode userInfo:dic];
                    [Bugly reportError:myerror];
                }
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];//[NSString stringWithFormat:@"其他错误 %d", error];
                [weakSelf showHudWithText:err];
                [weakSelf hideHudDelay:2.0];
            }
        }];
    }
}

#pragma mark -根据push请求的剩余时间 刷新push信息
static NSInteger pushCount = NSIntegerMax;
- (void)startPushCounterAndRefresh{
    __weak typeof(self) weakSelf = self;
    [weakSelf.pushModelList enumerateObjectsUsingBlock:^(TRUPushAuthModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (pushCount > obj.ttl) pushCount = obj.ttl;
    }];
    if (pushCount == 0) pushCount = 60;
    if (!weakSelf.pushTimer) {
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(countdownPushTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [timer fire];
        weakSelf.pushTimer = timer;
    }
}

- (void)countdownPushTime{
    pushCount --;
    if (pushCount <= 0){
        [self.pushTimer invalidate];
        self.pushTimer = nil;
        [self getPushInfo];
    }
}

#pragma mark 处理当前请求

-(TRUPushAuthModel*)fristPushModel{
    
    if (self.pushModelList.count == 0) {
        return nil;
    }else if (self.pushModelList.count == 1){
        TRUPushAuthModel *model = self.pushModelList.firstObject;
        return model;
    }else{
        /*开始冒泡排序*/
        TRUPushAuthModel *NewModel;
        TRUPushAuthModel *currentModel = self.pushModelList[0];
        for(int i=1;i<self.pushModelList.count;i++){
            TRUPushAuthModel *model = self.pushModelList[i];
            YCLog(@"currentModel--->%@",currentModel.dateTime);
            YCLog(@"modeli.dateTime--->%@",model.dateTime);
            if ([self compareDate:currentModel.dateTime withDate:model.dateTime] >0){
                currentModel = model;
                NewModel = currentModel;
            }
        }
        if (!NewModel) {
            NewModel = currentModel;
        }
        return NewModel;
    }
}
//遍历数组找到最新的推送消息
- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa = 0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result ==NSOrderedSame)
    {
        aa=0;
    }else if (result ==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result ==NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
    }
    return aa;
}
#pragma mark - 动态口令
- (void)startCountdown{
    
    if (!self.dislink) {
        self.dislink = [CADisplayLink displayLinkWithTarget:self selector:@selector(runDisLink)];
        [self.dislink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
}

- (void)runDisLink{
    CGFloat time = [self getPersent];
    self.circleDynamicView.percent = time;
    self.rectView.percent = time;
}

- (CGFloat)getPersent{
    NSDate *date = [NSDate date];
    double time = [date timeIntervalSince1970];
    double timeDifference = [[[NSUserDefaults standardUserDefaults] objectForKey:@"GS_DETAL_KEY"] doubleValue];
    long time1 = (long)(time-timeDifference)/30;
    double time2 = [[NSUserDefaults standardUserDefaults] doubleForKey:@"password1"];
    if (self.firstRun) {
        [[NSUserDefaults standardUserDefaults] setDouble:(double)(time1) forKey:@"password1"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.firstRun = NO;
        //        [self requestData];
        NSString *userid = [TRUUserAPI getUser].userId;
        NSString *passwordStr = [xindunsdk getCIMSDynamicCode:userid];
        self.rectView.passwordStr = passwordStr;
        self.circleDynamicView.passwordStr = passwordStr;
    }else{
        if ((long)time2!=time1) {
            YCLog(@"change------------");
            //            [self requestData];
            NSString *userid = [TRUUserAPI getUser].userId;
            NSString *passwordStr = [xindunsdk getCIMSDynamicCode:userid];
            self.rectView.passwordStr = passwordStr;
            self.circleDynamicView.passwordStr = passwordStr;
            [[NSUserDefaults standardUserDefaults] setDouble:(double)(time1) forKey:@"password1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
        }
    }
    return (long long)((time-timeDifference)*100)%3000/3000.0;
}

#pragma mark - 检查更新
-(void)checkVersion{
    // 获取发布版本的version
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/javascript",nil];
    //http://itunes.apple.com/lookup?id=1095195364
    NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=1195763218"];//
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"results"];
        if ([array count] > 0) {
            NSDictionary *dic = array[0];
            NSString *appStoreVersion = dic[@"version"];
            //打印版本号
            [self checkAppUpdate:appStoreVersion];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YCLog(@"获取版本号失败！");
    }];
}

-(void)checkAppUpdate:(NSString *)appInfo{
    //版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    //    YCLog(@"商店版本：%@ ,当前版本:%@",appInfo,version);
    if ([self updeWithDicString:version andOldString:appInfo]) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.hasUpdate = YES;
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"新版本 %@ 已发布!",appInfo] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *url = @"https://itunes.apple.com/cn/app/id1195763218?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }];
        
        UIAlertAction *cancelAction =  [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:confrimAction];//
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            [delegate.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
        });
    }else{
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.hasUpdate = NO;
        YCLog(@"不用更新");
    }
}



-(BOOL)updeWithDicString:(NSString *)version andOldString:(NSString *)appVersion{
    
    NSArray *a1 = [version componentsSeparatedByString:@"."];
    NSArray *a2 = [appVersion componentsSeparatedByString:@"."];
    
    for (int i = 0; i < [a1 count]; i++) {
        if ([a2 count] > i) {
            if ([[a1 objectAtIndex:i] intValue] < [[a2 objectAtIndex:i] intValue]) {
                return YES;
            }
            else if ([[a1 objectAtIndex:i] intValue] > [[a2 objectAtIndex:i] intValue])
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    return [a1 count] < [a2 count];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y >= 0) {
        offset.y = 0;
    }
    scrollView.contentOffset = offset;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
