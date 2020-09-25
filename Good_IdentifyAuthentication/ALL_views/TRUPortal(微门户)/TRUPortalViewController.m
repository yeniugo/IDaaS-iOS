//
//  TRUPortalViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2019/3/19.
//  Copyright © 2019 zyc. All rights reserved.
//

#import "TRUPortalViewController.h"
#import "TRUPortalCell.h"
#import <YYWebImage.h>
#import "MJRefresh.h"
#import "TRUFingerGesUtil.h"
#import "TRUAPPLogIdentifyController.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "AppDelegate.h"
#import "TRUAuthorizedWebViewController.h"
#import "TRUTimeSyncUtil.h"
@interface TRUPortalViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UILabel *showLB;
@property (nonatomic,assign) BOOL tokenRefreshFailure;
@end

@implementation TRUPortalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.linelabel.hidden = YES;
    // Do any additional setup after loading the view.
    UIImageView *imageview = [[UIImageView alloc] init];
    [self.view addSubview:imageview];
    imageview.frame = CGRectMake(0, 0, SCREENW, 168.0/375*SCREENW);
    imageview.image = [UIImage imageNamed:@"portal_banner.png"];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.view addSubview:btn];
//    btn.frame = CGRectMake(0, 0, 100, 100);
//    btn.backgroundColor = [UIColor redColor];
//    [btn setTitle:@"清除本地token" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(cleanRefreshToken) forControlEvents:UIControlEventTouchUpInside];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 168.0/375*SCREENW, SCREEN_WIDTH, SCREEN_HEIGHT - kTabBarHeight - 168.0/375*SCREENW) collectionViewLayout:flow];
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = ViewDefaultBgColor;
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
        [self.collectionView.mj_header endRefreshing];
    }];
    [self.view addSubview:collectionView];
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    //    flow.headerReferenceSize = CGSizeMake(SCREENW, 168.0/375*SCREENW);
    [collectionView registerClass:[TRUPortalCell class] forCellWithReuseIdentifier:@"TRUPortalCell"];
    //    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TRUPortalCell"];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    UILabel *showlabel = [[UILabel alloc] init];
    //    showlabel.tag = 1000;
    showlabel.frame = CGRectMake(0, (SCREEN_HEIGHT - kTabBarHeight - 168.0/375*SCREENW)/2, SCREENW, 20);
    [self.collectionView addSubview:showlabel];
    showlabel.textColor = RGBCOLOR(211, 211, 211);
    showlabel.textAlignment = NSTextAlignmentCenter;
    showlabel.text = @"暂无可用应用";
    showlabel.hidden = YES;
    self.showLB = showlabel;
    [self refreshData];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"app status = %d",delegate.thirdAwakeTokenStatus]];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (delegate.thirdAwakeTokenStatus == 0) {
            [weakSelf refreshtoken];
        }
    });
//    [self refreshtoken];
    [self syncTime];
}

- (void)syncTime{
    [TRUTimeSyncUtil syncTimeWithResult:^(int error){
        
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
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRUEnterAPPAuthViewSuccess" object:nil];
//                    [TRULockSWindow dismissAuthView];
                }
            }
        }else if(errorno == -5004){
            [weakSelf showHudWithText:@"网络错误，稍后请重试"];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}

- (void)cleanRefreshToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"refresh_token"];
    [defaults synchronize];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkLoginAuth];
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

- (void)refreshData{
    //mapi/01/init/getAppList
    __weak typeof(self) weakSelf = self;
    //    __block NSArray *tempArray = self.dataArray;
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
                        if (dataArr.count>0) {
                            for (int i = 0; i< dataArr.count; i++) {
                                NSDictionary *dic = dataArr[i];
                                TRUPortalModel *model = [TRUPortalModel modelWithDic:dic];
                                [weakSelf.dataArray addObject:model];
                            }
                        }
                        [weakSelf.collectionView reloadData];
                        if (weakSelf.dataArray.count) {
                            self.showLB.hidden = YES;
                        }else{
                            self.showLB.hidden = NO;
                        }
                        
                        
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
            }else{
                //                if (weakSelf.dataArray.count) {
                //                    self.showLB.hidden = YES;
                //                }else{
                //                    self.showLB.hidden = NO;
                //                }
                NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];//[NSString stringWithFormat:@"其他错误 %d", error];
                [weakSelf showHudWithText:err];
                [weakSelf hideHudDelay:2.0];
            }
        }];
    }
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TRUPortalCell" forIndexPath:indexPath];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 168.0/375*SCREENW)];
//    [imageView yy_setImageWithURL:nil placeholder:nil];
//    [headerView addSubview:imageView];
//    return headerView;
//}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *portalCellindex = @"TRUPortalCell";
    TRUPortalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:portalCellindex forIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor redColor];
    cell.cellModel = self.dataArray[indexPath.row];
    cell.lineType = collectioncellLineRight | collectioncellLineTop;
    if (self.dataArray.count<4) {
        cell.lineType = collectioncellLineRight | collectioncellLineTop | collectioncellLineBottom;
    }
    if ((self.dataArray.count>3)&&(indexPath.item>self.dataArray.count-4)) {
        cell.lineType = collectioncellLineRight | collectioncellLineTop | collectioncellLineBottom;
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return self.dataArray.count;
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREENW/3, SCREENW/3);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    TRUPortalModel *cellmodel = self.dataArray[indexPath.row];
    NSArray *urlArray = [cellmodel.iosScheme componentsSeparatedByString:@"|"];
    NSString *urlStr = [urlArray lastObject];
    NSString *phone = [TRUUserAPI getUser].phone;
//    urlStr = @"http://www.baidu.com?token=";
    if([urlStr hasPrefix:@"https://"]||[urlStr hasPrefix:@"http://"]){
        if ([urlArray.firstObject isEqualToString:@"youjian"]) {
            [self showActivityWithText:nil];
        }
        [self getTokenWithRefreshTokenAndTokenByUseridwithappid:cellmodel.appId withResult:^(NSString *token) {
            
            NSString *urlstr = [NSString stringWithFormat:@"%@%@",urlStr,token];
            if ([urlArray.firstObject isEqualToString:@"fawu"]) {
                urlstr = [NSString stringWithFormat:@"%@?usercode=%@&token=%@",[urlArray lastObject],phone,token];
            }
            if ([urlArray.firstObject isEqualToString:@"youjian"]) {
                [weakSelf hideHudDelay:0.0];
                [weakSelf oamail:urlArray.lastObject];
                return;
            }
            TRUAuthorizedWebViewController *webview = [[TRUAuthorizedWebViewController alloc] init];
            webview.urlStr = urlstr;
//            [HAMLogOutputWindow printLog:urlstr];
//            webview.urlStr = @"http://www.baidu.com";
            [self.navigationController pushViewController:webview animated:YES];
        }];
    }else{
        if(![urlStr containsString:@"://"]){
            urlStr = [NSString stringWithFormat:@"%@://",urlStr];
        }
        NSString *downloadStr = cellmodel.iosDownloadUrl;
        //        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"open scheme = %@",cellmodel.iosScheme]];
        if (@available(iOS 10.0,*)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:nil completionHandler:^(BOOL success) {
                if (!success) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr] options:nil completionHandler:^(BOOL success) {
                        if (!success) {
//                            [self showHudWithText:@"下载地址错误"];
//                            [self hideHudDelay:2];
                        }
                    }];
                    
                    
                }
            }];
        }else{
            BOOL canopen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            if (!canopen) {
                canopen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr]];
                if (!canopen) {
//                    [self showHudWithText:@"下载地址错误"];
//                    [self hideHudDelay:2];
                }
            }
        }
        
        
    }
}

- (void)oamail:(NSString *)redirectURL{
    __weak typeof(self) weakSelf = self;
    NSString *mainuserid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *sign = [NSString stringWithFormat:@"%@",redirectURL];
    NSArray *ctxx = @[@"redirectURL",redirectURL];
    NSString *paras = [xindunsdk encryptByUkey:mainuserid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [self showActivityWithText:nil];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/loginEmail"] withParts:dictt onResult:^(int errorno, id responseBody){
        [weakSelf hideHudDelay:0.0];
        if (errorno==0) {
            if (responseBody!=nil){
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                if ([dic[@"code"] intValue]==0) {
                    dic = dic[@"resp"];
                    NSString *url = dic[@"url"];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                }
            }
        }else{
            
        }
    }];
}

- (void)getTokenWithRefreshTokenAndTokenByUseridwithappid:(NSString *)appid withResult:(void (^)(NSString* token))onResult{
    __weak typeof(self) weakSelf = self;
    NSString *mainuserid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *paras = [xindunsdk encryptByUkey:mainuserid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    NSString *log = [NSString stringWithFormat:@"TRUPortalViewController  getTokenWithRefreshTokenAndTokenByUseridwithappid:withResult: 1,vc = %@,appid = %@",self,appid];
    DDLogError(log);
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/token/gen"] withParts:dictt onResult:^(int errorno, id responseBody){
        //        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"refreshtoken error = %d",errorno]];
        if(errorno==0){
            NSString *log = [NSString stringWithFormat:@"TRUPortalViewController  getTokenWithRefreshTokenAndTokenByUseridwithappid:withResult: 2,vc = %@,errorno = %d",self,errorno];
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
                        NSString *log = [NSString stringWithFormat:@"TRUPortalViewController  getTokenWithRefreshTokenAndTokenByUseridwithappid:withResult: 3,vc = %@,errorno = %d",self,errorno];
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

- (void)getTokenWithappid:(NSString *)appid withResult:(void (^)(NSString* token))onResult{
    __weak typeof(self) weakSelf = self;
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token"];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *mainuserid = [TRUUserAPI getUser].userId;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",mainuserid,refreshToken,appid];
    NSArray *ctxx = @[@"userId",mainuserid,@"refreshToken",refreshToken,@"appId",appid];
    NSString *paras = [xindunsdk encryptByUkey:mainuserid ctx:ctxx signdata:sign isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/token/refresh"] withParts:dictt onResult:^(int errorno, id responseBody){
        YCLog(@"errorno = %d",errorno);
        //                        [HAMLogOutputWindow printLog:[NSString stringWithFormat:@"token error = %d",errorno]];
        NSString *log = [NSString stringWithFormat:@"TRUPortalViewController  getTokenWithRefreshTokenAndTokenByUseridwithappid:withResult: 3,vc = %@,errorno = %d",self,errorno];
        if (errorno==0) {
            if (responseBody!=nil) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                if ([dic[@"code"] intValue]==0) {
                    dic = dic[@"resp"];
                    NSString *token = dic[@"access_token"];
                    onResult(token);
                }
            }
        }else if(errorno ==90037){
            [self getTokenWithRefreshTokenAndTokenByUseridwithappid:appid withResult:onResult];
        }else{
            [weakSelf showHudWithText:[NSString stringWithFormat:@"%d错误",errorno]];
            [weakSelf hideHudDelay:2.0];
        }
    }];
}


@end
