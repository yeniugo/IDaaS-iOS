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

@interface TRULoginScanViewController ()

@property (nonatomic, weak) UIView *maskView;

@property (nonatomic, weak) TRUScanView *scanView;

@end

@implementation TRULoginScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUPMaskView];
    [self setUPScanView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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
    TRUScanView *scanView = [[TRUScanView alloc] initWithScanLine];
    [scanView setScanResultBlock:^(NSString *result) {
        
        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
        NSString *pushID = [stdDefaults objectForKey:@"TRUPUSHID"];
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
                
                [xindunsdk verifyCIMSActiveForUser:userNo type:@"email" authCode:authcode pushID:pushID onResult:^(int error, id res) {
                    [weakSelf hideHudDelay:0.0];
                    if (error == 0) {
                        //同步用户信息
                        [xindunsdk getCIMSUserInfoForUser:res onResult:^(int error, id response) {
                            [weakSelf hideHudDelay:0];
                            if (0 == error) {
                                //用户信息同步成功
                                TRUUserModel *model = [TRUUserModel modelWithDic:response];
                                model.userId = res;
                                [TRUUserAPI saveUser:model];
                                if ([self checkPersonInfoVC:model]) {//yes 表示需要完善信息
                                    TRUAddPersonalInfoViewController *infoVC = [[TRUAddPersonalInfoViewController alloc] init];
                                    infoVC.userNo = userNo;
                                    infoVC.email = model.email;
                                    infoVC.isScan = YES;
                                    infoVC.backBlocked=^(){
                                        [weakSelf cancelBtnClick];
                                    };
                                    [weakSelf.navigationController pushViewController:infoVC animated:YES];
                                }else{//同步信息成功，信息完整，跳转页面
#pragma clang diagnostic ignored "-Wundeclared-selector"
                                    id delegate = [UIApplication sharedApplication].delegate;
                                    if ([delegate respondsToSelector:@selector(changeRootVC)]) {
                                        [delegate performSelector:@selector(changeRootVC)];
                                    }
                                }
                                
                            }
                            
                        }];
                        
                        
                    }else if (-5004 == error){
                        
                        [weakSelf showHudWithText:@"网络错误，请稍后重试"];
                        [weakSelf hideHudDelay:2.0];
                        [weakSelf performSelectorOnMainThread:@selector(restartScan) withObject:nil waitUntilDone:3];
                    }else if (9019 == error){
                        [weakSelf dele9019ErrorWithBlock:^{
                            [weakSelf restartScan];
                        }];;
                    }else{
                        [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"该二维码已失效，请尝试自注册或联系管理员" confrimTitle:@"自注册" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                            [weakSelf pinBtnClick];
                        } cancelBlock:^{
                            [weakSelf dismissViewControllerAnimated:YES completion:nil];
                        }];
                    }
                }];
                
            }else{//如果userno不存在 二维码来源不对
                
                [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"无效二维码，请确认二维码来源！" confrimTitle:@"确定" cancelTitle:nil confirmRight:YES confrimBolck:^{
                    [weakSelf restartScan];
                } cancelBlock:nil];
            }
            
        }else if ([op isEqualToString:@"login"]){
            [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"该终端还未激活，请尝试自注册激活或联系管理员" confrimTitle:@"自注册" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                [weakSelf pinBtnClick];
            } cancelBlock:^{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
            
        }else{//不是login 也不是active 无效二维码，请确认二维码来源！
            
            [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:@"无效二维码，请确认二维码来源！" confrimTitle:@"确认" cancelTitle:nil confirmRight:YES confrimBolck:^{
                [weakSelf restartScan];
            } cancelBlock:nil];
            
        }
        
    }];


    [self.maskView insertSubview:self.scanView = scanView atIndex:0];
    [scanView mas_makeConstraints:^(MASConstraintMaker *make){
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

    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:@"二维码绑定不成功请手动绑定邮箱"];
    NSRange r1= [attrTitle.string rangeOfString:@"二维码绑定不成功"];
    NSRange r2 = [attrTitle.string rangeOfString:@"请手动绑定邮箱"];
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:r1];
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"0x2669E7"] range:r2];


    UIButton *pinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pinBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [pinBtn setAttributedTitle:attrTitle forState:UIControlStateNormal];
    [pinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [pinBtn addTarget:self action:@selector(pinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:pinBtn];
    [pinBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.maskView).offset(20.0);
        make.right.equalTo(self.maskView).offset(-20.0);
        make.top.equalTo(tipLabel.mas_bottom).offset(132 * PointHeightRatio6);
    }];

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
    
    if (model.phone.length>0 || model.email.length>0) {
        return NO;
    }else{
        return YES;
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

@end
