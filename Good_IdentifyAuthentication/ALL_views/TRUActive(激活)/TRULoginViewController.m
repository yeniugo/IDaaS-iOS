//
//  TRULoginViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/10/11.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRULoginViewController.h"
#import <Lottie/Lottie.h>
#import <AVFoundation/AVFoundation.h>
#import "TRULicenseAgreementViewController.h"
#import "TRUBingUserController.h"
#import "TRULoginScanViewController.h"
#import "TRUBaseNavigationController.h"
#import "TRUCompanyAPI.h"
#import "xindunsdk.h"
#import "TRUhttpManager.h"

@interface TRULoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *bingEmailBtn;

@property (weak, nonatomic) IBOutlet UIButton *AgreementBtn;

@property (weak, nonatomic) IBOutlet UIView *ScanView;

@property (strong, nonatomic) LOTAnimationView *scanJsonView;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UIButton *scanBtn1;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanLB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnBottom;

@end

@implementation TRULoginViewController
{
    UILabel *label;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    label.hidden = YES;
//    [_scanJsonView stop];
//    [_scanJsonView playWithCompletion:^(BOOL animationFinished) {
//        if (animationFinished) {
//            label.hidden = NO;
//        }
//    }];
    NSString *URLstr = [TRUCompanyAPI getCompany].cims_server_url;
//    if (URLstr.length>0) {//说明已经切换了
//        self.bingEmailBtn.hidden = NO;
//    }else{
//        self.bingEmailBtn.hidden = YES;
//    }
    self.bingEmailBtn.hidden = NO;
    if (kDevice_Is_iPhoneX){
        self.loginBtnBottom.constant = 70 + 34;
    }
#if TARGET_IPHONE_SIMULATOR
    self.bingEmailBtn.hidden = NO;
    
#endif
//    NSString *spname = [TRUCompanyAPI getCompany].spname;
//    if (spname.length >0) {
//        self.titleLabel.text = [NSString stringWithFormat:@"%@统一身份认证",spname];
//    }else{
//        self.titleLabel.text = [NSString stringWithFormat:@"芯盾统一身份认证"];
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartQRCodeScan) name:@"trurestartQRscan" object:nil];
    
    
}

- (void)restartQRCodeScan{
    [self scanViewTap];
}

- (IBAction)scanbtnClick:(id)sender {
    [self scanViewTap];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)customUI{
    self.scanBtn1.backgroundColor = DefaultGreenColor;
    self.scanBtn1.layer.cornerRadius = 26.5;
    self.scanBtn1.layer.masksToBounds = YES;
    self.bingEmailBtn.backgroundColor = DefaultGreenColor;
    self.bingEmailBtn.layer.cornerRadius = 26.5;
    self.bingEmailBtn.layer.masksToBounds = YES;
//    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:scanBtn];
//    scanBtn.frame = CGRectMake((SCREENW - 100)/2.0, (SCREENH - 100)*378.0/(378.0+334.0), 100, 100);
//    [scanBtn addTarget:self action:@selector(scanViewTap) forControlEvents:UIControlEventTouchUpInside];
//    scanBtn.backgroundColor = DefaultGreenColor;
//    scanBtn.layer.masksToBounds = YES; //没这句话它圆不起来
//    scanBtn.layer.cornerRadius = 50.0; //设置图片圆角的大小
//    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanlogin"]];
//    [scanBtn addSubview:icon];
//    icon.frame = CGRectMake(34, 34, 32, 32);
//
//    UILabel *scanLB = [[UILabel alloc] init];
//    [self.view addSubview:scanLB];
//    scanLB.frame = CGRectMake(0, (SCREENH - 100)*378.0/(378.0+334.0) + 100 + 20, SCREENW, 14);
//    scanLB.textAlignment = NSTextAlignmentCenter;
//    scanLB.text = @"扫码绑定";
    
    
    
    [_AgreementBtn setTitle:@"《使用协议》" forState:UIControlStateNormal];
    [_AgreementBtn setTitleColor:DefaultGreenColor forState:UIControlStateNormal];
    _AgreementBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [_bingEmailBtn setBackgroundColor:DefaultColor];
    
//    _scanJsonView = [LOTAnimationView animationNamed:@"Scandata.json"];
//    _scanJsonView.frame = CGRectMake(0, 0, 230, 230);
//    [_ScanView addSubview:_scanJsonView];
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanViewTap)];
//    [_scanJsonView addGestureRecognizer:tap];
//    _scanJsonView.userInteractionEnabled = YES;
    
    //[self addScanViewMessage:@"http://192.168.1.214:8100/authn/download.html?spcode=8284f8b351c34cc0a9a68bd960fba8fc"];
}

//- (void)restartQRScan{
//    [self scanViewTap];
//}

- (void)addScanViewMessage:(NSString *)result{
    __weak typeof(self) weakSelf = self;
    NSArray *arr = [result componentsSeparatedByString:@"download"];
    
    NSString *currentCims;
    //兼容主线和永辉
    if (arr.count>0) {
        currentCims = arr[0];
    }
    
    NSString *cimsStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *pushID = [stdDefaults objectForKey:@"TRUPUSHID"];
    
    if ([currentCims isEqualToString:cimsStr]) {
        
        
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
//            [xindunsdk initEnv:@"com.example.demo" url:currentCims];
            [xindunsdk initCIMSEnv:@"com.example.demo" serviceUrl:currentCims devfpUrl:currentCims];
//            [xindunsdk initEnv:@"com.example.demo" algoType:XDAlgoTypeOpenSSL baseUrl:@"https://dfs.trusfort.com/xdid/mapi"];
            NSString *para = [xindunsdk encryptByUkey:spcode];
            NSDictionary *dic = @{@"params" : [NSString stringWithFormat:@"%@",para]};
            [TRUhttpManager getCIMSRequestWithUrl:[currentCims stringByAppendingString:@"api/ios/cims.html"] withParts:dic onResult:^(int errorno, id responseBody) {
                //[weakSelf hideHudDelay:0.0];
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
                                //[weakSelf showHudWithText:@"切换服务器成功"];
                                //[weakSelf hideHudDelay:2.0];
                                [[NSUserDefaults standardUserDefaults] setObject:spcode forKey:@"CIMSURL_SPCODE"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                //切换icon
                                //[weakSelf changeIconWithName:companyModel.icon_url];
                                //切换服务地址 http://192.168.1.115:8000/cims
//                                bool res = [xindunsdk initEnv:@"com.example.demo" url:companyModel.cims_server_url];
                                bool res = [xindunsdk initCIMSEnv:@"com.example.demo" serviceUrl:companyModel.cims_server_url devfpUrl:companyModel.cims_server_url];
//                                [xindunsdk initEnv:@"com.example.demo" algoType:XDAlgoTypeOpenSSL baseUrl:@"https://dfs.trusfort.com/xdid/mapi"];
//                                YCLog(@"initXdSDK %d",res);
                                [[NSUserDefaults standardUserDefaults] setObject:companyModel.cims_server_url forKey:@"CIMSURL"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                return;
                            }
                            //[weakSelf showHudWithText:@"切换用户成功"];
                            //[weakSelf hideHudDelay:2.0];
                            [[NSUserDefaults standardUserDefaults] setObject:spcode forKey:@"CIMSURL_SPCODE"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            //切换icon
                            //[weakSelf changeIconWithName:companyModel.icon_url];
                            //切换服务地址 http://192.168.1.115:8000/cims
//                            bool res = [xindunsdk initEnv:@"com.example.demo" url:companyModel.cims_server_url];
                            bool res = [xindunsdk initCIMSEnv:@"com.example.demo" serviceUrl:companyModel.cims_server_url devfpUrl:companyModel.cims_server_url];
//                            [xindunsdk initEnv:@"com.example.demo" algoType:XDAlgoTypeOpenSSL baseUrl:@"https://dfs.trusfort.com/xdid/mapi"];
//                            YCLog(@"initXdSDK %d",res);
                            [[NSUserDefaults standardUserDefaults] setObject:companyModel.cims_server_url forKey:@"CIMSURL"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            if ([op isEqualToString:@"active"]) {//激活
                                if (userNo && userNo.length > 0) {
                                    
                                }
                            }else if ([op isEqualToString:@"login"]){
                                
                                [weakSelf dismissViewControllerAnimated:YES completion:^{
                                    
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
                    
                    
                }else if (9019 == errorno){
                    
                }else if (9026 == errorno){
                    
                }else{
                    
                }
            }];
            
        }else{
            [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"无效二维码，请确认二维码来源！" confrimTitle:@"确认" cancelTitle:nil confirmRight:YES confrimBolck:^{
                [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
            } cancelBlock:nil];
        }
    }
}

#pragma mark - 扫码
-(void)scanViewTap{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        TRULoginScanViewController *scanVC = [[TRULoginScanViewController alloc] init];
        scanVC.backBlock =^(BOOL isTurn){
            //跳转绑定页面
            if (isTurn) {
                TRUBingUserController *bingUserVC = [[TRUBingUserController alloc] init];
                [self.navigationController pushViewController:bingUserVC animated:YES];
            }
        };
        TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:scanVC];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                   // UI更新代码
                   TRULoginScanViewController *scanVC = [[TRULoginScanViewController alloc] init];
                   scanVC.backBlock =^(BOOL isTurn){
                       //跳转绑定页面
                       if (isTurn){
                           TRUBingUserController *bingUserVC = [[TRUBingUserController alloc] init];
                           [self.navigationController pushViewController:bingUserVC animated:YES];
                       }
                   };
                   TRUBaseNavigationController *nav = [[TRUBaseNavigationController alloc] initWithRootViewController:scanVC];
                   [self presentViewController:nav animated:YES completion:nil];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                   // UI更新代码
                   [self showConfrimCancelDialogViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
                       [self dismissViewControllerAnimated:YES completion:nil];
                   } cancelBlock:nil];
                });
            }
        }];
        //
    }else if (authStatus ==AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        [self showConfrimCancelDialogViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } cancelBlock:nil];
    }
}
#pragma mark - 绑定用户
- (IBAction)bingEmailBtnClick:(UIButton *)sender {
    TRUBingUserController *bingUserVC = [[TRUBingUserController alloc] init];
    [self.navigationController pushViewController:bingUserVC animated:YES];
}

- (IBAction)AgreementBtnClick:(id)sender {
    TRULicenseAgreementViewController *lisenceVC = [[TRULicenseAgreementViewController alloc] init];
    [self.navigationController pushViewController:lisenceVC animated:YES];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
