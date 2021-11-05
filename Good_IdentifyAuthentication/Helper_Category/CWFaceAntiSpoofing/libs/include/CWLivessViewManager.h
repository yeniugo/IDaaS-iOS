//
//  CWLivessViewManager.h
//  CloudwalkFaceSDKDemo
//
//  Created by 马辉 on 2021/2/19.
//  Copyright © 2021 DengWuPing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AVCaptureVideoPreviewLayer;

@interface CWLivessViewManager : NSObject

extern NSString *const sdkUIType;

@property (nonatomic, copy) void(^startLivessAction)(void);
@property (nonatomic, copy) void(^cancelLivessAction)(NSInteger code);
@property (nonatomic, copy) void(^retryLivessAction)(NSInteger code);
@property (nonatomic, copy) void(^outTimeCallBack)(NSInteger type);
@property (nonatomic, copy) void(^goSystemSetting)(void);

@property (nonatomic, assign) BOOL isShowSuccessAnimation;
//@property (nonatomic, strong) NSArray *backColorRGB;

+ (instancetype)shareManager;

- (void)showSuccessAnimation;

/// 创建导航栏
/// @param controller 导航栏父视图的controller
- (void)navigationBarForController:(UIViewController *)controller;

/// 创建引导页
/// @param controller 引导页父视图的controller
/// @param isShowView 是否展示引导页
- (void)guideViewForController:(UIViewController *)controller
               isShowGuideView:(BOOL)isShowView;


/// 创建活检页面
/// @param controller 活检页面父视图的controller
- (void)livessViewForController:(UIViewController *)controller;

/// 创建相机预览层
/// @param previewLayer 预览层
/// @param controller 预览层父视图的controller
- (void)preLayerForCamareView:(AVCaptureVideoPreviewLayer *)previewLayer
                   Controller:(UIViewController *)controller;

/// 创建检测结果页面
/// @param controller 测结果页面父视图的controller
/// @param isSuccess 成功 || 失败
/// @param message 失败原因
/// @param data 最佳人脸图片数据
- (void)finishViewForController:(UIViewController *)controller
                     isSuccess:(BOOL)isSuccess
                 failedMessage:(NSString *)message
                      imageData:(NSData *)data;

/// 创建hack页面
/// @param controller hack页面父视图的controller
/// @param isLivessFaile 活体过程是否成功
/// @param isHackFailed hack是否通过
/// @param data 最佳人脸图片数据
- (void)hackViewForController:(UIViewController *)controller
                     isLivessFailed:(BOOL)isLivessFaile
                     isHackFailed:(BOOL)isHackFailed
                    imageData:(NSData *)data;

/// 创建超时弹窗
/// @param controller 超时弹窗父视图的controller
- (void)showTimeOutViewForController:(UIViewController *)controller;

/// 创建失败提示弹窗
/// @param title 弹窗标题
/// @param errorMessage 弹窗内容
/// @param controller 弹窗父视图的controller
- (void)showErrorAlertView:(NSString *)title errorMessage:(NSString *)errorMessage controller:(UIViewController *)controller;


/// 动作过程提示
/// @param text 动作提示
/// @param index 第几个动作
/// @param actions 动作数组
- (void)activityTipText:(NSString *)text stepIndex:(NSInteger)index actions:(NSArray *)actions;
- (void)showTimer:(NSInteger)time;
- (void)stopTimer;
- (void)hiddenComponent;
- (void)showLivessView;

- (void)retryViewControl:(BOOL)isShowGuideView;
- (void)stopTipsAnimations;
- (void)changeErrorTipArea:(NSString *)tipName;

//防hack正在检测
- (void)showHackTips;

//截屏方法
- (void)snapScreenImage:(UIImage *)image controller:(UIViewController *)controller block:(void(^_Nullable)(UIImage *screenImage))block;
- (void)renderView:(UIView*)view inContext:(CGContextRef)context;

/// 相机权限弹窗
/// @param controller 父视图controller
/// @param title 标题
/// @param message 内容
/// @param leftTitle 左按钮标题
/// @param rightTitle 右按钮标题
- (void)cw_cameraAlertController:(UIViewController *)controller
                    withTitle:(NSString *)title
                      message:(NSString *)message
                 leftBtnTitle:(NSString *)leftTitle
                rightBtnTitle:(NSString *)rightTitle;

//是否展示倒计时的label
- (void)showCountDownLabel:(BOOL)show;

- (UIView *)getCameraMaskView;
- (void)setCameraMaskViewColor;
- (UIView *)getNavBarView;
- (void)setNavBarViewColor;
//更改背景色光线
//- (void)changeBackColorWithColors:(NSArray *)colorList twinkInterval:(CGFloat)twinkInterval;
@end

NS_ASSUME_NONNULL_END
