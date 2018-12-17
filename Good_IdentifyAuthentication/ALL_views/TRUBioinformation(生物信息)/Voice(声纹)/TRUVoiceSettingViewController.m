//
//  TRUVoiceSettingViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/11.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUVoiceSettingViewController.h"
#import "TRUFaceVoiceSettingButton.h"
#import "TRUVoiceInitViewController.h"
#import "TRUVoiceVerifyViewController.h"
#import "TRUNetworkStatus.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import <iflyMSC/IFlyISVRecognizer.h>
#import "TRUhttpManager.h"
@interface TRUVoiceSettingViewController ()

@end

@implementation TRUVoiceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"声纹信息";
    [self setUpSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpSubviews{
    
    //img
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voIcesetingbg"]];
    [self.view addSubview:imgView];
    
    
    CGFloat fonsize = 16.f * PointHeightRatio6;
    UIImage *img = [UIImage imageNamed:@"identify_jiantou"];
    TRUFaceVoiceSettingButton *resetBtn = [TRUFaceVoiceSettingButton buttonWithType:UIButtonTypeCustom];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    [resetBtn setImage:img forState:UIControlStateNormal];
    [resetBtn setTitle:@"删除声纹信息" forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(resetVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetBtn];
    
    TRUFaceVoiceSettingButton *authBtn = [TRUFaceVoiceSettingButton buttonWithType:UIButtonTypeCustom];
    authBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    [authBtn setImage:img forState:UIControlStateNormal];
    [authBtn setTitle:@"尝试验证" forState:UIControlStateNormal];
    [authBtn addTarget:self action:@selector(verifyVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authBtn];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@100);
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
    }];
    
    [authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(imgView.mas_bottom).offset(20.0);
        make.height.equalTo(@(50.0 * PointHeightRatio6));
    }];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(authBtn);
        make.top.equalTo(authBtn.mas_bottom).offset(1.0);
    }];
    
}
- (void)resetVoice{
    __weak typeof(self) weakSelf = self;
    if ([TRUNetworkStatus currentNetworkStatus] == NotReachable) {
        [weakSelf showConfrimCancelDialogViewWithTitle:@"" msg:kBadErrorTip confrimTitle:@"确认" cancelTitle:nil confirmRight:YES confrimBolck:nil cancelBlock:nil];
        return;
    }
    
    [self showConfrimCancelDialogViewWithTitle:@"" msg:@"您确认删除声纹信息吗？" confrimTitle:@"确认" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
        [weakSelf showHudWithText:@"正在删除声纹信息..."];
        
        //NSString *voiceid = [TRUUserAPI getUser].voiceid;
        int err = -1;
        NSString *userid = [TRUUserAPI getUser].userId;
        NSString *authid = [xindunsdk getCIMSVoiceAuthIDForUser:userid];
        BOOL isDel = [[IFlyISVRecognizer sharedInstance] sendRequest:@"del" authid:authid pwdt:3 ptxt:nil vid:nil err:&err];
        YCLog(@"删除语音模型结果 %d", err);
        if (isDel || err == 10116) {//10116 没有声纹模型
            NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
            NSString *sign = @"2";
            NSArray *ctxx = @[@"optype",sign];
            //同步用户信息
            NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
            NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
            [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/deluserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
                [weakSelf hideHudDelay:0.0];
                NSString *tip = @"";
                if (0 == errorno) {
                    tip = @"删除声纹信息成功";
                    TRUUserModel *model = [TRUUserAPI getUser];
                    model.voiceid = @"";
                    [TRUUserAPI saveUser:model];
                }else if (9019 == errorno){
                    [weakSelf deal9019Error];
                    return;
                }else{
                    tip = @"删除声纹信息失败，请稍后重试";
                }
                [weakSelf showHudWithText:tip];
                [weakSelf hideHudDelay:2.0];
                [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:2.0];
            }];

        }else{
            [weakSelf showHudWithText:@"网络错误，请稍后重试"];
            [weakSelf hideHudDelay:2.0];
            [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:2.0];
        }
    } cancelBlock:^{
        
    }];
    
  
}
- (void)verifyVoice{
    if ([TRUNetworkStatus currentNetworkStatus] == NotReachable) {
        [self showConfrimCancelDialogViewWithTitle:@"" msg:kBadErrorTip confrimTitle:@"确认" cancelTitle:nil confirmRight:YES confrimBolck:nil cancelBlock:nil];
        return;
    }
    TRUVoiceVerifyViewController *verifyVC = [[TRUVoiceVerifyViewController alloc] init];
    verifyVC.isTest = YES;
    [self.navigationController pushViewController:verifyVC animated:YES];
}

@end
