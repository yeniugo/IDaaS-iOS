//
//  TRULoginScanViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/11.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRULoginScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TRUScanView.h"
#import "xindunsdk.h"
#import "TRUAddPersonalInfoViewController.h"
#import "TRUUserAPI.h"
#import "TRUTimeSyncUtil.h"
#import "UINavigationBar+BackgroundColor.h"
#import "TRUBingUserController.h"
#import "AFNetworking.h"

#import "TRUCompanyAPI.h"
#import "TRUCompanyModel.h"
#import "TRUBingUserController.h"
#import "TRUhttpManager.h"

@interface TRULoginScanViewController ()

@property (nonatomic, weak) UIView *maskView;

@property (nonatomic, strong) TRUScanView *scanView;

@end

@implementation TRULoginScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUPMaskView];
    [self setUPScanView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
    self.navigationBar.hidden = YES;
    if ([self checckVideoAuthorization]){
        [self.scanView beginScanning];
        [self.scanView resumeAnimation];
    }else{
        [self showConfrimCancelDialogViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } cancelBlock:nil];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.scanView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
- (void)cancelBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setUPMaskView{
    UIView *maskView = [[UIView alloc] init];
    [self.view addSubview:self.maskView = maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.edges.equalTo(self.view);
    }];
}
- (void)setUPScanView{
    
    __weak typeof(self) weakSelf = self;
    
    self.scanView = [[TRUScanView alloc] initWithScanLine];
    [self.scanView setScanResultBlock:^(NSString *result) {
        YCLog(@"--11111-->%@",result);
        //判断扫描的二维码是激活，还是获取多租户信息
        if ([result hasPrefix:@"http://"]||[result hasPrefix:@"https://"]) {
            if ([result containsString:@"download"]) {
                
            }else{
                [weakSelf restartScan];
                return;
            }
        }else{
            [weakSelf restartScan];
            return;
        }
        NSArray *arr = [result componentsSeparatedByString:@"download"];
        
        NSString *currentCims;
        //兼容主线和永辉
        if (arr.count>0) {
            currentCims = arr[0];
        }
        
        NSString *cimsStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
        NSString *pushID = [stdDefaults objectForKey:@"TRUPUSHID"];
        
        if ([currentCims isEqualToString:cimsStr]) {
            
            // http://ip:port/app/download?op=active&authcode=263439&userno=liurunxin@trusfort.com
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSArray *arr = [result componentsSeparatedByString:@"?"];
            NSString *str = [arr lastObject];
            arr = [str componentsSeparatedByString:@"&"];
            for (NSString *str in arr) {
                NSArray *tmp = [str componentsSeparatedByString:@"="];
                NSString *key = [tmp firstObject];
                NSArray *value = [tmp lastObject];
                if (key && value) {
                    dic[key] = value;
                }
            }
            
            NSString *userNo = dic[@"userno"];
            NSString *op = dic[@"op"];
            NSString *authcode = dic[@"authcode"];
            
            if ([op isEqualToString:@"active"]) {
                [weakSelf showActivityWithText:@"正在激活..."];
                if (userNo && userNo.length > 0) {
                    [weakSelf activeWith:userNo andtype:@"email" authCode:authcode pushid:pushID];
                    
                }else{//如果userno不存在 二维码来源不对
                    
                    [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"无效二维码，请确认二维码来源！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                        [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
                    } cancelBlock:nil];
                }
                
            }else if ([op isEqualToString:@"login"]){
                [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"该终端还未激活，请尝试自注册激活或联系管理员" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        if (weakSelf.backBlock) {
                            weakSelf.backBlock(YES);
                        }
                    }];
                } cancelBlock:nil];
                
            }else{//不是login 也不是active 无效二维码，请确认二维码来源！
                
                [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"无效二维码，请确认二维码来源！" confrimTitle:@"确认" cancelTitle:nil confirmRight:YES confrimBolck:^{
                    [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
                } cancelBlock:nil];
                
            }
        }else{//获取多租户信息后的逻辑
            //1.获取多租户信息
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSArray *arr = [result componentsSeparatedByString:@"?"];
            NSString *str = [arr lastObject];
            arr = [str componentsSeparatedByString:@"&"];
            for (NSString *str in arr) {
                NSArray *tmp = [str componentsSeparatedByString:@"="];
                NSString *key = [tmp firstObject];
                NSArray *value = [tmp lastObject];
                if (key && value) {
                    dic[key] = value;
                }
            }
            NSString *userNo = dic[@"userno"];
            NSString *op = dic[@"op"];
            NSString *authcode = dic[@"authcode"];
            NSString *spcode = dic[@"spcode"];
            if (spcode.length>0){//
//                [xindunsdk initEnv:@"com.example.demo" url:currentCims];
                [[NSUserDefaults standardUserDefaults] setObject:spcode forKey:@"spcode"];
                [xindunsdk initCIMSEnv:@"com.example.demo" serviceUrl:currentCims devfpUrl:currentCims];
//                [xindunsdk initEnv:@"com.example.demo" algoType:XDAlgoTypeOpenSSL baseUrl:@"https://dfs.trusfort.com/xdid/mapi"];
                NSString *para = [xindunsdk encryptByUkey:spcode];
                NSDictionary *dic = @{@"params" : [NSString stringWithFormat:@"%@",para]};
                [TRUhttpManager getCIMSRequestWithUrl:[currentCims stringByAppendingString:@"api/ios/cims.html"] withParts:dic onResult:^(int errorno, id responseBody) {
                    [weakSelf hideHudDelay:0.0];
                    YCLog(@"--%d-->%@",errorno,responseBody);
                    if (errorno == 0 && responseBody) {
                        NSDictionary *dict = responseBody;
                        YCLog(@"--->%@",dict);
                        if (1) {
                            NSDictionary *dicc = responseBody;
                            TRUCompanyModel *companyModel = [TRUCompanyModel modelWithDic:dicc];
                            companyModel.desc = dic[@"description"];
                            [TRUCompanyAPI saveCompany:companyModel];
                            if (companyModel.cims_server_url.length>0) {
                                if((op == nil || op.length == 0)&&(authcode == nil || authcode.length == 0)){
                                    [weakSelf showHudWithText:@"切换服务器成功"];
                                    [weakSelf hideHudDelay:2.0];
                                    [[NSUserDefaults standardUserDefaults] setObject:spcode forKey:@"CIMSURL_SPCODE"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    //切换icon
                                    [weakSelf changeIconWithName:companyModel.icon_url];
                                    //切换服务地址 http://192.168.1.115:8000/cims
//                                    bool res = [xindunsdk initEnv:@"com.example.demo" url:companyModel.cims_server_url];
                                    bool res = [xindunsdk initCIMSEnv:@"com.example.demo" serviceUrl:companyModel.cims_server_url devfpUrl:companyModel.cims_server_url];
//                                    [xindunsdk initEnv:@"com.example.demo" algoType:XDAlgoTypeOpenSSL baseUrl:@"https://dfs.trusfort.com/xdid/mapi"];
//                                    YCLog(@"initXdSDK %d",res);
                                    [[NSUserDefaults standardUserDefaults] setObject:companyModel.cims_server_url forKey:@"CIMSURL"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                                        if (weakSelf.backBlock) {
                                            weakSelf.backBlock(YES);
                                        }
                                    }];
                                    return;
                                }
                                [weakSelf showHudWithText:@"切换用户成功"];
                                [weakSelf hideHudDelay:2.0];
                                [[NSUserDefaults standardUserDefaults] setObject:spcode forKey:@"CIMSURL_SPCODE"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                //切换icon
                                [weakSelf changeIconWithName:companyModel.icon_url];
                                //切换服务地址 http://192.168.1.115:8000/cims
//                                bool res = [xindunsdk initEnv:@"com.example.demo" url:companyModel.cims_server_url];
                                bool res = [xindunsdk initCIMSEnv:@"com.example.demo" serviceUrl:companyModel.cims_server_url devfpUrl:companyModel.cims_server_url];
//                                [xindunsdk initEnv:@"com.example.demo" algoType:XDAlgoTypeOpenSSL baseUrl:@"https://dfs.trusfort.com/xdid/mapi"];
//                                YCLog(@"initXdSDK %d",res);
                                [[NSUserDefaults standardUserDefaults] setObject:companyModel.cims_server_url forKey:@"CIMSURL"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                if ([op isEqualToString:@"active"]) {//激活
                                    if (userNo && userNo.length > 0) {
                                        [weakSelf activeWith:userNo andtype:@"email" authCode:authcode pushid:pushID];
                                    }
                                }else if ([op isEqualToString:@"login"]){
                                    
                                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                                        if (weakSelf.backBlock) {
                                            weakSelf.backBlock(YES);
                                        }
                                    }];
                                    
                                }else{//不是login 也不是active 无效二维码，请确认二维码来源！
                                    [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"无效二维码，请确认二维码来源！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                                        [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
                                    } cancelBlock:nil];
                                    
                                }
                                
                                
                            }else{//服务器地址为空
                                [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"服务地址有误" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                                    [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
                                } cancelBlock:nil];
                            }
                        }
                    }else if (-5004 == errorno){
                        [weakSelf showHudWithText:@"网络错误，请稍后重试"];
                        [weakSelf hideHudDelay:2.0];
                        [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
                    }else if (9019 == errorno){
                        [weakSelf dele9019ErrorWithBlock:^{
                            [weakSelf restartScan];
                        }];;
                    }else if (9026 == errorno){
                        [weakSelf deal9026ErrorWithBlock:^{
                            [weakSelf restartScan];
                        }];
                    }else{
                        [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"该二维码已失效，请尝试自注册或联系管理员" confrimTitle:@"自注册" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                            [weakSelf pinBtnClick];
                        } cancelBlock:^{
                            [weakSelf dismissViewControllerAnimated:YES completion:nil];
                        }];
                    }
                }];

            }else{
                [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"无效二维码，请确认二维码来源！" confrimTitle:@"确认" cancelTitle:nil confirmRight:YES confrimBolck:^{
                    [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
                } cancelBlock:nil];
            }
        }
    }];
    
    [self.maskView insertSubview:self.scanView atIndex:0];
    [self.scanView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.bottom.equalTo(self.maskView);
    }];
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont systemFontOfSize:14.0];
    tipLabel.text = @"放入框内，自动扫描";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor whiteColor];
    
    
    [self.maskView addSubview:tipLabel];
    [tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.maskView);
        make.top.equalTo(self.scanView.scanView.mas_bottom).offset(12.0 * PointHeightRatio6);
    }];

//    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:@"二维码绑定不成功请手动绑定邮箱"];
//    NSRange r1= [attrTitle.string rangeOfString:@"二维码绑定不成功"];
//    NSRange r2 = [attrTitle.string rangeOfString:@"请手动绑定邮箱"];
//    [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:r1];
//    [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"0x2669E7"] range:r2];
//
//    UIButton *pinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    pinBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [pinBtn setAttributedTitle:attrTitle forState:UIControlStateNormal];
//    [pinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//    [pinBtn addTarget:self action:@selector(pinBtnClick) forControlEvents:UIControlEventTouchUpInside];
////    [self.maskView addSubview:pinBtn];
//    [pinBtn mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.equalTo(self.maskView).offset(20.0);
//        make.right.equalTo(self.maskView).offset(-20.0);
//        make.top.equalTo(tipLabel.mas_bottom).offset(132 * PointHeightRatio6);
//    }];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.alpha = 0.6;
    [back setImage:[UIImage imageNamed:@"pushback"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    back.backgroundColor = [UIColor blackColor];
    back.layer.cornerRadius = 20.0;
    back.clipsToBounds = YES;
    [self.maskView addSubview:back];
    
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40.0);
        make.left.equalTo(self.maskView).offset(20.0);
        make.top.equalTo(self.maskView).offset(30.0);
    }];
}

- (BOOL)checkPersonInfoVC:(TRUUserModel *)model{
    NSString *activeStr = [TRUCompanyAPI getCompany].activation_mode;
    if (activeStr.length == 3) {
        if ([activeStr containsString:@","]) {
            NSArray *arr = [activeStr componentsSeparatedByString:@","];
            NSString *modestr = arr[1];
            if ([modestr isEqualToString:@"1"]) {
                if (model.email.length >0) {
                    return NO;
                }else{
                    return YES;
                }
            }else if ([modestr isEqualToString:@"2"]){
                if (model.phone.length >0) {
                    return NO;
                }else{
                    return YES;
                }
            }else if ([modestr isEqualToString:@"0"]){
                return NO;
            }else{
                return NO;
//                if (model.employeenum.length >0) {
//                    return NO;
//                }else{
//                    return YES;
//                }
            }
        }else{
            return NO;
        }
        
    }else if (activeStr.length == 1){
        return NO;
    }else{
        return NO;
    }
}


#pragma mark 按钮事件
- (void)pinBtnClick{
    [self.scanView stopAnimation];
    TRUBingUserController *pinVC = [[TRUBingUserController alloc] init];
    [self.navigationController pushViewController:pinVC animated:YES];
}
- (void)restartScan{
    [self.scanView beginScanning];
    [self.scanView resumeAnimation];
}
- (BOOL)checckVideoAuthorization{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return authStatus == AVAuthorizationStatusAuthorized;
}

-(void)changeIconWithName:(NSString *)Iconname{
    YCLog(@"-Iconname-%@",Iconname);
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.3) {
        if ([Iconname isEqualToString:@"湖南高招"]) {
            if ([UIApplication sharedApplication].supportsAlternateIcons) {
                YCLog(@"你可以更换icon");
                [[UIApplication sharedApplication] setAlternateIconName:@"huonangaozhao" completionHandler:^(NSError * _Nullable error) {
                    if (!error) {
                        YCLog(@"成功更换为%@",@"huonangaozhao");
                    }else{
                        YCLog(@"error:%@",error);
                    }
                }];
            }else{
                YCLog(@"非常抱歉，你不能更换icon");
            }
        }else if ([Iconname isEqualToString:@"成都银行"]){//成都银行
            if ([UIApplication sharedApplication].supportsAlternateIcons) {
                YCLog(@"你可以更换icon");
                [[UIApplication sharedApplication] setAlternateIconName:@"chengduyinhang" completionHandler:^(NSError * _Nullable error) {
                    if (!error) {
                        YCLog(@"成功更换为%@",@"chengduyinhang");
                    }else{
                        YCLog(@"error:%@",error);
                    }
                }];
            }else{
                YCLog(@"非常抱歉，你不能更换icon");
            }
        }else{
            [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
                if (!error) {
                    YCLog(@"成功还原图标");
                }else{
                    YCLog(@"error:%@",error);
                }
            }];
        }
    }else{
        //低版本不支持
        YCLog(@"error:%@",@"低版本不支持");
    }
}

-(void)activeWith:(NSString *)userno andtype:(NSString *)type authCode:(NSString *)authCode pushid:(NSString *)pushid{
    __weak typeof(self) weakSelf = self;
    NSString *singStr = [NSString stringWithFormat:@",\"userno\":\"%s\",\"pushid\":\"%s\",\"type\":\"%s\",\"authcode\":\"%s\"", [userno UTF8String],[pushid UTF8String], [type UTF8String],[authCode UTF8String]];
    NSString *para = [xindunsdk encryptBySkey:userno ctx:singStr isType:YES];
    NSDictionary *paramsDic = @{@"params" : para};
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/active"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
        [weakSelf hideHudDelay:0.0];
        NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
        if (errorno == 0) {
            NSString *userId = nil;
            int err = [xindunsdk privateVerifyCIMSInitForUserNo:userno response:dic[@"resp"] userId:&userId];
            //            NSLog(@"---11111111111--->%d---->%@",err,userId);
            if (err == 0) {
                //同步用户信息
                NSString *paras = [xindunsdk encryptByUkey:userId ctx:nil signdata:nil isDeviceType:NO];
                NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
                [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
                    [weakSelf hideHudDelay:0.0];
                    NSDictionary *dicc = nil;
                    if (errorno == 0 && responseBody) {
                        dicc = [xindunsdk decodeServerResponse:responseBody];
                        if ([dicc[@"code"] intValue] == 0) {
                            dicc = dicc[@"resp"];
                            //                            NSLog(@"-dic->%@",dicc);
                            //用户信息同步成功
                            TRUUserModel *model = [TRUUserModel modelWithDic:dicc];
                            model.userId = userId;
                            [TRUUserAPI saveUser:model];
                            if (0) {//yes 表示需要完善信息
                                TRUAddPersonalInfoViewController *infoVC = [[TRUAddPersonalInfoViewController alloc] init];
                                infoVC.userNo = userno;
                                infoVC.email = model.email;
                                infoVC.isScan = YES;
                                infoVC.backBlocked=^(){
                                    [self cancelBtnClick];
                                };
                                [self.navigationController pushViewController:infoVC animated:YES];
                            }else{//同步信息成功，信息完整，跳转页面
#pragma clang diagnostic ignored "-Wundeclared-selector"
                                YCLog(@"跳转");
                                id delegate = [UIApplication sharedApplication].delegate;
                                if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                                    [delegate performSelector:@selector(changeRootVC)];
                                }
                            }
                        }
                    }
                }];
            }
        }else if (-5004 == errorno){
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
            
        }else if (9019 == errorno){
            [weakSelf dele9019ErrorWithBlock:^{
                [weakSelf restartScan];
            }];;
        }else if (9026 == errorno){
            [weakSelf deal9026ErrorWithBlock:^{
                [weakSelf restartScan];
            }];
        }else{
            [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"该二维码已失效，请尝试联系管理员！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    if (weakSelf.backBlock) {
                        weakSelf.backBlock(NO);
                    }
                }];
                
            } cancelBlock:nil];
        }
    }];
    
    
}

@end
