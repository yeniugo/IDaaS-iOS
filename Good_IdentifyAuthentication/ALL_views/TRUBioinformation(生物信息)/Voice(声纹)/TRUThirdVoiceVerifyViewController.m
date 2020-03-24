//
//  TRUThirdVoiceVerifyViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2018/1/17.
//  Copyright © 2018年 zyc. All rights reserved.
//

#import "TRUThirdVoiceVerifyViewController.h"
#import "TRUThirdFaceVerifyViewController.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUhttpManager.h"
#import "TRUMTDTool.h"
@interface TRUThirdVoiceVerifyViewController ()

@end

@implementation TRUThirdVoiceVerifyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sst = VERIFY_SST;
    self.navigationItem.title = @"语音验证";
    self.navigationController.navigationBarHidden = NO;
    
    [self setUpNav];
    
    NSString *ptString=[self.passwords objectAtIndex:0];
    NSString *authid = [xindunsdk getCIMSVoiceAuthIDForUser:[TRUUserAPI getUser].userId];
    [self setIsvParamWithAuthId:authid withPassword:ptString withSSType:self.sst];
    
    [self setNumber:[self.passwords firstObject]];
}
- (void)setUpNav{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(back2LastVC) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
}
-(void) startRecVoice {
    [super startRecVoice];
    
    
    [self.isvRecognizer startListening];//开始录音
}

-(void)onResult:(NSDictionary *)dic{
    [super onResult:dic];
    YCLog(@"init onResult");
    [self resultProcess:dic];
}

-(void)onError:(IFlySpeechError *)errorCode{
    [super onError:errorCode];
    //    XDLog(@"init onError:%d", errorCode.errorCode);
    int err = errorCode.errorCode;
    
    if (err != 0) {
        __weak typeof(self) weakSelf = self;
        if (err == 10116) {
            [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"模型不存在，请先注册" confrimTitle:@"确定" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                [weakSelf back2LastVC];
            } cancelBlock:^{
                [weakSelf back2LastVC];
            }];
        }else{
            [weakSelf showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"声纹验证失败，是否重试？" confrimTitle:@"重试" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                
            } cancelBlock:^{
                [weakSelf back2LastVC];
            }];
        }
        
    }
    
}

//对声纹回调结果进行处理
-(void)resultProcess:(NSDictionary *)dic {
    if( dic == nil ){
        YCLog(@"in %s,dic is nil",__func__);
        return;
    }
    if([[dic objectForKey:DCS] isEqualToString:SUCCESS] ){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"needRefreshPush" object:nil];
        YCLog(@"声纹验证成功");
        __weak typeof(self) weakSelf = self;
        NSString *userid = [TRUUserAPI getUser].userId;
        NSString *vtoken = self.voicetoken ? self.voicetoken : @"dummy_token";
        
        NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
        NSString *sign = [NSString stringWithFormat:@"%@%@",vtoken,@"1"];
        NSArray *ctxx = @[@"token",vtoken,@"confirm",@"1"];
        //同步用户信息
        NSString *paras = [xindunsdk encryptByUkey:userid ctx:ctxx signdata:sign isDeviceType:NO];
        NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
        [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/voice"] withParts:dictt onResultWithMessage:^(int errorno, id responseBody, NSString *message){
            [weakSelf hideHudDelay:0.0];
            NSString *tip = @"";
            if (0 == errorno) {
                [TRUMTDTool uploadDevInfo];
                tip = @"声纹验证成功";
                [weakSelf showHudWithText:tip];
                [weakSelf hideHudDelay:2.0];
                if (weakSelf.isMoreVerify) {
                    NSString *facestr = [TRUUserAPI getUser].faceinfo;
                    if ([facestr isEqualToString:@"0"]) {
                        [weakSelf showHudWithText:@"您未初始化人脸，请选择其他方式认证"];
                        [weakSelf hideHudDelay:2.0];
                        [weakSelf performSelector:@selector(back2LastVC) withObject:nil afterDelay:2.0];
                    }else{
                        TRUThirdFaceVerifyViewController *faceVC = [[TRUThirdFaceVerifyViewController alloc] init];
                        faceVC.facetoken = self.voicetoken;
                        faceVC.isPushVerify = YES;
                        [weakSelf.navigationController pushViewController:faceVC animated:YES];
                    }
                }else{
                    NSString *schmeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"WAKEUPSOURESCHME"];
                    NSString *urlstr = [schmeStr stringByAppendingString:@"://"];
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        NSURL *url = [NSURL URLWithString:urlstr];
                        [[UIApplication sharedApplication] openURL:url options:@{@"status":@"success"} completionHandler:nil];
                    }];
                }
            }else if (9019 == errorno){
                [weakSelf deal9019Error];
                return;
            }else if (-5004 == errorno){
                tip = @"网络错误，请稍后重试";
                [weakSelf showHudWithText:tip];
                [weakSelf hideHudDelay:2.0];
                [weakSelf performSelector:@selector(back2LastVC) withObject:nil afterDelay:2.0];
            }else if (9008 == errorno){//秘钥失效
                [weakSelf deal9008Error];
                
                return;
            }else if (9033 == errorno){
                tip = message;
            }else{
                tip = [NSString stringWithFormat:@"其他错误（%d）",errorno];
                [weakSelf showHudWithText:tip];
                [weakSelf hideHudDelay:2.0];
                [weakSelf performSelector:@selector(back2LastVC) withObject:nil afterDelay:2.0];
            }
        }];

        
    }else{
        
        [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:@"声纹验证失败，是否重试？" confrimTitle:@"重试" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
            
        } cancelBlock:^{
            [self back2LastVC];
        }];
    }
}
- (void)back2LastVC{
    if (self.popThirdVoiceBlock) {
        self.popThirdVoiceBlock();
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)post3DataNoti{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh3DataNotification object:nil];
}

@end
