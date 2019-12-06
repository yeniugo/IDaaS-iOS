//
//  TRUApplicationViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUApplicationViewController.h"
#import "TRUApplicationTopView.h"
#import "TRUApplictionCell.h"
#import "TRULicenseAgreementViewController.h"
#import "xindunsdk.h"
#import "TRUAuthModel.h"
#import "TRUPushAuthModel.h"
#import "TRUUserAPI.h"
#import "TRUFingerGesUtil.h"
#import "TRUAuthorizedWebViewController.h"
#import "TRUPushViewController.h"
#import "TRUPushingViewController.h"
#import "TRUAPPLogIdentifyController.h"
#import "MJRefresh.h"
#import "TRUActiveAppViewController.h"
#import "TRUFaceVerifyViewController.h"
#import <Bugly/Bugly.h>

#import <YYWebImage.h>
#import "TRUCompanyAPI.h"
#import "TRUhttpManager.h"

static CGFloat KcollectionViewY = 315;

@interface TRUApplicationViewController ()<UIScrollViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UIScrollView *mainScrollview;
@property (nonatomic, strong)TRUApplicationTopView *topView;
@property (nonatomic, strong)UISegmentedControl *segmentControl;

@property (nonatomic, strong)UICollectionView *myCollectionView;
@property (nonatomic, strong)NSMutableArray *DataArr;
@property (nonatomic, strong)NSMutableArray *notActiveDataArr;
@property (nonatomic, strong)NSMutableArray *pushModelList;
@property (nonatomic, weak) NSTimer *pushTimer;

@end

@implementation TRUApplicationViewController
{
    UIView *topbgview;
    NSInteger ii;
    float collY;
    float flagY;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    
    self.scanBtn.hidden = NO;
    
    if (SCREENH == 568) {//iphone5,5s,5c,SE
        flagY = 30;
    }else if (SCREENH == 667){//iphone6,6s,7,7s,8
        flagY = 75;
    }else if (SCREENH == 736){//iphone6p,7p,8p
        flagY = 105;
    }else if (SCREENH == 812){//iphoneX
        flagY = 175;
    }
    
    
    //检查用户是否设置解锁方式
    [self checkLoginAuth];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.scanBtn.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ii = 0;
    collY = 0.0;
    [self customUI];
    
    /**
     * 请求应用
     * 0 表示常用应用
     * 1 表示书签应用
     */
    [self requestDataWithInt:0];
    //请求今日验证数量
    [self getDateCount];
    //请求当前请求数量
    [self getPushInfo];
    
    //设备管理数量
    [self loadDeviceList];
    //检查是否有第三方认证
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"OAuthVerify"];
    if (str.length > 0 && [str isEqualToString:@"yes"]) {//第三方认证
        [self pushThirdVerify];
    }
    //同步更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncAuthData) name:kRefresh3DataNotification object:nil];
    //推送认证
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationAction:) name:@"pushTrusfort" object:nil];
    
    
}
#pragma mark - 弹出第三方认证
-(void)pushThirdVerify{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"WAKEUPTOKENKEY"];
    NSString *userNo = [TRUUserAPI getUser].userId;
    TRUPushingViewController *vc = [[TRUPushingViewController alloc] init];
    vc.userNo = userNo;
    vc.token = token;
    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 请求常用应用&书签应用
-(void)requestDataWithInt:(NSInteger)flag{
    if (flag == 1) {
        return;
    }
    if (!_DataArr) {
        _DataArr = [[NSMutableArray alloc] init];
    }
    if (!_notActiveDataArr) {
        _notActiveDataArr = [[NSMutableArray alloc] init];
    }
    NSString *userid = [TRUUserAPI getUser].userId;
    __weak typeof(self) weakSelf = self;
    if (userid) {
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
        NSDictionary *paramsDic = @{@"params" : paras};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getappinfo"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
            [weakSelf hideHudDelay:0.0];
            if (responseBody && errorno == 0) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                int code = [dic[@"code"] intValue];
                if (code == 0) {
                    id result = dic[@"resp"];
                    if ([result isKindOfClass:[NSArray class]]) {
                        [weakSelf.DataArr removeAllObjects];
                        NSArray *arr = (NSArray *)result;
                        for (NSDictionary *dic in arr) {
                            TRUAuthModel *model = [TRUAuthModel modelWithDic:dic];
                            [weakSelf.DataArr addObject:model];
                        }
                        [weakSelf.myCollectionView reloadData];
                    }
                }
            }else if (-5004 == errorno){
                [weakSelf showHudWithText:@"网络错误，稍后请重试"];
                [weakSelf hideHudDelay:2.0];
                
            }else if (9008 == errorno){
                [weakSelf deal9008Error];
            }else if (9019 == errorno){
                [weakSelf.DataArr removeAllObjects];
                [weakSelf.notActiveDataArr removeAllObjects];
                [weakSelf deal9019Error];
            }else{
                NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];//[NSString stringWithFormat:@"其他错误 %d", error];
                [weakSelf showHudWithText:err];
                [weakSelf hideHudDelay:2.0];
            }
        }];

    }
    
}



#pragma mark - 获取验证次数

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
        NSDictionary *paramsDic = @{@"params" : paras};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/getdatecount"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
            [weakSelf hideHudDelay:0.0];
            if (responseBody && errorno == 0) {
                NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
                int code = [dic[@"code"] intValue];
                if (code == 0) {
                    NSArray *arr = dic[@"resp"];
                    for (NSDictionary *dic in arr) {
                        _topView.identifyLabel.text = [NSString stringWithFormat:@"%ld",[dic[@"verifycounts"] integerValue]];
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
            if (responseBody && errorno == 0) {
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
                        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
                        _topView.requestImgview.hidden = NO;
                        _topView.requestLabel.text = [NSString stringWithFormat:@"%ld",(long)badgeNumber];
                    }
                }
            }else if (errorno == 0 && !responseBody){
                _topView.requestImgview.hidden = YES;
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
#pragma mark 网络请求
- (void)loadDeviceList{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    if (userid) {
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:YES];
        NSDictionary *paramsDic = @{@"params" : paras};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/device/getlist"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
            [weakSelf hideHudDelay:0.0];
            NSDictionary *dic = nil;
            if (errorno == 0 && ![responseBody isKindOfClass:[NSNull class]]) {
                dic = [xindunsdk decodeServerResponse:responseBody];
                if ([dic[@"code"] intValue] == 0) {
                    dic = dic[@"resp"];
                    id deviceinfos = [dic objectForKey:@"deviceinfos"];
                    if ([deviceinfos isKindOfClass:[NSArray class]]) {
                        NSArray *arr = (NSArray *)deviceinfos;
                        _topView.deviceLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)arr.count];
                    }
                }
            }else if(-5004 == errorno){
                NSString *err = @"网络问题，请稍后重试";
                [weakSelf showHudWithText:err];
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
                    [Bugly reportError:myerror];
                }
                NSString *err = [NSString stringWithFormat:@"获取设备列表失败（%d）",errorno];
                [weakSelf showHudWithText:err];
                [weakSelf hideHudDelay:2.0];
            }
        }];
    }
}

#pragma mark - 同步今日验证 当前请求数量
-(void)syncAuthData{
    [self loadDeviceList];
    [self getPushInfo];
    [self getDateCount];
    [self requestDataWithInt:ii];
    [_mainScrollview.mj_header endRefreshing];
}
-(void)customUI{
    //获取当前UIWindow 并添加一个视图
    UIApplication *ap = [UIApplication sharedApplication];
    [ap.keyWindow addSubview:self.scanBtn];
    
    _mainScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH - 54)];
    [self.view addSubview:_mainScrollview];
    _mainScrollview.backgroundColor = RGBCOLOR(234, 235, 236);
    _mainScrollview.showsVerticalScrollIndicator = NO;
    _mainScrollview.showsHorizontalScrollIndicator = NO;
    //    _mainScrollview.bounces = NO;
    _mainScrollview.delegate = self;
    _mainScrollview.contentSize = CGSizeMake(0, SCREENH +74);
    
    //下拉刷新
    _mainScrollview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(syncAuthData)];
    
    //顶部菜单视图
    _topView = [[TRUApplicationTopView alloc] initWithFrame:CGRectMake(0, -20, SCREENW, 240)];
    [_mainScrollview addSubview:_topView];
    _topView.MainVc = self;
    
    NSString *imgstr = [TRUCompanyAPI getCompany].logo_url;
    [_topView.BigImageview yy_setImageWithURL:[NSURL URLWithString:imgstr] placeholder:[UIImage imageNamed:@"circular"]];
    __weak typeof(self) weakSelf = self;
    _topView.detailPushVC =^(){
        [weakSelf detailPush];
    };

    //main 菜单视图
    _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"常用应用",@"书签应用"]];
    [_mainScrollview addSubview:_segmentControl];
    _segmentControl.tintColor = RGBCOLOR(32, 144, 54);
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.frame = CGRectMake(SCREENW/2-120, 235, 240, 35);
    [_segmentControl addTarget:self action:@selector(changeviewWithSegment:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *colorAttributes = [NSDictionary dictionaryWithObject:[UIColor lightGrayColor] forKey:NSForegroundColorAttributeName];
    [_segmentControl setTitleTextAttributes:colorAttributes forState:UIControlStateNormal];
    
    if (kDevice_Is_iPhoneX) {
        topbgview = [[UIView alloc] initWithFrame:CGRectMake(0, -44, SCREENW, 24)];
        topbgview.backgroundColor = DefaultColor;
        [_mainScrollview addSubview:topbgview];
        _topView.frame = CGRectMake(0, -20, SCREENW, 240);
        _segmentControl.frame = CGRectMake(SCREENW/2-120, 235, 240, 35);
        _mainScrollview.contentSize = CGSizeMake(0, SCREENH + 34);
    }
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KcollectionViewY, SCREENW, SCREENW/3.f *3 - 2 + flagY) collectionViewLayout:flowlayout];
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    _myCollectionView.showsVerticalScrollIndicator = NO;
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.bounces = YES;
    [self.view addSubview:_myCollectionView];
    _myCollectionView.backgroundColor = RGBCOLOR(221, 223, 224);
    [_myCollectionView registerNib:[UINib nibWithNibName:@"TRUApplictionCell" bundle:nil] forCellWithReuseIdentifier:@"TRUApplictionCell"];
    _myCollectionView.decelerationRate = 0.01;
    _mainScrollview.decelerationRate = 0.01;
    
    //用户协议
//    UILabel * txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW/2.f - 120, 330 + SCREENW/3.f *3, 165, 20)];
//    
//    txtLabel.text = @"善认·一站式移动身份管理";
//    txtLabel.font = [UIFont systemFontOfSize:14];
//    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    agreementBtn.frame = CGRectMake(SCREENW/2.f +35, 330 + SCREENW/3.f *3, 90, 20);
//    [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
//    [agreementBtn setTitleColor:RGBCOLOR(32, 144, 54) forState:UIControlStateNormal];
//    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [agreementBtn addTarget:self action:@selector(lookUserAgreement) forControlEvents:UIControlEventTouchUpInside];
//    if (SCREENW > 320) {
//        [_mainScrollview addSubview:txtLabel];
//        [_mainScrollview addSubview:agreementBtn];
//    }
}

#pragma mark - UICollectionViewDataSource+UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _DataArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TRUApplictionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TRUApplictionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.authModel = _DataArr[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //
    
    TRUAuthModel *model = self.DataArr[indexPath.row];
    if (model.appid == nil || model.appid.length == 0) return;
    NSString *userid = [TRUUserAPI getUser].userId;
    if (userid == nil || userid.length == 0) return;
    if (model.isactive) {
        __weak typeof(self) weakSelf = self;
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:YES];
        NSDictionary *paramsDic = @{@"params" : paras};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/appsso/login2target4app"] withParts:paramsDic onResult:^(int error, id response) {
            [weakSelf hideHudDelay:0.0];
            if (error == 0) {

                NSString *ticket = @"";
                NSDictionary *dic = [xindunsdk getEncryptedTransactionInfo:userid transactionInfo:response];
                if ([[dic[@"status"] stringValue] isEqualToString:@"0"]) {
                    ticket = dic[@"encdata"];
                }
                NSString *cimsurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
                NSString *ServerUrl;
                if (cimsurl.length>0) {
                    ServerUrl = cimsurl;
                }else{
                    ServerUrl = kServerUrl;
                }

                NSString *urlstr = [ServerUrl stringByAppendingString:@"/mapi/appsso/login2target4app?"];
                NSString *query = [NSString stringWithFormat:@"appid=%@&ticket=%@", model.appid, ticket];
                NSString *url = [urlstr stringByAppendingString:query];
                TRUAuthorizedWebViewController *webVC = [[TRUAuthorizedWebViewController alloc] init];
                webVC.title = model.appname;
                webVC.urlStr = url;
                [weakSelf.navigationController pushViewController:webVC animated:YES];

            }else if (9019 == error){
                [weakSelf deal9019Error];
            }else if (-5004 == error){
                [weakSelf showHudWithText:@"网络错误，稍后请重试"];
                [weakSelf hideHudDelay:2.0];
            }
        }];

    }else{//没有激活 需新添加应用
        //跳转到页面
        TRUActiveAppViewController *avtiveVC = [[TRUActiveAppViewController alloc] init];
        avtiveVC.authModel = model;
        [self.navigationController pushViewController:avtiveVC animated:YES];
    }
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 0, 0, 1);
}
//定义每个UICollectionViewCell 的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENW/3.f-1, SCREENW/3.f-2);
}
//列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1/MAXFLOAT;
}

//行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

#pragma mark -UISegmentedControl
-(void)changeviewWithSegment:(UISegmentedControl *)segment{
    
    int Index = (int)segment.selectedSegmentIndex;
    
    switch (Index) {
            
        case 0:
            
        {
            ii = 0;
            [self requestDataWithInt:0];
            [_myCollectionView reloadData];
        }
            
            break;
            
        case 1:
            
        {
            ii = 1;
            [_DataArr removeAllObjects];
            [_myCollectionView reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 用户协议 UserAgreement
-(void)lookUserAgreement{
    TRULicenseAgreementViewController *lisenceVC = [[TRULicenseAgreementViewController alloc] init];
    [self.navigationController pushViewController:lisenceVC animated:YES];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
//        YCLog(@"--2222-->%f",_mainScrollview.contentOffset.y);
        if (_mainScrollview.contentOffset.y<0) {
            collY =0;
        }else{
            collY = _mainScrollview.contentOffset.y;
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    YCLog(@"--333-->%f",_mainScrollview.contentOffset.y);
    if (_mainScrollview.contentOffset.y<0) {
        collY =0;
    }else{
        collY = _mainScrollview.contentOffset.y;
    }
    
}
// 滑动时多次调用，offset值改变即滑动过程中，便会调用该代理函数
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scroll_y = _mainScrollview.contentOffset.y;
    CGFloat collection_y = _myCollectionView.contentOffset.y;

//    YCLog(@"-collection_y-->%f",collection_y);
//    YCLog(@"-scroll_y-->%f",scroll_y);
    //处理iPhone X下拉刷新被挡住问题
    if (kDevice_Is_iPhoneX) {
        if (scroll_y <=-54) {
            topbgview.hidden = YES;
        }else{
            topbgview.hidden = NO;
        }
    }
    if (kDevice_Is_iPhoneX) {
        CGFloat y = 20 + scroll_y;
        [self collectionViewFrameChange:y];
        if (scroll_y>0) {
            [_topView bigViewsHidden:scroll_y/117.0];
        }
        if (collection_y <0 && scroll_y >-15) {//滑动到顶部，继续滑动是拉下S
            _mainScrollview.contentOffset = CGPointMake(0, scroll_y + collection_y);
        }
        if (collection_y>0 && scroll_y<117) {
            _mainScrollview.contentOffset = CGPointMake(0, collY + collection_y);
            _myCollectionView.contentSize = CGSizeMake(0, 0);
        }
    }else{
        CGFloat y = 20 + scroll_y;
        [self collectionViewFrameChange:y];
        
        if (scroll_y>0) {
            [_topView bigViewsHidden:scroll_y/128.0];
        }
        if (collection_y <0 && scroll_y >-15) {//滑动到顶部，继续滑动是拉下S
            _mainScrollview.contentOffset = CGPointMake(0, scroll_y + collection_y);
        }
        //
        if (collection_y>0 && scroll_y<127) {
            _mainScrollview.contentOffset = CGPointMake(0, collY + collection_y);
            _myCollectionView.contentSize = CGSizeMake(0, 0.5);
            
        }
    }
    
}
//collectionView跟随移动
-(void)collectionViewFrameChange:(CGFloat)y{
    _myCollectionView.frame = CGRectMake(0, KcollectionViewY-y, SCREENW, SCREENW/3.f *3 - 2 + flagY);
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
    NSDate *dta ;
    NSDate *dtb ;
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
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

//- (void)getNotificationAction:(NSNotification *)notification{
//    NSString *tokenstr = [notification object];
////    YCLog(@"--->%@",tokenstr);
//    TRUPushViewController *authVC = [[TRUPushViewController alloc] init];
//    authVC.userNo = [TRUUserAPI getUser].userId;
//    authVC.token = tokenstr;
//    TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:authVC];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
//
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefresh3DataNotification object:nil];
}
@end
