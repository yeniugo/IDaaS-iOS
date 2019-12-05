//
//  TRUAuthenticateViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/31.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUAuthenticateViewController.h"
#import "TRUAuthenticateTopImageView.h"
#import "TRUAuthenticateBtn.h"
#import "TRUUserAPI.h"
#import "TRUhttpManager.h"
#import "xindunsdk.h"
#import "TRUPushAuthModel.h"
#import <Bugly/Bugly.h>
#import "MJRefresh.h"
#import "TRUFingerGesUtil.h"
#import "TRUAPPLogIdentifyController.h"
#import "TRUAuthSacnViewController.h"
#import "TRUSessionManagerViewController.h"
#import "TRUPushingViewController.h"
#import "AppDelegate.h"
#import "TRUHightlightedBtn.h"
#import <AVFoundation/AVFoundation.h>
#import "TRUAuthenticateCollectionCell.h"
#import "TRUThirdFaceVerifyViewController.h"
#import "TRUFaceVerifyViewController.h"
@interface TRUAuthenticateViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) TRUAuthenticateTopImageView *topImageView;
@property (nonatomic,strong) TRUAuthenticateBtn *authBtn;//认证请求按钮
@property (nonatomic,strong) TRUAuthenticateBtn *loginBtn;//登录
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIButton *scanButton;
@property (nonatomic, strong)NSMutableArray *pushModelList;
@property (nonatomic, weak) NSTimer *pushTimer;

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *imageArray;
@end

@implementation TRUAuthenticateViewController

- (void)viewDidLoad {
//    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomUI];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncAuthData) name:kRefresh3DataNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncAuthData) name:@"refreshNumber" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    if (self.navigationController.childViewControllers.count==1) {
//        self.navigationController.navigationBarHidden = YES;
//    }
//    [UIApplication sharedApplication].statusBarHidden = YES;
    //请求今日验证数量
    [self getDateCount];
    //请求当前请求数量
    [self getPushInfo];
    if (@available(iOS 11.0, *)) {
        [self.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
//    [self checkLoginAuth];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    self.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (NSString *)priveDateFormatter:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    return [formatter stringFromDate:date];
}


- (void)getDateCount{
    NSString *userid = [TRUUserAPI getUser].userId;
    if (userid) {
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *startStr = [self priveDateFormatter:[NSDate date]];
        NSString *endStr = [self priveDateFormatter:[NSDate date]];
        __weak typeof(self) weakSelf = self;
        NSString *sign = [NSString stringWithFormat:@"%@%@",startStr,endStr];
        NSArray *ctxx = @[@"startdate",startStr,@"enddate",endStr];
        NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
//        NSString *paras = [xindunsdk encryptByUserHamcandUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
        NSDictionary *paramsDic = @{@"params" : paras};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/getdatecount"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
            [weakSelf hideHudDelay:0.0];
            if (responseBody && errorno == 0) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                int code = [dic[@"code"] intValue];
                if (code == 0) {
                    NSArray *arr = dic[@"resp"];
                    for (NSDictionary *dic in arr) {
                        [weakSelf.topImageView setAuthNumber:[dic[@"verifycounts"] integerValue]];
                    }
                }
            }
        }];
    }
    
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
                            [weakSelf.authBtn setAuthNumber:badgeNumber];
                        }else{
//                            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
                            [weakSelf.authBtn setAuthNumber:badgeNumber];
                        }
                    }
                }else{
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                    [weakSelf.authBtn setAuthNumber:0];
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
            }else{
                if (userid && userid.length > 0) {
                    NSDictionary *dic = [xindunsdk userInitializedInfo:userid];
                    NSInteger errcode = [dic[@"status"] integerValue];
                    NSError *myerror = [NSError errorWithDomain:@"com.trusfort.usererror" code:errcode userInfo:dic];
//                    [Bugly reportError:myerror];
                }
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];//[NSString stringWithFormat:@"其他错误 %d", error];
                [weakSelf showHudWithText:err];
                [weakSelf hideHudDelay:2.0];
            }
        }];
    }
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor clearColor];
    }
}

- (void)syncAuthData{
    [self getPushInfo];
    [self getDateCount];
    [self.scrollView.mj_header endRefreshing];
}

- (void)setCustomUI{
//    self.navigationController.navigationBarHidden = YES;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(syncAuthData)];
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.backgroundColor = ViewDefaultBgColor;
    self.scrollView.contentSize = CGSizeMake(SCREENW, SCREENH +1);
    CGFloat imageW = SCREENW;
    CGFloat imageH;
    if (kDevice_Is_iPhoneX) {
        imageH = imageW*839/1125;
    }else{
        imageH = imageW*270/375;
    }
    self.topImageView = [[TRUAuthenticateTopImageView alloc] initWithFrame:CGRectZero];
    self.topImageView.frame = CGRectMake(0, 0, imageW, imageH);
    [self.scrollView addSubview:self.topImageView];
    CGFloat bottomH = SCREENH - imageH - 49;
    if(kDevice_Is_iPhoneX){
        bottomH = SCREENH - imageH - 49 - 34;
    }
    CGFloat authBtnX = 20;
    CGFloat authBtnY = imageH + bottomH*0.1;
    CGFloat authBtnW = SCREENW/2 -authBtnX - 10;
    CGFloat authBtnH = bottomH*0.60;
    if (kDevice_Is_iPhoneX) {
        authBtnH = bottomH*0.42;
    }
    CALayer *authBtnShadow = [CALayer layer];
    authBtnShadow.frame = CGRectMake(authBtnX, authBtnY, authBtnW, authBtnH);
    authBtnShadow.backgroundColor = RGBACOLOR(211,223,229,0.44).CGColor;
    authBtnShadow.shadowOffset = CGSizeMake(0, 7);
    authBtnShadow.shadowOpacity = 0.08;
    authBtnShadow.cornerRadius = 10;
    authBtnShadow.frame = CGRectMake(authBtnX, authBtnY, authBtnW, authBtnH);
    [self.scrollView.layer addSublayer:authBtnShadow];
    self.authBtn = [TRUAuthenticateBtn buttonWithType:UIButtonTypeCustom];
    self.authBtn.frame = CGRectMake(authBtnX, authBtnY, authBtnW, authBtnH);;
    self.authBtn.textLabel.text = @"认证请求";
    

    self.authBtn.iconImageView.image = [UIImage imageNamed:@"AuthBtnIcon"];
    [self.scrollView addSubview:self.authBtn];
    [self.authBtn addTarget:self action:@selector(authBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//
    CGFloat loginBtnX = 10 +SCREENW/2;
    CGFloat loginBtnY = authBtnY;
    CGFloat loginBtnW = authBtnW;
    CGFloat loginBtnH = authBtnH;
    CALayer *loginBtnShadow = [CALayer layer];
    loginBtnShadow.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH);
    loginBtnShadow.backgroundColor = RGBACOLOR(211,223,229,0.44).CGColor;
    loginBtnShadow.shadowOffset = CGSizeMake(0, 7);
    loginBtnShadow.shadowOpacity = 0.08;
    loginBtnShadow.cornerRadius = 10;
    [self.scrollView.layer addSublayer:loginBtnShadow];
    self.loginBtn = [TRUAuthenticateBtn buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH);
    self.loginBtn.textLabel.text = @"扫一扫";
    self.loginBtn.iconImageView.image = [UIImage imageNamed:@"saoyisaomini"];
    [self.loginBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.loginBtn];

    if (IS_IPAD) {
        self.authBtn.x = 89.0/768.0*SCREENW;
        self.authBtn.y = 627.0/1024.0*SCREENH;
        self.authBtn.width = 266.5/768.0*SCREENW;
        self.authBtn.height = 300.0/1024.0*SCREENH;
        authBtnShadow.frame = self.authBtn.frame;
        self.loginBtn.x = 420.5/768.0*SCREENW;
        self.loginBtn.y = self.authBtn.y;
        self.loginBtn.width = self.authBtn.width;
        self.loginBtn.height = self.authBtn.height;
        loginBtnShadow.frame = self.loginBtn.frame;
    }
//    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
//    collectionViewLayout.itemSize = CGSizeMake(authBtnW, authBtnH);
//    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, authBtnY, SCREENW, authBtnH) collectionViewLayout:collectionViewLayout];
//    self.collectionView.backgroundColor = [UIColor clearColor];
//    self.collectionView.scrollEnabled = NO;
//    [self.collectionView registerClass:[TRUAuthenticateCollectionCell class] forCellWithReuseIdentifier:@"TRUAuthenticateCollectionCell"];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    self.imageArray = @[@"AuthBtnIcon",@"LoginBtnIcon"];
//    self.titleArray = @[@"认证请求",@"登录控制"];
//    [self.scrollView addSubview:self.collectionView];
    
    
//    self.scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.scrollView addSubview:self.scanButton];
//    [self.scanButton addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    CGFloat scanBtnW = PointHeightPointRatio6*107;
//    CGFloat scanBtnH = scanBtnW;
//    CGFloat scanBtnX = (SCREENW-scanBtnW)/2;
//    CGFloat scanBtnY = imageH+bottomH*0.95-scanBtnH;
//    if (kDevice_Is_iPhoneX) {
//        scanBtnY = imageH+bottomH*0.92-scanBtnH;
//    }
//
//    self.scanButton.frame = CGRectMake(scanBtnX, scanBtnY, scanBtnW, scanBtnH);
//    self.scanButton.layer.cornerRadius = scanBtnW/2;
//    self.scanButton.layer.masksToBounds =YES;
//    [self.scanButton setBackgroundImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
//    [self.scanButton setBackgroundImage:[UIImage imageNamed:@"saoyisaopress"] forState:UIControlStateHighlighted];
}

#pragma mark collectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TRUAuthenticateCollectionCell *cell = (TRUAuthenticateCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TRUAuthenticateCollectionCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor blackColor];
    cell.iconImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(90, 130);
//}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TRUAuthenticateCollectionCell *cell = (TRUAuthenticateCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.highlighted = YES;
    [cell setBackgroundColor:RGBCOLOR(233, 240, 243)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cell setBackgroundColor:[UIColor whiteColor]];
    });
    YCLog(@"collectionView indexpath.row = %d",indexPath.row);
    if (indexPath==0) {
        [self authBtnClick];
    }else{
        [self loginBtnClick];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-  (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:RGBCOLOR(233, 240, 243)];
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
}

- (void)authBtnClick{
    [self detailPush];
}

- (void)authBtnClick:(UIButton *)btn{

    __weak typeof(self) weakSelf = self;
    btn.selected = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        btn.selected = NO;
    });
    [self detailPush];
    
//    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    TRUFaceVerifyViewController *faceVC = [[TRUFaceVerifyViewController alloc] init];
//    faceVC.isTest = NO;
//    if (rootVC.presentedViewController) {
//        [rootVC.presentedViewController dismissViewControllerAnimated:NO completion:^{
//            [rootVC presentViewController:faceVC animated:YES completion:nil];
//        }];
//    }else{
//        [rootVC presentViewController:faceVC animated:YES completion:nil];
//    }
    
//    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    TRUThirdFaceVerifyViewController *facevc = [[TRUThirdFaceVerifyViewController alloc] init];
//    [self.navigationController pushViewController:facevc animated:YES];
    
}

-(void)loginBtnClick{
    TRUSessionManagerViewController *vc = [[TRUSessionManagerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)loginBtnClick:(UIButton *)btn{
//    [btn setBackgroundColor:RGBCOLOR(233, 240, 243)];
    btn.selected = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [btn setBackgroundColor:[UIColor clearColor]];
        btn.selected = NO;
    });
    TRUSessionManagerViewController *vc = [[TRUSessionManagerViewController alloc] init];

//    self.navigationController.navigationBarHidden = NO;

    [self.navigationController pushViewController:vc animated:YES];
}



- (void)scanBtnClick:(UIButton *)btn{
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
                [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } cancelBlock:nil];
            }
        }];
        
    }else if (authStatus ==AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } cancelBlock:nil];
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

#pragma mark 检查是否设置解锁方式
- (void)checkLoginAuth{
    //既没有手势又没有指纹
    if ([TRUFingerGesUtil getLoginAuthGesType] == TRULoginAuthGesTypeNone && [TRUFingerGesUtil getLoginAuthFingerType] == TRULoginAuthFingerTypeNone) {
        [self showConfrimCancelDialogViewWithTitle:@"" msg:@"请设置您的APP登录方式" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
            TRUAPPLogIdentifyController *settingVC = [[TRUAPPLogIdentifyController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        } cancelBlock:nil];
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

- (void)detailPush{
    TRUPushAuthModel *model = [self fristPushModel];
    __weak typeof(self) weakSelf = self;
    if (model) {
        TRUPushingViewController *authVC = [[TRUPushingViewController alloc] init];
        authVC.userNo = [TRUUserAPI getUser].userId;
        authVC.pushModel = model;
        [authVC setDismissBlock:^(BOOL confirm) {
            [weakSelf.pushModelList removeObject:model];
            [weakSelf syncAuthData];
        }];
        TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:authVC];
//        [nav setNavBarColor:ViewDefaultBgColor];
//        [self.navigationController presentViewController:nav animated:YES completion:nil];
        [self.navigationController pushViewController:authVC animated:YES];
    }else{
        [self showHudWithText:@"暂无认证请求，请试试下拉刷新或重新发起认证"];
//        __weak typeof(self)weakSelf = self;
        [self hideHudDelay:2.0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
