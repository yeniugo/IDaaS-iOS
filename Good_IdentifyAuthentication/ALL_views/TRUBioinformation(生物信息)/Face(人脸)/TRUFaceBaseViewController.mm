//
//  TRUFaceBaseViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUFaceBaseViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "BDFaceVideoCaptureDevice.h"
#import "BDFaceLivingConfigModel.h"
#import "BDFaceRemindView.h"
#import "BDFaceImageShow.h"
#import "BDFaceLog.h"
// 判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

// 判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define scaleValue 0.70
#define scaleValueX 0.80

#define ScreenRect [UIScreen mainScreen].bounds
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

/**iPhone6s为标准，乘以宽的比例*/
#define KScaleX(value) ((value)/375.0f * ScreenWidth)
/**iPhone6s为标准，乘以高的比例*/
#define KScaleY(value) ((value)/667.0f * ScreenHeight)


#if TARGET_IPHONE_SIMULATOR
#else
//#import <AuthenAnti_SpoofingSDK/AuthenAnti_SpoofingSDK.h>
//#import "NSCameraOption.h"

#endif

#import <objc/runtime.h>
#import "TRUMacros.h"

#define FcameraView CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
#define usingRuntimeProcess NO

#if TARGET_IPHONE_SIMULATOR
#else
#endif

#if TARGET_IPHONE_SIMULATOR
@interface TRUFaceBaseViewController ()
@end
#else
@interface TRUFaceBaseViewController ()<CaptureDataOutputProtocol>
{
    UIImageView * newImage;
    BOOL isPaint;
}
@property (nonatomic, strong) NSArray *livenessArray;
@property (nonatomic, assign) BOOL order;
@property (nonatomic, assign) NSInteger numberOfLiveness;
@property (nonatomic, assign) BOOL isAnimating;


@property (nonatomic, readwrite, retain) BDFaceVideoCaptureDevice *videoCapture;
@property (nonatomic, readwrite, retain) UILabel *remindLabel;
@property (nonatomic, readwrite, retain) UIImageView *voiceImageView;
@property (nonatomic, readwrite, retain) BDFaceRemindView * remindView;
@property (nonatomic, readwrite, retain) UILabel * remindDetailLabel;

// 超时相关控件
@property (nonatomic, readwrite, retain) UIView *timeOutMainView;
@property (nonatomic, readwrite, retain) UIImageView *timeOutImageView;
@property (nonatomic, readwrite, retain) UILabel *timeOutLabel;
@property (nonatomic, readwrite, retain) UIView *timeOutLine;
@property (nonatomic, readwrite, retain) UIButton *timeOutRestartButton;
@property (nonatomic, readwrite, retain) UILabel *timeOutRestartLabel;
@property (nonatomic, readwrite, retain) UIView *timeOutLine2;
@property (nonatomic, readwrite, retain) UIButton *timeOutRestartButton2;
@property (nonatomic, readwrite, retain) UILabel *timeOutBackToMainLabel2;


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
        NSArray *tempArr = [self getActionSequence];
        [BDFaceLivingConfigModel.sharedInstance resetState];
        for (int i = 0; i < self.maxDetectionTimes; i++) {
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:tempArr[i]];
        }
        BDFaceLivingConfigModel.sharedInstance.isByOrder = YES;
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness = self.maxDetectionTimes;
        BDFaceLivingConfigModel* model = [BDFaceLivingConfigModel sharedInstance];
        [self livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setHasFinished:(BOOL)hasFinished {
    _hasFinished = hasFinished;
    if (hasFinished) {
        [self.videoCapture stopSession];
        self.videoCapture.delegate = nil;
    }
}

- (void)warningStatus:(WarningStatus)status warning:(NSString *)warning
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == PoseStatus) {
            [weakSelf.remindLabel setHidden:false];
            [weakSelf.remindView setHidden:false];
            [weakSelf.remindDetailLabel setHidden:false];
            weakSelf.remindDetailLabel.text = warning;
            weakSelf.remindLabel.text = @"请保持正脸";
        }else if (status == occlusionStatus) {
            [weakSelf.remindLabel setHidden:false];
            [weakSelf.remindView setHidden:true];
            [weakSelf.remindDetailLabel setHidden:false];
            weakSelf.remindDetailLabel.text = warning;
            weakSelf.remindLabel.text = @"脸部有遮挡";
        }else {
            [weakSelf.remindLabel setHidden:false];
            [weakSelf.remindView setHidden:true];
            [weakSelf.remindDetailLabel setHidden:true];
            weakSelf.remindLabel.text = warning;
        }
    });
}

- (void)singleActionSuccess:(BOOL)success
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success) {
            
        }else {
            
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.navigationBar.hidden = YES;
    // 用于播放视频流
    if (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max) {
        self.previewRect = CGRectMake(ScreenWidth*(1-scaleValueX)/2.0, ScreenHeight*(1-scaleValueX)/2.0, ScreenWidth*scaleValueX, ScreenHeight*scaleValueX);
    } else {
        self.previewRect = CGRectMake(ScreenWidth*(1-scaleValue)/2.0, ScreenHeight*(1-scaleValue)/2.0, ScreenWidth*scaleValue, ScreenHeight*scaleValue);
    }
    self.previewRect = self.view.bounds;
    // 超时的view初始化，但是不添加到当前view内
    // 超时的最底层view，大小和屏幕大小一致，为了突出弹窗的view的效果，背景为灰色，0.7的透视度
    _timeOutMainView = [[UIView alloc] init];
    _timeOutMainView.frame = ScreenRect;
    _timeOutMainView.alpha = 0.7;
    _timeOutMainView.backgroundColor = [UIColor grayColor];
    
    // 弹出的主体view
    self.timeOutView = [[UIView alloc] init];
    self.timeOutView.frame = CGRectMake(KScaleX(20), KScaleY(179.3), ScreenWidth-KScaleX(40), KScaleY(281.3));
    self.timeOutView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];
    self.timeOutView.layer.cornerRadius = 7.5;

    // 超时的image
    _timeOutImageView = [[UIImageView alloc] init];
    _timeOutImageView.frame = CGRectMake((ScreenWidth-76) / 2, KScaleY(217.3), 76, 76);
    _timeOutImageView.image = [UIImage imageNamed:@"icon_overtime"];
    
    // 超时的label
    _timeOutLabel = [[UILabel alloc] init];
    _timeOutLabel.frame = CGRectMake(KScaleX(40), KScaleY(309.3), ScreenWidth-KScaleX(80), 22);
    _timeOutLabel.text = @"人脸采集超时";
    _timeOutLabel.textAlignment = NSTextAlignmentCenter;
    _timeOutLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _timeOutLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    
    // 区分线
    _timeOutLine = [[UIView alloc] init];
    _timeOutLine.frame = CGRectMake((ScreenWidth-320) / 2, 361.2, 320, 0.3);
    _timeOutLine.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];

    
    // 重新开始采集button
    _timeOutRestartButton = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-320)/2, KScaleY(376), 320, 18)];
    [_timeOutRestartButton addTarget:self action:@selector(reStart:) forControlEvents:UIControlEventTouchUpInside];
    
    // 重新采集的文字label
    _timeOutRestartLabel = [[UILabel alloc] init];
    _timeOutRestartLabel.frame = CGRectMake((ScreenWidth-72) / 2, KScaleY(376.3), 72, 18);
    _timeOutRestartLabel.text = @"重新采集";
    _timeOutRestartLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _timeOutRestartLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:186 / 255.0 blue:242 / 255.0 alpha:1 / 1.0];
    
    // 区分线
    _timeOutLine2 = [[UIView alloc] init];
    _timeOutLine2.frame = CGRectMake((ScreenWidth-320) / 2, 409.2, 320, 0.3);
    _timeOutLine2.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];

    
    // 回到首页的button
    _timeOutRestartButton2 = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-320)/2, KScaleY(424), 320, 18)];
    [_timeOutRestartButton2 addTarget:self action:@selector(backToPreView:) forControlEvents:UIControlEventTouchUpInside];
    
    // 回到首页的label
    _timeOutBackToMainLabel2 = [[UILabel alloc] init];
    _timeOutBackToMainLabel2.frame = CGRectMake((ScreenWidth-72) / 2, KScaleY(424.3), 72, 18);
    _timeOutBackToMainLabel2.text = @"回到首页";
    _timeOutBackToMainLabel2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _timeOutBackToMainLabel2.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1 / 1.0];
    
    // 初始化相机处理类
    self.videoCapture = [[BDFaceVideoCaptureDevice alloc] init];
    self.videoCapture.delegate = self;
    
    // 用于展示视频流的imageview
    self.displayImageView = [[UIImageView alloc] initWithFrame:self.previewRect];
    self.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.displayImageView];
    
    CGRect circleRect =CGRectMake(SCREENW*0.1 , SCREENH*0.2, SCREENW*0.8, SCREENH*0.8);
    
    // 画圈和圆形遮罩
    self.detectRect = CGRectMake(circleRect.origin.x , circleRect.origin.y, circleRect.size.width, circleRect.size.height);
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(circleRect), CGRectGetMidY(circleRect));
    //创建一个View
    UIView *maskView = [[UIView alloc] initWithFrame:ScreenRect];
    maskView.backgroundColor = [UIColor whiteColor];
    maskView.alpha = 1;
    [self.view addSubview:maskView];
    //贝塞尔曲线 画一个带有圆角的矩形
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:ScreenRect cornerRadius:0];
    //贝塞尔曲线 画一个圆形
    [bpath appendPath:[UIBezierPath bezierPathWithArcCenter:centerPoint radius:ScreenWidth*scaleValue / 2 startAngle:0 endAngle:2 * M_PI clockwise:NO]];
    //创建一个CAShapeLayer 图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    // 添加图层蒙板
    maskView.layer.mask = shapeLayer;
    
    maskView.hidden = YES;
    
    UIImageView *faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-SCREENW*0.2, SCREENH*0.3, SCREENW*1.4, SCREENH*0.5)];
    [self.view addSubview:faceImageView];
    faceImageView.image = [UIImage imageNamed:@"Image.bundle/FaceFrame.png"];
    
    
    // 进度条view，活体检测页面
    CGRect circleProgressRect =  CGRectMake(CGRectGetMinX(circleRect) - 13.7, CGRectGetMinY(circleRect) - 13.7, CGRectGetWidth(circleRect) + (13.7 * 2), CGRectGetHeight(circleRect) + (13.7 * 2));
    self.circleProgressView = [[BDFaceCycleProgressView alloc] initWithFrame:circleProgressRect];
    self.circleProgressView.hidden = YES;
    // 动作活体动画
    self.remindAnimationView = [[BDFaceRemindAnimationView alloc] initWithFrame:circleRect];
    
    
    // 提示框（动作）
    self.remindLabel = [[UILabel alloc] init];
    self.remindLabel.frame = CGRectMake(0, 103.3, ScreenWidth, 22);
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    self.remindLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    self.remindLabel.font = [UIFont boldSystemFontOfSize:22];
    [self.view addSubview:self.remindLabel];
    
    // 提示label（遮挡等问题）
    self.remindDetailLabel = [[UILabel alloc] init];
    self.remindDetailLabel.frame = CGRectMake(0, 139.3, ScreenWidth, 16);
    self.remindDetailLabel.font = [UIFont systemFontOfSize:16];
    self.remindDetailLabel.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1 / 1.0];
    self.remindDetailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.remindDetailLabel];
    [self.remindDetailLabel setHidden:true];
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(23.3, 43.3, 20, 20);
    [backButton setImage:[UIImage imageNamed:@"icon_titlebar_close"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeActionX) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 音量imageView，可动态播放图片
    _voiceImageView = [[UIImageView alloc] init];
    _voiceImageView.frame = CGRectMake((ScreenWidth-22-20), 42.7, 22, 22);
    _voiceImageView.animationImages = [NSArray arrayWithObjects:
                                       [UIImage imageNamed:@"icon_titlebar_voice1"],
                                       [UIImage imageNamed:@"icon_titlebar_voice2"], nil];
    _voiceImageView.animationDuration = 2;
    _voiceImageView.animationRepeatCount = 0;
    NSNumber *soundMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"SoundMode"];
    if (soundMode.boolValue){
        [_voiceImageView startAnimating];
    } else {
        _voiceImageView.image = [UIImage imageNamed:@"icon_titlebar_voice_close"];
    }
    _voiceImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *changeVoidceSet = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeVoidceSet:)];
    [_voiceImageView addGestureRecognizer:changeVoidceSet];
    [self.view addSubview:_voiceImageView];
    
    // 底部logo部分
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 221, ScreenWidth, 221);
    logoImageView.image = [UIImage imageNamed:@"bg_bottom_pattern"];
    [self.view addSubview:logoImageView];
    
    // 设置logo，底部的位置和大小，实例化显示
    BDFaceLogoView* logoView = [[BDFaceLogoView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-15-12), ScreenWidth, 12)];
    [self.view addSubview:logoView];
    logoView.hidden = YES;
    
    // 监听重新返回APP
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignAction) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.circleProgressView.lineBgColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1 / 1.0];
    // 刻度线进度颜色
    self.circleProgressView.scaleColor =  [UIColor colorWithRed:0 / 255.0 green:186 / 255.0 blue:242 / 255.0 alpha:1 / 1.0];
    [self.view addSubview:self.circleProgressView];
    
    // 提示动画设置
    [self.view addSubview:self.remindAnimationView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf.remindAnimationView setActionImages];
    });
    
    /*
     调试需要时可以打开以下注释
     
     蓝色框：检测框（视频流返回的位置）
     黄色框：采集框（人脸在采集框中都可以被识别，为了容错设置的宽松了一点）
     圆框：采集显示框（人脸应该放置的检测位置）
     绿色框：人脸最小框（通过最小框判定人脸是否过远，按照黄色框百分比：0.4宽）
     
//    UIImageView* circleImage= [[UIImageView alloc]init];
//    circleImage = [self creatRectangle:circleImage withRect:circleRect withcolor:[UIColor redColor]];
//    [self.view addSubview:circleImage];
//
//    UIImageView* previewImage= [[UIImageView alloc]init];
//    previewImage = [self creatRectangle:previewImage withRect:self.previewRect withcolor:[UIColor yellowColor]];
//    [self.view addSubview:previewImage];
//
//    UIImageView* detectImage= [[UIImageView alloc]init];
//    detectImage = [self creatRectangle:detectImage withRect:self.detectRect withcolor:[UIColor blueColor]];
//    [self.view addSubview:detectImage];
//
//    CGRect _minRect = CGRectMake(CGRectGetMinX(self.detectRect)+CGRectGetWidth(self.detectRect)*(1-[[FaceSDKManager sharedInstance] minRectScale])/2, CGRectGetMinY(self.detectRect)+CGRectGetWidth(self.detectRect)*(1-[[FaceSDKManager sharedInstance] minRectScale])/2, CGRectGetWidth(self.detectRect)*[[FaceSDKManager sharedInstance] minRectScale], CGRectGetWidth(self.detectRect)*[[FaceSDKManager sharedInstance] minRectScale]);
//    UIImageView* minImage= [[UIImageView alloc]init];
//    minImage = [self creatRectangle:minImage withRect:_minRect withcolor:[UIColor greenColor]];
//    [self.view addSubview:minImage];
     */
}
#pragma mark-绘框方法
- (UIImageView *)creatRectangle:(UIImageView *)imageView withRect:(CGRect) rect withcolor:(UIColor *)color{
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    //创建需要画线的视图
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    //起点
    float x = rect.origin.x;
    float y = rect.origin.y;
    float W = rect.size.width;
    float H = rect.size.height;
    [linePath moveToPoint:CGPointMake(x, y)];
    //其他点
    [linePath addLineToPoint:CGPointMake(x + W, y)];
    [linePath addLineToPoint:CGPointMake(x + W, y + H)];
    [linePath addLineToPoint:CGPointMake(x, y + H)];
    [linePath addLineToPoint:CGPointMake(x, y)];
    lineLayer.lineWidth = 2;
    lineLayer.strokeColor = color.CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    imageView.layer.sublayers = nil;
    [imageView.layer addSublayer:lineLayer];
    return imageView;
}
- (void)isTimeOut:(BOOL)isOrNot {
    if (isOrNot){
        // 加载超时的view
        [self outTimeViewLoad];
    }
}

- (void)outTimeViewLoad{
    
    // 显示超时view，并停止视频流工作
    self.remindLabel.text = @"";
    self.remindDetailLabel.text = @"";
    self.videoCapture.runningStatus = NO;
    [self.videoCapture stopSession];
    [self.view addSubview:_timeOutMainView];
    [self.view addSubview:_timeOutView];
    [self.view addSubview:_timeOutImageView];
    [self.view addSubview:_timeOutLabel];
    [self.view addSubview:_timeOutRestartButton];
    [self.view addSubview:_timeOutLine];
    [self.view addSubview:_timeOutRestartLabel];
    [self.view addSubview:_timeOutLine2];
    [self.view addSubview:_timeOutRestartButton2];
    [self.view addSubview:_timeOutBackToMainLabel2];
}

- (void)outTimeViewUnload{
    
    // 关闭超时的view，恢复视频流工作
    self.videoCapture.runningStatus = YES;
    [self.videoCapture startSession];
    [_timeOutMainView removeFromSuperview];
    [_timeOutView removeFromSuperview];
    [_timeOutImageView removeFromSuperview];
    [_timeOutLabel removeFromSuperview];
    [_timeOutRestartButton removeFromSuperview];
    [_timeOutLine removeFromSuperview];
    [_timeOutRestartLabel removeFromSuperview];
    [_timeOutLine2 removeFromSuperview];
    [_timeOutBackToMainLabel2 removeFromSuperview];
    [_timeOutRestartButton2 removeFromSuperview];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.hasFinished = YES;
    self.videoCapture.runningStatus = NO;
    [IDLFaceLivenessManager.sharedInstance reset];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _hasFinished = NO;
    self.videoCapture.runningStatus = YES;
    [self.videoCapture startSession];
    [[IDLFaceLivenessManager sharedInstance] startInitial];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeAction {
    _hasFinished = YES;
    self.videoCapture.runningStatus = NO;
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeActionX{
    _hasFinished = YES;
    self.videoCapture.runningStatus = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ButtonFunction
- (IBAction)reStart:(UIButton *)sender{
    // 对应页面去补充
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf outTimeViewUnload];
    });
    // 调用相应的部分设置
    [self selfReplayFunction];
    
}


- (IBAction)backToPreView:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification

- (void)onAppWillResignAction {
    _hasFinished = YES;
    [IDLFaceLivenessManager.sharedInstance reset];
}

- (void)onAppBecomeActive {
    _hasFinished = NO;
    [[IDLFaceLivenessManager sharedInstance] livenesswithList:_livenessArray order:_order numberOfLiveness:_numberOfLiveness];
}

- (void)livenesswithList:(NSArray *)livenessArray order:(BOOL)order numberOfLiveness:(NSInteger)numberOfLiveness {
    _livenessArray = [NSArray arrayWithArray:livenessArray];
    _order = order;
    _numberOfLiveness = numberOfLiveness;
    [[IDLFaceLivenessManager sharedInstance] livenesswithList:livenessArray order:order numberOfLiveness:numberOfLiveness];
}

- (void)faceProcesss:(UIImage *)image {
    if (self.hasFinished) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.isAnimating = [weakSelf.remindAnimationView isActionAnimating];
    });
    /*
     显示提示动画的过程中还可以做动作
     */
//    if (self.isAnimating){
//        return;
//    }
    
    
    [[IDLFaceLivenessManager sharedInstance] livenessNormalWithImage:image previewRect:self.previewRect detectRect:self.detectRect completionHandler:^(NSDictionary *images, FaceInfo *faceInfo, LivenessRemindCode remindCode) {
//        NSLog(@"remindCode = %lu", (unsigned long)remindCode);
/*
 此注释里的代码用于显示人脸框，调试过程中需要显示人脸款可打开注释
 
 //        绘制人脸框功能，开发者可以通过观察人脸框_faceRectFit 在  previewRect 包含关系判断是框内还是框外
         dispatch_async(dispatch_get_main_queue(), ^{
             CGRect faceRect = [BDFaceQualityUtil getFaceRect:faceInfo.landMarks withCount:faceInfo.landMarks.count];
             CGRect faceRectFit = [BDFaceUtil convertRectFrom:faceRect image:image previewRect:previewRect];
             if (!isPaint) {
                 newImage= [[UIImageView alloc]init];
                 [self.view addSubview:newImage];
                 isPaint = !isPaint;
             }
             newImage = [self creatRectangle:newImage withRect:faceRectFit  withcolor:[UIColor blackColor]];
         });
 
 */
        switch (remindCode) {
            case LivenessRemindCodeOK: {
                weakSelf.hasFinished = YES;
                [weakSelf warningStatus:CommonStatus warning:@"非常好"];
                if (images[@"image"] != nil && [images[@"image"] count] != 0) {
                    
                    NSArray *imageArr = images[@"image"];
                    for (FaceCropImageInfo * image in imageArr) {
                        NSLog(@"cropImageWithBlack %f %f", image.cropImageWithBlack.size.height, image.cropImageWithBlack.size.width);
                        NSLog(@"originalImage %f %f", image.originalImage.size.height, image.originalImage.size.width);
                    }

                    FaceCropImageInfo * bestImage = imageArr[0];
                    [[BDFaceImageShow sharedInstance] setSuccessImage:bestImage.originalImage];
                    [[BDFaceImageShow sharedInstance] setSilentliveScore:bestImage.silentliveScore];
                    [weakSelf onDetectSuccessWithImages:bestImage.originalImage];
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        UIViewController* fatherViewController = weakSelf.presentingViewController;
//                        [weakSelf dismissViewControllerAnimated:YES completion:^{
////                            BDFaceSuccessViewController *avc = [[BDFaceSuccessViewController alloc] init];
////                            avc.modalPresentationStyle = UIModalPresentationFullScreen;
////                            [fatherViewController presentViewController:avc animated:YES completion:nil];
//                            [self closeAction];
//                        }];
                        [weakSelf closeAction];
                    });
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.remindAnimationView stopActionAnimating];
                });
                
                [weakSelf singleActionSuccess:true];
                [BDFaceLog makeLogAfterFinishRecognizeAction:YES];
                break;
            }
            case LivenessRemindCodePitchOutofDownRange:
                [weakSelf warningStatus:PoseStatus warning:@"请略微抬头" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodePitchOutofUpRange:
                [weakSelf warningStatus:PoseStatus warning:@"请略微低头" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeYawOutofRightRange:
                [weakSelf warningStatus:PoseStatus warning:@"请略微向右转头" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeYawOutofLeftRange:
                [weakSelf warningStatus:PoseStatus warning:@"请略微向左转头" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodePoorIllumination:
                [weakSelf warningStatus:CommonStatus warning:@"请使环境光线再亮些" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeNoFaceDetected:
                [weakSelf warningStatus:CommonStatus warning:@"把脸移入框内" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeImageBlured:
                [weakSelf warningStatus:PoseStatus warning:@"请握稳手机" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionLeftEye:
                [weakSelf warningStatus:occlusionStatus warning:@"左眼有遮挡" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionRightEye:
                [weakSelf warningStatus:occlusionStatus warning:@"右眼有遮挡" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionNose:
                [weakSelf warningStatus:occlusionStatus warning:@"鼻子有遮挡" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionMouth:
                [weakSelf warningStatus:occlusionStatus warning:@"嘴巴有遮挡" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionLeftContour:
                [weakSelf warningStatus:occlusionStatus warning:@"左脸颊有遮挡" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionRightContour:
                [weakSelf warningStatus:occlusionStatus warning:@"右脸颊有遮挡" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionChinCoutour:
                [weakSelf warningStatus:occlusionStatus warning:@"下颚有遮挡" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeLeftEyeClosed:
                [weakSelf warningStatus:occlusionStatus warning:@"左眼未睁开" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeRightEyeClosed:
                [weakSelf warningStatus:occlusionStatus warning:@"右眼未睁开" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeTooClose:
                [weakSelf warningStatus:CommonStatus warning:@"请将脸部离远一点" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeTooFar:
                [weakSelf warningStatus:CommonStatus warning:@"请将脸部靠近一点" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeBeyondPreviewFrame:
                [weakSelf warningStatus:CommonStatus warning:@"把脸移入框内" conditionMeet:false];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeLiveEye:
                [weakSelf warningStatus:CommonStatus warning:@"眨眨眼" conditionMeet:true];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeLiveMouth:
                [weakSelf warningStatus:CommonStatus warning:@"张张嘴" conditionMeet:true];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeLiveYawRight:
                [weakSelf warningStatus:CommonStatus warning:@"向右缓慢转头" conditionMeet:true];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeLiveYawLeft:
                [weakSelf warningStatus:CommonStatus warning:@"向左缓慢转头" conditionMeet:true];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeLivePitchUp:
                [weakSelf warningStatus:CommonStatus warning:@"缓慢抬头" conditionMeet:true];
                [weakSelf singleActionSuccess:false];
                break;
            case LivenessRemindCodeLivePitchDown:
                [weakSelf warningStatus:CommonStatus warning:@"缓慢低头" conditionMeet:true];
                [weakSelf singleActionSuccess:false];
                break;
//            case LivenessRemindCodeLiveYaw:
//                [self warningStatus:CommonStatus warning:@"左右摇头" conditionMeet:true];
//                [self singleActionSuccess:false];
//                break;
            case LivenessRemindCodeSingleLivenessFinished:
            {
                [[IDLFaceLivenessManager sharedInstance] livenessProcessHandler:^(float numberOfLiveness, float numberOfSuccess, LivenessActionType currenActionType) {
                    NSLog(@"Finished 非常好 %d %d %d", (int)numberOfLiveness, (int)numberOfSuccess, (int)currenActionType);
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self.circleProgressView setPercent:(CGFloat)(numberOfSuccess / numberOfLiveness)];
                   });
                }];
                [weakSelf warningStatus:CommonStatus warning:@"非常好" conditionMeet:true];
                [weakSelf singleActionSuccess:true];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.remindAnimationView stopActionAnimating];
                });
            }
                break;
            case LivenessRemindCodeFaceIdChanged:
            {
                [[IDLFaceLivenessManager sharedInstance] livenessProcessHandler:^(float numberOfLiveness, float numberOfSuccess, LivenessActionType currenActionType) {
                    NSLog(@"face id changed %d %d %d", (int)numberOfLiveness, (int)numberOfSuccess, (int)currenActionType);
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [weakSelf.circleProgressView setPercent:0];
                   });
                }];
                [weakSelf warningStatus:CommonStatus warning:@"把脸移入框内" conditionMeet:true];
            }
                break;
            case LivenessRemindCodeVerifyInitError:
                [weakSelf warningStatus:CommonStatus warning:@"验证失败"];
                break;
//            case LivenessRemindCodeVerifyDecryptError:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
//            case LivenessRemindCodeVerifyInfoFormatError:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
//            case LivenessRemindCodeVerifyExpired:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
//            case LivenessRemindCodeVerifyMissRequiredInfo:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
//            case LivenessRemindCodeVerifyInfoCheckError:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
//            case LivenessRemindCodeVerifyLocalFileError:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
//            case LivenessRemindCodeVerifyRemoteDataError:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
            case LivenessRemindCodeTimeout: {
                // 时间超时，重置之前采集数据
                 [[IDLFaceLivenessManager sharedInstance] reset];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 时间超时，ui进度重置0
                    [weakSelf.circleProgressView setPercent:0];
                    [weakSelf isTimeOut:YES];
                });
                [BDFaceLog makeLogAfterFinishRecognizeAction:NO];
                break;
            }
            case LivenessRemindActionCodeTimeout:{
                [[IDLFaceLivenessManager sharedInstance] livenessProcessHandler:^(float numberOfLiveness, float numberOfSuccess, LivenessActionType currenActionType) {
                    NSLog(@"动作超时 %d %d %d", (int)numberOfLiveness, (int)numberOfSuccess, (int)currenActionType);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.remindAnimationView startActionAnimating:(int)currenActionType];
                    });
                }];
                [BDFaceLog makeLogAfterFinishRecognizeAction:NO];
                break;
            }
            case LivenessRemindCodeConditionMeet: {
            }
                break;
            default:
                break;
        }
    }];
}

- (void)selfReplayFunction{
     [[IDLFaceLivenessManager sharedInstance] reset];
     BDFaceLivingConfigModel* model = [BDFaceLivingConfigModel sharedInstance];
     [[IDLFaceLivenessManager sharedInstance] livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
}

- (void)warningStatus:(WarningStatus)status warning:(NSString *)warning conditionMeet:(BOOL)meet{
    [self warningStatus:status warning:warning];
}

#pragma mark - voiceImageView tap
- (void)changeVoidceSet:(UITapGestureRecognizer *)sender {
    NSNumber *soundMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"SoundMode"];
    NSLog(@"点击");
    if (soundMode.boolValue && _voiceImageView.animating) {
        [_voiceImageView stopAnimating];
        _voiceImageView.image = [UIImage imageNamed:@"icon_titlebar_voice_close"];
        // 之前是开启的，点击后关闭
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"SoundMode"];
        // 活体声音
        [IDLFaceLivenessManager sharedInstance].enableSound  = NO;
        // 图像采集声音
        [IDLFaceDetectionManager sharedInstance].enableSound = NO;
    } else {
        [_voiceImageView startAnimating];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"SoundMode"];
        // 活体声音
        [IDLFaceLivenessManager sharedInstance].enableSound  = YES;
        // 图像采集声音
        [IDLFaceDetectionManager sharedInstance].enableSound = YES;
    }
}

#pragma mark - CaptureDataOutputProtocol

- (void)captureOutputSampleBuffer:(UIImage *)image {
    if (_hasFinished) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.displayImageView.image = image;
    });
    [self faceProcesss:image];
}

- (void)captureError {
    NSString *errorStr = @"出现未知错误，请检查相机设置";
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        errorStr = @"相机权限受限,请在设置中启用";
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"知道啦");
        }];
        [alert addAction:action];
        UIViewController* fatherViewController = weakSelf.presentingViewController;
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [fatherViewController presentViewController:alert animated:YES completion:nil];
        }];
    });
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
    _hasFinished = NO;
    self.videoCapture.runningStatus = YES;
    self.videoCapture.delegate = self;
    [self.videoCapture startSession];
    [[IDLFaceLivenessManager sharedInstance] reset];
    BDFaceLivingConfigModel* model = [BDFaceLivingConfigModel sharedInstance];
    [[IDLFaceLivenessManager sharedInstance] livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
    
}

#endif
@end

