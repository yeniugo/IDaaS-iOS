//
//  TRUFaceBaseViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUFaceBaseViewController.h"
#import "CWLivessViewController.h"
#import "NSBundle+CWLocalization.h"
#import "CWMBProgressHud.h"



#if TARGET_IPHONE_SIMULATOR
#else
//#import <AuthenAnti_SpoofingSDK/AuthenAnti_SpoofingSDK.h>
//#import "NSCameraOption.h"

#endif

//#import <objc/runtime.h>
//#import "TRUMacros.h"
//
//#define FcameraView CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
//#define usingRuntimeProcess NO

#if TARGET_IPHONE_SIMULATOR
#else
#endif

#if TARGET_IPHONE_SIMULATOR
@interface TRUFaceBaseViewController ()
@end
#else
@interface TRUFaceBaseViewController ()<CWLivessViewControllerDelegate>

@property (nonatomic,weak) CWLivessViewController *facevc;
@end
#endif
@implementation TRUFaceBaseViewController
#if TARGET_IPHONE_SIMULATOR
- (NSMutableArray *) getActionSequence{
    return [NSMutableArray array];
}
- (void) onDetectSuccessWithImages:(UIImage *) images{
    
}
- (void) onDetectFailWithMessage:(NSString *) message{
    
}
- (void) restartDetection{
    
}
- (void) restartGroupDetection{
    
}
#else

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addFace];
}

- (void)addFace{
    CWLivessViewController *lvctl = [[CWLivessViewController alloc] init];
    
    /* 设置代理(可选设置项), 如果用户需要对检测数据及结果做自定义操作，可设置代理，接收代理方法消息*/
    lvctl.delegate = self;
    
    /* 授权码(必设置项), 授权码向云从科技申请，由云从科技授发*/
    lvctl.authCodeString = @"MTk0MDA5bm9kZXZpY2Vjd2F1dGhvcml6Zbfm4ubm5+bq/+bg5efm4+f75ubm4Obg5Yjm5uvl5ubrkeXm5uvl5uai6+Xm5uvl5uTm6+Xm5uDm1efr5+vn6+er4Ofr5+vn69/n5+bn4ufn";
    lvctl.encryptPackageName = @"214426d69fb47454825930720ad0311c";
    
    /* 动作数组(可选设置项), 默认为4个动作集合(最多支持且只支持这四个动作,[眨眼,张嘴,左转头,右转头])*/
    lvctl.allActionArry = @[CWLiveActionBlink,CWLiveActionOpenMouth,CWLiveActionHeadLeft,CWLiveActionHeadRight];

    /* 检测动作个数(可选设置项), 默认为3个动作，注意，设置的动作个数不能大于allActionArry的个数*/
    lvctl.livessNumber = self.maxDetectionTimes;
    /*注意:动作个数与动作数组是结合使用的，本业务实现中最终检测使用的动作为从动作数组allActionArry中取出livessNumber个不同动作组成的*/
    
    //是否随机传入的动作。默认随机
    lvctl.isRandomActions = YES;

    /* 单个活体动作检测超时时间(可选设置项), 默认为8秒*/
    lvctl.livessTime = 8;
    lvctl.prepareTime = 8;
    /* 是否播放提示语音(可选设置项), 默认为打开YES*/
    lvctl.isPlayAudio = YES;
    
    /* 是否显示检测结果页， 失败、成功页面默认YES*/
    lvctl.isShowSuccessResultView = YES;
    lvctl.isShowFailResultView = YES;

    /* 是否显示检测结果页(可选设置项), 默认为打开YES*/
    lvctl.isShowGuideView = NO;
      
    /*    是否打开log*/
    lvctl.isOpenLog = NO;
    
    /* 防hack攻击选项(可选设置项), 默认为后端检测方式CWHackDetectBankend*/
    lvctl.hackerDetectType = CWHackDetectNone;
    
//    lvctl.maxQualityAction = [NSUserDefaults maxQualityAction];
//    lvctl.isShowPrepareTime = YES;
    lvctl.isRecord = NO;
    lvctl.retryCount = 3;
    //开启裁剪功能
//    lvctl.isOpenSnapScreenImage = YES;
//    lvctl.errorTipsStyle= CWErrorTipsAlertStyle;
    lvctl.faceMissingInterval = 100.f;
    lvctl.isRootStopLivess = NO;
    self.facevc = lvctl;
    [self addChildViewController:lvctl];
    [self.view addSubview:lvctl.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeActionX{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  ------------  活体检测代理方法---------------

- (void)onLivenessCancelWithErrorCode:(NSInteger)code
{
   NSString *message =  [[CloudwalkFaceSDK shareInstance] cwSwitcErrorCodeToMessage:code];
    [[CWMBProgressHud sharedClient] showHudModel:NO message:[NSString stringWithFormat:@"%@",message] hudMode:CWMBProgressHudModeText];
    [self onDetectFailWithMessage:message];
}

- (void)onLivenessCancel {
//    NSLog(@"取消检测!");
    [self closeActionX];
}

- (void)viewController:(UIViewController *_Nullable)viewController
    bestFaceOriginData:(NSData *_Nullable)bestFaceOriginData
            resultDataDict:(NSDictionary *)resultDataDict
       backendHackData:(NSString *_Nullable)backendHackData {
    
    if(bestFaceOriginData!=nil){
        UIImage * image = [UIImage imageWithData:bestFaceOriginData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        NSData *bestFaceCropData = [resultDataDict objectForKey:@"bestFaceCropData"];
        UIImage * image1 = [UIImage imageWithData:bestFaceCropData];
        [self onDetectSuccessWithImages:image1];
    }
}

/**
检测过程中的状态
 @param  statusCode 活体检测的状态码
 */
- (void)livessDetectStatusWithCode:(NSInteger)statusCode
{
    NSString *str =  [[CloudwalkFaceSDK shareInstance] cwSwitcErrorCodeToMessage:statusCode];
    [[CWMBProgressHud sharedClient] showHudModel:NO message:[NSString stringWithFormat:@"%@",str] hudMode:CWMBProgressHudModeText];
}

- (void)viewController:(CWLivessViewController *)viewController livenessDetectionFailed:(NSInteger)errCode {
    
    NSString *str =  [[CloudwalkFaceSDK shareInstance] cwSwitcErrorCodeToMessage:errCode];
    [[CWMBProgressHud sharedClient] showHudModel:NO message:[NSString stringWithFormat:@"%@",str] hudMode:CWMBProgressHudModeText];
    NSLog(@"检测失败!%@",str);
}

- (NSMutableArray *)getActionSequence {
    return  [NSMutableArray array];//[[NSMutableArray alloc] initWithArray:@[@"0", @"1", @"2", @"16"]];
}
- (void)onDetectSuccessWithImages:(UIImage *)images {
    //    self.infoView.text = [NSString stringWithFormat:@"成功:%lu",(unsigned long)images.count];
//    YCLog(@"onDetectSuccessWithImages:%lu",(unsigned long)images.count);
}
- (void)onDetectFailWithMessage:(NSString *)message {
    //    self.infoView.text = [NSString stringWithFormat:@"失败请重新开始验证"];
    //[self restartDetection];
    
}

//重新一组中的单个动作
-(void)restartDetection{
    
}

- (void)restartGroupDetection{
    [self.facevc.view removeFromSuperview];
    [self.facevc removeFromParentViewController];
    [self addFace];
}

#endif
@end

