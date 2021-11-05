//
//  LiveDetectViewController.h
//  CloudwalkFaceSDKDemo
//
//  Created by DengWuPing on 16/5/12.
//  Copyright © 2016年 DengWuPing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudwalkFaceSDK.h"
#import "CWLivessViewControllerDelegate.h"

#define CWHackResultNotifacation @"CWHackResultNotifacation" // 后端防hack通知名称

typedef NS_ENUM(NSInteger,CWHackDetectLevel){
    CWHackDetectBankend=0, //后端(在线)方式
    CWHackDetectFront = 1, //前端(离线/本地)方式
    CWHackDetectNone=2     //不做防hack操作
};

typedef NS_ENUM(NSInteger,CWErrorTipsStyle){
    CWErrorTipsAlertStyle=0, //弹窗提示
    CWErrorTipsViewStyle = 1, //页面提示
};

@interface CWLivessViewController : UIViewController


@property (nonatomic, weak) id <CWLivessViewControllerDelegate> _Nullable delegate;

/**
 云从科技获取的授权码
 */
@property (nonatomic, strong) NSString *  _Nonnull authCodeString;
/**
 云从科技获取的加密之后的bundleID
 */
@property (nonatomic, strong) NSString *  _Nonnull encryptPackageName;

/**
 活体动作数组，默认设置为 (张嘴  眨眼  左转头 右转头)
 @[CWLiveActionBlink,
 CWLiveActionOpenMouth,
 CWLiveActionHeadLeft,
 CWLiveActionHeadRight]
 */
@property (nonatomic, strong) NSArray<CWLiveActionType>  * _Nullable allActionArry;

/**
 活体动作检测超时时间  默认设置为8秒  设置为0的时候不显示倒计时
 */
@property (nonatomic, assign) NSInteger livessTime;

/**
活体动作准备阶段超时时间 设置为0的时候不显示倒计时
*/
@property (nonatomic, assign) NSInteger prepareTime;

/**
 活体检测动作个数 默认设置为3个( 0 <= livessNumber   <= allActionArry.count )
 */
@property (nonatomic, assign) NSInteger livessNumber;
/**
 是否播放提示语音  默认为YES
 */
@property (nonatomic, assign) BOOL  isPlayAudio;
/**
 是否显示活体检测引导页面  默认为YES
 */
@property (nonatomic, assign) BOOL isShowGuideView;
/**
 是否显示活体检测结果页面 (检测失败的View )  默认为YES
 */
@property (nonatomic, assign) BOOL isShowFailResultView;
/**
 是否显示活体检测结果页面 (检测成功的View )  默认为YES
 */
@property (nonatomic, assign) BOOL isShowSuccessResultView;

/**
 是否使用后置摄像头 默认为NO,使用前置摄像头
 */
@property (nonatomic, assign) BOOL isUserBackCamera;

/**
 选择防hacker的方式 默认CWHackDetectBankend
 */
@property (nonatomic, assign) CWHackDetectLevel hackerDetectType;

/**
 是否打开log，默认关闭
 备注：  发版需关闭log
 */
@property (nonatomic, assign) BOOL isOpenLog;

@property (nonatomic, assign) UIStatusBarStyle  statusBarStyle; //顶部状态栏颜色
/**
 是否严格要求动作一致性，默认为YES
 */
@property (nonatomic, assign) BOOL  maxQualityAction;
/**
 是否按照指定动作顺序
 */
@property (nonatomic, assign) BOOL  isRandomActions;


/**
 错误提示方式
 */
@property (nonatomic, assign) CWErrorTipsStyle errorTipsStyle;


/**
 是否开启截屏
 */
@property (nonatomic, assign) BOOL  isOpenSnapScreenImage;

/**
 越狱情况下是否立即终止活检
 */
@property (nonatomic, assign) BOOL  isRootStopLivess;

@property (nonatomic,assign) BOOL isRecord;//是否在活体检测的过程中录制视频  默认为NO
@property (nonatomic,strong) NSString * _Nullable videoPath;//视频存储地址 默认地址为  "~/Documents/cwLivessDetect.mp4"
/**
 设置活体检测参数

 @param authCode SDK授权码（必须传入从云从科技获取的正确的授权码）
 @param activeNumber 活体动作个数（可设置0-4个活体动作  默认为3个动作）
 @param hackerDetectType 进行防hack的类型选择
 */
- (void)setLivessParam:(NSString * _Nonnull)authCode
          livessNumber:(NSInteger)activeNumber
      hackerDetectType:(CWHackDetectLevel)hackerDetectType;

/**
 获取SDK版本号方法
 */
+ (NSString * _Nonnull)cwGetSDKVersion;

/**
 连续(faceMissingInterval)毫秒内检测不到人脸，报人脸丢失。默认值为100ms
 */
@property(nonatomic, assign) CGFloat faceMissingInterval;

// 允许失败的次数
@property(nonatomic,assign) NSInteger retryCount;

//背景颜色
@property(nonatomic,strong) NSArray * _Nullable backgroundColorList;

@end
