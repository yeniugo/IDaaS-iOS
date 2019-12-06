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
@interface TRUPortalViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
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
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 168.0/375*SCREENW, SCREEN_WIDTH, SCREEN_HEIGHT - kTabBarHeight - 168.0/375*SCREENW) collectionViewLayout:flow];
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
//    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self refreshData];
//        [self.collectionView.mj_header endRefreshing];
//    }];
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
    [self refreshData];
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
                        }else{
                            UIView *blankview = [[UIView alloc] init];
                            blankview.backgroundColor = [UIColor whiteColor];
                            UIImageView *addBlank = [[UIImageView alloc] init];
                            [blankview addSubview:addBlank];
                            addBlank.image = [UIImage imageNamed:@"portal_banner_blank"];
                            [self.collectionView addSubview:blankview];
                            blankview.frame = CGRectMake(0, 0, SCREENW, SCREENW);
                            addBlank.frame = CGRectMake(SCREENW*0.25, SCREENW*0.25, SCREENW*0.5, SCREENW*0.5);
                            UILabel *showlabel = [[UILabel alloc] init];
                            [blankview addSubview:showlabel];
                            showlabel.textAlignment = NSTextAlignmentCenter;
                            showlabel.text = @"暂无应用";
                            showlabel.frame = CGRectMake(0, SCREENW*0.75, SCREENW, 20);
                        }
                        [weakSelf.collectionView reloadData];
                        
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
    TRUPortalModel *cellmodel = self.dataArray[indexPath.row];
//    NSString *urlStr = cellmodel.schema;
    if([cellmodel.h5Url hasPrefix:@"https://"]||[cellmodel.h5Url hasPrefix:@"http://"]){
        [self getTokenWithRefreshTokenAndTokenByUseridwithappid:cellmodel.appId withResult:^(NSString *token) {
            NSString *urlstr = [NSString stringWithFormat:@"%@%@",cellmodel.h5Url,token];
            TRUAuthorizedWebViewController *webview = [[TRUAuthorizedWebViewController alloc] init];
            webview.urlStr = urlstr;
            [self.navigationController pushViewController:webview animated:YES];
        }];
    }else{
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
                            [self showHudWithText:@"下载地址错误"];
                            [self hideHudDelay:2];
                        }
                    }];
                }
            }];
        }else{
            BOOL canopen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            if (!canopen) {
                canopen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadStr]];
                if (!canopen) {
                    [self showHudWithText:@"下载地址错误"];
                    [self hideHudDelay:2];
                }
            }
        }
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

@end
