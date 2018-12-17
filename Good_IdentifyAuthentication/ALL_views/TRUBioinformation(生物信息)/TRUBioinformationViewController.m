//
//  TRUBioinformationViewController.m
//  Good_IdentifyAuthentication
//
//  Created by zyc on 2017/9/25.
//  Copyright © 2017年 zyc. All rights reserved.
//

#import "TRUBioinformationViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AVFoundation/AVFoundation.h>
#import <iflyMSC/IFlyPcmRecorder.h>
#import "TRUNormalButton.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
#import "TRUNetworkStatus.h"

#import "TRUFaceGuideViewController.h"
#import "TRUFaceSettingViewController.h"
#import "TRUVoiceInitViewController.h"
#import "TRUVoiceSettingViewController.h"
#import "TRUhttpManager.h"


@interface TRUBioinformationViewController ()

@end

@implementation TRUBioinformationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.scanBtn.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.scanBtn.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //画UI
    [self customUI];
    //同步一次用户信息
    [self syncUserInfo];
    
}

- (void)syncUserInfo{
    [self showHudWithText:@"正在同步用户信息..."];
    __weak typeof(self) weakSelf = self;
    NSString *userid = [TRUUserAPI getUser].userId;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
    //同步用户信息
    NSString *paras = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
    NSDictionary *dictt = @{@"params" : [NSString stringWithFormat:@"%@",paras]};
    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getuserinfo"] withParts:dictt onResult:^(int errorno, id responseBody) {
        NSDictionary *dicc = nil;
        [weakSelf hideHudDelay:0.0];
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

-(void)customUI{
    
    self.title = @"生物信息";
    
    
    //获取当前UIWindow 并添加一个视图
    UIApplication *ap = [UIApplication sharedApplication];
    [ap.keyWindow addSubview:self.scanBtn];
    
    
    float gap = 20;
    float animationViewH = 80;
    //动画
    UIImageView *animationView = [[UIImageView alloc] initWithFrame:CGRectMake(gap, 64+2*gap, SCREENW - 2*gap, animationViewH)];
    [self.view addSubview:animationView];
    [animationView setImage:[UIImage imageNamed:@"bioinfobg"]];
    
    
    //人脸信息
    TRUNormalButton *faceInformationBtn = [[TRUNormalButton alloc] initWithFrame:CGRectMake(gap, 64+4*gap+animationViewH, SCREENW/2.f - 25, SCREENW/2.f - 25) withTitle:@"人脸信息" image:@"facebg" andButtonClickEvent:^(TRUNormalButton *sender) {
        [self isTimeOut];
    }];
    [self.view addSubview:faceInformationBtn];
    faceInformationBtn.layer.masksToBounds = YES;
    faceInformationBtn.layer.cornerRadius = 3.f;
    faceInformationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    faceInformationBtn.layer.borderWidth = 1.f;
    
    //声纹信息
    TRUNormalButton *voiceprintInformationBtn = [[TRUNormalButton alloc] initWithFrame:CGRectMake(SCREENW/2.f +5, 64+4*gap+animationViewH, SCREENW/2.f - 25, SCREENW/2.f - 25) withTitle:@"声纹信息" image:@"voicebg" andButtonClickEvent:^(TRUNormalButton *sender) {
//        YCLog(@"声纹信息");
        [self startVoice];
    }];
    [self.view addSubview:voiceprintInformationBtn];
    voiceprintInformationBtn.layer.masksToBounds = YES;
    voiceprintInformationBtn.layer.cornerRadius = 3.f;
    voiceprintInformationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    voiceprintInformationBtn.layer.borderWidth = 1.f;
    
    
    if (kDevice_Is_iPhoneX) {
        animationView.frame = CGRectMake(gap, 120+2*gap, SCREENW - 2*gap, animationViewH);
        faceInformationBtn.frame = CGRectMake(gap, 120+4*gap+animationViewH, SCREENW/2.f - 25, SCREENW/2.f - 25);
        voiceprintInformationBtn.frame = CGRectMake(SCREENW/2.f +5, 120+4*gap+animationViewH, SCREENW/2.f - 25, SCREENW/2.f - 25);
    }
}

- (void)startFace{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        NSString *faceinfo = [TRUUserAPI getUser].faceinfo;
        if ([faceinfo isEqualToString:@"1"]) {
            TRUFaceSettingViewController *faceSetVC = [[TRUFaceSettingViewController alloc] init];
            [self.navigationController pushViewController:faceSetVC animated:YES];
            
        }else{
            TRUFaceGuideViewController *vc = [[TRUFaceGuideViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    NSString *faceinfo = [TRUUserAPI getUser].faceinfo;
                    if ([faceinfo isEqualToString:@"1"]) {
                        TRUFaceSettingViewController *faceSetVC = [[TRUFaceSettingViewController alloc] init];
                        [self.navigationController pushViewController:faceSetVC animated:YES];
                        
                    }else{
                        TRUFaceGuideViewController *vc = [[TRUFaceGuideViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }else{
                    [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    } cancelBlock:nil];
                }
            });
            
        }];
    }else if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:kCameraFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } cancelBlock:nil];
    }
}

- (void)startVoice{
    if ([TRUNetworkStatus currentNetworkStatus] == NotReachable) {
        [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:kBadErrorTip confrimTitle:@"确认" cancelTitle:nil confirmRight:YES confrimBolck:nil cancelBlock:nil];
        return;
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (audioSession.recordPermission == AVAudioSessionRecordPermissionUndetermined) {
        [self showHudWithText:@"正在授权..."];
        [audioSession requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHudDelay:0.0];
                if (granted) {
                    NSString *voiceid = [TRUUserAPI getUser].voiceid;
                    
                    if (voiceid.length > 0) {
                        TRUVoiceSettingViewController *faceSetVC = [[TRUVoiceSettingViewController alloc] init];
                        [self.navigationController pushViewController:faceSetVC animated:YES];
                        
                    }else{
                        TRUVoiceInitViewController *voiceVC = [[TRUVoiceInitViewController alloc] init];
                        [self.navigationController pushViewController:voiceVC animated:YES];
                    }
                }else{
                    [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:kMicrophoneFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    } cancelBlock:^{
                        
                    }];
                }
            });
            
            
        }];
    }else if(audioSession.recordPermission == AVAudioSessionRecordPermissionDenied){
        [self showConfrimCancelDialogAlertViewWithTitle:@"" msg:kMicrophoneFailedTip confrimTitle:@"好" cancelTitle:nil confirmRight:YES confrimBolck:^{
            [self.navigationController popViewControllerAnimated:YES];
        } cancelBlock:^{
            
        }];
    }else if (audioSession.recordPermission == AVAudioSessionRecordPermissionGranted){
        
        NSString *voiceid = [TRUUserAPI getUser].voiceid;
        
        if (voiceid.length > 0) {
            TRUVoiceSettingViewController *faceSetVC = [[TRUVoiceSettingViewController alloc] init];
            [self.navigationController pushViewController:faceSetVC animated:YES];
            
        }else{
            TRUVoiceInitViewController *voiceVC = [[TRUVoiceInitViewController alloc] init];
            [self.navigationController pushViewController:voiceVC animated:YES];
        }
    }
}
-(void)isTimeOut{
    
    NSString *currentTimeStr = [self getCurrentTimes];
    //    NSLog(@"----->%@",currentTimeStr);
    int dd = [self compareDate:currentTimeStr withDate:@"2019-03-30"];
    //    NSLog(@"----->%d",dd);
    if (dd >= 0) {
        [self startFace];
    }else{
        [self alertWithStr:@"您所使用的人脸认证服务已到期，即将更新，请耐心等待。"];
    }
}

-(NSString*)getCurrentTimes{
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    return currentDateStr;
}

//比较两个日期大小
-(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate{
    
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    //    NSLog(@"result==%ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            //NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
}
-(void)alertWithStr:(NSString *)alertstr{
    UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"" message:alertstr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confrimAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:confrimAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
