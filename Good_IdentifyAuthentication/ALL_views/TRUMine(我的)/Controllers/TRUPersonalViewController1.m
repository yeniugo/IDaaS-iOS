//
//  TruPersonalViewController.m
//  Good_IdentifyAuthentication
//
//  Created by hukai on 2018/10/30.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUPersonalViewController1.h"
#import "TRUPersonalBigCell.h"
#import "TRUPersonalSmaillCell.h"
#import "TRUUserAPI.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"
#import "TRUVoiceInitViewController.h"
#import "TRUPersonalSmailModel.h"
#import "TRUTimeSyncUtil.h"
#import "TRUFingerGesUtil.h"
#import "TRUTokenUtil.h"
#import "TRUCompanyModel.h"
#import "TRUCompanyAPI.h"
#import <AFNetworking.h>
#import "AppDelegate.h"
#import "TRUCompanyAPI.h"
#import "TRUMTDTool.h"
//#import "TrusfortDevId.h"
#import "TRUAPPLogIdentifyController.h"
#import "TRUMailManagerViewController.h"
@interface TRUPersonalViewController1 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;//图标
@property (nonatomic,strong) UIView *topView;
//@property (nonatomic,strong) UIView *bottomView;
@end

@implementation TRUPersonalViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self syncUserInfo];
//    self.view.backgroundColor = DefaultGreenColor;
//    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREENW, SCREENH-kNavBarAndStatusBarHeight);
//    scrollView.showsVerticalScrollIndicator = NO;
//    scrollView.backgroundColor = DefaultGreenColor;
//    scrollView.contentSize = CGSizeMake(SCREENW, SCREENH-kNavBarAndStatusBarHeight);
//    [self.view addSubview:scrollView];
    [self.navigationBar setBackgroundImage:[self ls_imageWithColor:DefaultGreenColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:NavTitleFont]}];
    TRUBaseNavigationController *vc = self.navigationController;
    self.leftItemBtn = [vc changeToWhiteBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftItemBtn];
    self.title = @"我的";
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, SCREENW, 10)];
    self.topView.backgroundColor = DefaultGreenColor;
    [self.view addSubview:self.topView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    self.tableView.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREENW, SCREENH-kNavBarAndStatusBarHeight);
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TRUPersonalBigCell" bundle:nil] forCellReuseIdentifier:@"TRUPersonalBigCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TRUPersonalSmaillCell" bundle:nil] forCellReuseIdentifier:@"TRUPersonalSmaillCell"];
//    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    self.tableView.multipleTouchEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.bounces = YES;
    
    
//    self.imageArray = @[@[@"PersonalFace",@"PersonalVoice"],@[@"PersonalSafe"],@[@"PersonalDevice"],@[@"linuxSSH"],@[@"PersonalAboutUS"]];
//    self.titleArray = @[@[@"人脸信息",@"声纹信息"],@[@"APP安全验证"],@[@"设备管理"],@[@"服务器账号管理"],@[@"关于我们"]];
//    self.commitArray = @[@[@"TRUPersonalDetailsViewController"],@[@"TRUFaceSettingViewController",@"TRUVoiceSettingViewController"],@[@"TRUAPPLogIdentifyController"],@[@"TRUDevicesManagerController"],@[@"TRUSSHViewController"],@[@"TRUAboutUsViewController"]];
    __weak typeof(self) weakSelf = self;
    
    TRUPersonalSmailModel *model1 = [[TRUPersonalSmailModel alloc] init];
    model1.cellType = PersonalSmaillCellNormal;
    model1.leftIcon = @"PersonalFace";
    model1.leftStr = @"人脸信息";
    model1.cellClickBlock = ^{
        NSString *faceinfo = [TRUUserAPI getUser].faceinfo;
        NSString *pushVCStr = @"TRUFaceSettingViewController";
        if (![faceinfo isEqualToString:@"1"]) {
            pushVCStr = @"TRUFaceGuideViewController";
        }
        [weakSelf pushVC:pushVCStr];
    };
    
    TRUPersonalSmailModel *model2 = [[TRUPersonalSmailModel alloc] init];
    model2.cellType = PersonalSmaillCellNormal;
    model2.leftIcon = @"PersonalVoice";
    model2.leftStr = @"声纹信息";
    model2.cellClickBlock = ^{
        NSString *voiceid = [TRUUserAPI getUser].voiceid;
        NSString *pushVCStr = @"TRUVoiceSettingViewController";
        if (!voiceid.length) {
            pushVCStr = @"TRUVoiceInitViewController";
        }
        [weakSelf pushVC:pushVCStr];
    };
    
    TRUPersonalSmailModel *model3 = [[TRUPersonalSmailModel alloc] init];
    model3.cellType = PersonalSmaillCellNormal;
    model3.leftIcon = @"PersonalSafe";
    model3.leftStr = @"安全保护";
//    model3.disVC = @"TRUAPPLogIdentifyController";
    model3.cellClickBlock = ^{
        TRUAPPLogIdentifyController *vc = [[TRUAPPLogIdentifyController alloc] init];
        vc.isFromSetting = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    TRUPersonalSmailModel *model4 = [[TRUPersonalSmailModel alloc] init];
    model4.cellType = PersonalSmaillCellNormal;
    model4.leftIcon = @"PersonalDevice";
    model4.leftStr = @"设备管理";
    model4.disVC = @"TRUDevicesManagerController";
    
    TRUPersonalSmailModel *model5 = [[TRUPersonalSmailModel alloc] init];
    model5.cellType = PersonalSmaillCellNormal;
    model5.leftIcon = @"linuxSSH";
    model5.leftStr = @"运维账号";
    model5.disVC = @"TRUSSHViewController";
    
    TRUPersonalSmailModel *model6 = [[TRUPersonalSmailModel alloc] init];
    model6.cellType = PersonalSmaillCellRightIcon;
    model6.leftIcon = @"timeLeft";
    model6.leftStr = @"时间校准";
    model6.rightIcon = @"timeRight";
    model6.cellClickBlock = ^{
        [weakSelf syncTime];
        [TRUMTDTool uploadDevInfo];
    };
    
    TRUPersonalSmailModel *model7 = [[TRUPersonalSmailModel alloc] init];
    model7.cellType = PersonalSmaillCellRightLBwithIcon;
    model7.leftIcon = @"PersonalAboutUS";
    model7.leftStr = @"检查更新";
    model7.rightStr = [self getAppVersion];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    model7.canUpdate = delegate.hasUpdate;
    model7.cellClickBlock = ^{
        [weakSelf checkUpdataWithPlist];
//        [weakSelf checkVersion];
    };
    
    TRUPersonalSmailModel *model8 = [[TRUPersonalSmailModel alloc] init];
    model8.cellType = PersonalSmaillCellCenterLB;
    model8.CenterStr = @"解除绑定";
    model8.cellClickBlock = ^{
        [weakSelf unbindDevice];
    };
    
    TRUPersonalSmailModel *model9 = [[TRUPersonalSmailModel alloc] init];
    model9.cellType = PersonalSmaillCellNormal;
    model9.leftIcon = @"PersonalEmail";
    model9.leftStr = @"邮箱设备";
    model9.disVC = @"TRUMailManagerViewController";
    
    TRUCompanyModel *model = [TRUCompanyAPI getCompany];
//    model.hasFace = NO;
//    model.hasVoice = YES;
//    if (model.hasFace && model.hasVoice) {
//        self.dataArray = @[@[model1,model2],@[model3],@[model4],@[model9],@[model5],@[model6],@[model7],@[model8]];
//    }else if(model.hasFace && !model.hasVoice){
//        self.dataArray = @[@[model1],@[model3],@[model4],@[model9],@[model5],@[model6],@[model7],@[model8]];
//    }else if(!model.hasFace && model.hasVoice){
//        self.dataArray = @[@[model2],@[model3],@[model4],@[model9],@[model5],@[model6],@[model7],@[model8]];
//    }else{
//        self.dataArray = @[@[model3],@[model4],@[model9],@[model5],@[model6],@[model7],@[model8]];
//    }
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableArray *temp1Array = [NSMutableArray array];
    if (model.hasFace) {
        [temp1Array addObject:model1];
    }
    if (model.hasVoice) {
        [temp1Array addObject:model2];
    }
    if (temp1Array.count) {
        [tempArray addObject:temp1Array];
    }
    [tempArray addObject:[NSArray arrayWithObject:model3]];
    [tempArray addObject:[NSArray arrayWithObject:model4]];
    [tempArray addObject:[NSArray arrayWithObject:model9]];
    [tempArray addObject:[NSArray arrayWithObject:model5]];
    [tempArray addObject:[NSArray arrayWithObject:model6]];
    [tempArray addObject:[NSArray arrayWithObject:model7]];
    [tempArray addObject:[NSArray arrayWithObject:model8]];
    self.dataArray = tempArray;
}

- (void)pushVC:(NSString *)VCName{
    UIViewController *pushVC = [[NSClassFromString(VCName) alloc] init];
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self syncUserInfo];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<0) {
        self.topView.height = -scrollView.contentOffset.y + 10;
//    }
        self.topView.hidden = NO;
        YCLog(@"%f",self.topView.height);
    }else if(scrollView.contentOffset.y>0){
//        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 110);
        self.topView.hidden = YES;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 110;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    YCLog(@"heightForHeaderInSection");
    if (section==0) {
        return 0.01;
    }else{
        if (section == self.dataArray.count) {
            return 40;
        }else{
            return 10;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    YCLog(@"heightForFooterInSection");
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YCLog(@"section = %d",section);
    if (section == 0) {
        return 1;
    }else{
        return [self.dataArray[section-1] count];
    }
//    switch (section) {
//        case 0:
//            return 1;
//            break;
//        case 1:
//            return 2;
//            break;
//        case 2:
//            return 1;
//            break;
//        case 3:
//            return 1;
//            break;
//        case 4:
//        {
//            YCLog(@"-------");
//            return 2;
//        }
//            break;
//        default:
//            return 0;
//            break;
//    }
//    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count + 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *bigCellIdentifier=@"TRUPersonalBigCell";
    static NSString *smallCellIdentifier=@"TRUPersonalSmaillCell";
    UITableViewCell *cell;
//    cell = [[UITableViewCell alloc] init];
//    return cell;
    if (indexPath.section==0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:bigCellIdentifier forIndexPath:indexPath];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell = [self.tableView dequeueReusableCellWithIdentifier:smallCellIdentifier forIndexPath:indexPath];

    }
    if(!cell){
        if (indexPath.section==0) {
            cell=[[TRUPersonalBigCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:bigCellIdentifier];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell=[[TRUPersonalSmaillCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:smallCellIdentifier];
        }
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }else{
        TRUPersonalSmaillCell *smallCell = cell;
        smallCell.cellModel = self.dataArray[indexPath.section-1][indexPath.row];
        
//        if (indexPath.row == [(NSArray *)(self.titleArray[indexPath.section-1]) count]-1) {
//            smallCell.isShowLine = NO;
//        }else{
//            smallCell.isShowLine = YES;
//        }
        return smallCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        return;
    }else{
        TRUPersonalSmailModel *cellModel = self.dataArray[indexPath.section - 1][indexPath.row];
        if (cellModel.disVC.length) {
            [self pushVC:cellModel.disVC];
        }else if(cellModel.cellClickBlock){
            cellModel.cellClickBlock();
        }
    }
}

- (NSString *)getAppVersion{
    NSDictionary *dic = [[NSBundle mainBundle]infoDictionary];
    NSString *version =  dic[@"app-version"];
//    NSString *bundleVersion = dic[@"CFBundleVersion"];
    return version;
}

- (void)syncUserInfo{
//    [self showHudWithText:@"正在同步用户信息..."];
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    //同步用户信息
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
        NSDictionary *dicc = nil;
//        [weakSelf hideHudDelay:0.0];
        if (errorno == 0 && responseBody) {
            dicc = [xindunsdk decodeServerResponse:responseBody];
            if ([dicc[@"code"] intValue] == 0) {
                dicc = dicc[@"resp"];
                //用户信息同步成功
                TRUUserModel *model = [TRUUserModel modelWithDic:dicc];
                model.userId = userid;
                [TRUUserAPI saveUser:model];
            }else if (9019 == errorno){
                [weakSelf deal9019Error];
            }
        }
    }];
    
}

-(void)syncSPinfo{
    NSString *spcode = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL_SPCODE"];
    if (spcode.length>0) {
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *para = [xindunsdk encryptByUkey:spcode];
        NSDictionary *dict = @{@"params" : [NSString stringWithFormat:@"%@",para]};
        [TRUhttpManager getCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/api/ios/cims.html"] withParts:dict onResult:^(int errorno, id responseBody) {
            //            NSLog(@"--%d-->%@",errorno,responseBody);
            if (errorno == 0 && responseBody) {
                NSDictionary *dictionary = responseBody;
                if (1) {
                    NSDictionary *dic = responseBody;
                    TRUCompanyModel *companyModel = [TRUCompanyModel modelWithDic:dic];
                    companyModel.desc = dic[@"description"];
                    [TRUCompanyAPI saveCompany:companyModel];
//                    NSLog(@"-121-->%@",companyModel.desc);
                }
            }
        }];
    }
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

- (void)syncTime{
    [TRUTimeSyncUtil syncTimeWithResult:^(int error) {
        [self hideHudDelay:0.0];
        if (error == 0) {
            [self showHudWithText:@"校准成功"];
            [self hideHudDelay:2.0];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"syncTimeSuccess" object:nil];
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

- (void)checkUpdataWithPlist{
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/javascript",nil];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *spcode = [[NSUserDefaults standardUserDefaults] objectForKey:@"spcode"];
//    NSString *updateUrl = [NSString stringWithFormat:@"%@/api/ios/cims.html?spcode=%@",baseUrl,spcode];
    NSString *updateUrl = [NSString stringWithFormat:@"%@/api/ios/cims.html",baseUrl];
    updateUrl = [NSString stringWithFormat:@"%@/api/ios/cims.html",baseUrl];
    [manager GET:updateUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            YCLog(@"dic = %@",responseObject);
            TRUCompanyModel *model1 = [TRUCompanyAPI getCompany];
            TRUCompanyModel *model2 = [TRUCompanyModel modelWithDic:responseObject];
            [TRUCompanyAPI saveCompany:model2];
            TRUCompanyModel *model3 = [TRUCompanyAPI getCompany];
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            
            if (model1.hasQrCode == model2.hasQrCode && model1.hasProtal == model2.hasProtal && model1.hasFace == model2.hasFace && model1.hasVoice == model2.hasVoice && model1.hasMtd == model2.hasMtd && model1.hasSessionControl == model2.hasSessionControl) {
//                [self showConfrimCancelDialogAlertViewWithTitle:nil msg:@"配置文件已是最新" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:nil cancelBlock:nil];
#if APPChannel == 0
                [weakSelf checkVersionwithresult:^(BOOL update) {
                    if (update) {
                        [weakSelf showConfrimCancelDialogAlertViewWithTitle:nil msg:@"有新版本" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                            NSString *url = @"https://itunes.apple.com/cn/app/id1195763218?mt=8";
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                        } cancelBlock:nil];
                    }else{
                        [weakSelf showConfrimCancelDialogAlertViewWithTitle:nil msg:@"配置文件已是最新" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:nil cancelBlock:nil];
                    }
                }];
#elif APPChannel == 1
                [weakSelf checkUpdataWithPlist1];
#endif
            }else{
                [weakSelf showConfrimCancelDialogAlertViewWithTitle:nil msg:@"配置文件已经更新，重启App" confrimTitle:@"确定" cancelTitle:nil confirmRight:NO confrimBolck:^{
//                    [TrusfortDfsSdk enableSensor:model2.hasMtd];
                    [delegate restUIForApp];
                } cancelBlock:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YCLog(@"error");
    }];
}

#if APPChannel == 1

- (void)checkUpdataWithPlist1{
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/javascript",nil];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSString *updateUrl = [NSString stringWithFormat:@"%@/api/ios/cims.html",baseUrl];
    [manager GET:updateUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *url = responseObject[@"url"];
            if (url.length) {
                if ([url hasPrefix:@"https://"]) {
                    [weakSelf getPlistWithURL:url];
                }else{
                    url = [NSString stringWithFormat:@"%@%@",baseUrl,url];
                    [weakSelf getPlistWithURL:url];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YCLog(@"error");
    }];
}

- (void)getPlistWithURL:(NSString *)url{
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    manager.requestSerializer =[AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *bundleidStr = [weakSelf getPlistVersionWithPlist:responseObject];
        NSString *updateStr = [weakSelf getPlistFouceWithPlist:responseObject];
        if (updateStr.length) {
            if ([updateStr isEqualToString:@"1"]) {
                [weakSelf checkNewAppUpdate:bundleidStr updateURL:url withFouce:YES];
            }else{
                [weakSelf checkNewAppUpdate:bundleidStr updateURL:url withFouce:NO];
            }
        }else{
            [weakSelf checkNewAppUpdate:bundleidStr updateURL:url withFouce:NO];
        }
        YCLog(@"bundleidStr = %@",bundleidStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YCLog(@"error");
    }];
}

- (NSString *)getPlistVersionWithPlist:(id)plist{
    NSMutableDictionary *dataDictionary;
    if ([plist isKindOfClass:[NSData class]]) {
        NSMutableDictionary *result = [NSPropertyListSerialization propertyListWithData:plist options:0 format:NULL error:NULL];
        NSArray *array = result[@"items"];
        NSMutableDictionary *messageDic = [array firstObject];
        NSMutableDictionary *metadata = messageDic[@"metadata"];
        return metadata[@"bundle-version"];
    }
    return nil;

}

- (NSString *)getPlistFouceWithPlist:(id)plist{
    if ([plist isKindOfClass:[NSData class]]) {
        NSMutableDictionary *result = [NSPropertyListSerialization propertyListWithData:plist options:0 format:NULL error:NULL];
        NSArray *array = result[@"items"];
        NSMutableDictionary *messageDic = [array firstObject];
        NSMutableDictionary *metadata = messageDic[@"metadata"];
        return metadata[@"Forced-update"];
    }
    return nil;
}

-(void)checkNewAppUpdate:(NSString *)appInfo updateURL:(NSString *)updateURL withFouce:(BOOL)fouce{
    //版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    CGFloat dispatchTime = 0.1;
    
    
    if ([self updeWithDicString:version andOldString:appInfo]) {
        if (fouce) {
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"新版本 %@ 已发布!",appInfo] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *url = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",updateURL];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                [self presentViewController:alertVC animated:YES completion:nil];
                
            }];
            
            
            [alertVC addAction:confrimAction];//
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dispatchTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentViewController:alertVC animated:YES completion:nil];
            });
        }else{
            UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"新版本 %@ 已发布!",appInfo] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *url = [NSString stringWithFormat:@"itms-services:///?action=download-manifest&url=%@",updateURL];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }];
            
            UIAlertAction *cancelAction =  [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:cancelAction];
            [alertVC addAction:confrimAction];//
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dispatchTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentViewController:alertVC animated:YES completion:nil];
            });
            
        }
    }else{
        YCLog(@"不用更新");
    }
}

#endif

-(void)checkVersionwithresult:(void (^)(BOOL update))onResult{
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
            [self checkAppUpdate:appStoreVersion withresult:onResult];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YCLog(@"获取版本号失败！");
    }];
}



-(void)checkAppUpdate:(NSString *)appInfo withresult:(void (^)(BOOL update))onResult{
    //版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

//    YCLog(@"商店版本：%@ ,当前版本:%@",appInfo,version);
    if ([self updeWithDicString:version andOldString:appInfo]) {
        onResult(YES);
    }else{
        onResult(NO);
    }
}

- (void)unbindDevice{
    NSString *userid = [TRUUserAPI getUser].userId;
    __weak typeof(self) weakSelf = self;
    [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"此操作将会删除您手机内的账户信息，确定要解除绑定？" confrimTitle:@"解除绑定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        [weakSelf showHudWithText:@"正在解除绑定..."];
        NSString *uuid = [xindunsdk getCIMSUUID:userid];
        
        NSArray *deleteDevices = @[uuid];
        NSString *deldevs = nil;
        if (!deleteDevices || deleteDevices.count == 0) {
            deldevs = @"";
        }else{
            deldevs = [deleteDevices componentsJoinedByString:@","];
        }
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSArray *ctx = @[@"del_uuids",deldevs];
        NSString *sign = [NSString stringWithFormat:@"%@",deldevs];
        NSString *params = [xindunsdk encryptByUkey:userid ctx:ctx signdata:sign isDeviceType:NO];
        NSDictionary *paramsDic = @{@"params" : params};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/device/delete"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
            [weakSelf hideHudDelay:0.0];
            if ((errorno == 0) || (-5004 == errorno)) {
                [xindunsdk deactivateUser:[TRUUserAPI getUser].userId];
                [TRUUserAPI deleteUser];
                //清除APP解锁方式
                [TRUFingerGesUtil saveLoginAuthGesType:TRULoginAuthGesTypeNone];
                [TRUFingerGesUtil saveLoginAuthFingerType:TRULoginAuthFingerTypeNone];
                [TRUTokenUtil cleanLocalToken];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password1"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GS_DETAL_KEY"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                id delegate = [UIApplication sharedApplication].delegate;
                if ([delegate respondsToSelector:@selector(changeAvtiveRootVC)]) {
                    [delegate performSelector:@selector(changeAvtiveRootVC) withObject:nil];
                }
#pragma clang diagnostic pop
            }else if (-5004 == errorno){
//                [weakSelf showHudWithText:@"网络错误，请稍后重试"];
//                [weakSelf hideHudDelay:2.0];
            }else if (9008 == errorno){
                [weakSelf deal9008Error];
            }else if (9019 == errorno){
                [weakSelf deal9019Error];
            }else{
                NSString *err = [NSString stringWithFormat:@"其他错误（%d）",errorno];
                [weakSelf showHudWithText:err];
                [weakSelf hideHudDelay:2.0];
            }
        }];
        
    } cancelBlock:^{
        YCLog(@"cancel");
    }];
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
