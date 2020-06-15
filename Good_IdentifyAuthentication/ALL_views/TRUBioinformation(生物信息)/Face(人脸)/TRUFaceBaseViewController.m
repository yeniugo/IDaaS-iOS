//
//  TRUFaceBaseViewController.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUFaceBaseViewController.h"
#import "TRUFaceGifView.h"
#import <objc/runtime.h>
#import "TRUMacros.h"
#import "STSilentLivenessCommon.h"
#import "UIView+STLayout.h"
#import "STStartAndStopIndicatorView.h"
//#import "TCSafe.h"
#import "TRUhttpManager.h"
#import "xindunsdk.h"
#import "TRUUserAPI.h"
//#define FcameraView CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
//#define usingRuntimeProcess NO
typedef NS_ENUM(NSUInteger, liveStatus) {
    liveStatusIdle = 0,
    liveStatusSucceed,
    liveStatusFaild,
};

typedef NSInteger FaceDetectionType;


@interface TRUFaceBaseViewController () <STSilentLivenessDetectorDelegate,
                                        AVCaptureVideoDataOutputSampleBufferDelegate>{
#if TARGET_IPHONE_SIMULATOR
#else
    NSMutableArray *_previousSecondTimestamps;
#endif
    
}
@property (nonatomic, strong) NSString *bundlePathStr;

//@property (nonatomic, weak) id<STSilentLivenessDetectorDelegate> detectorDelegate;

@property (nonatomic, strong) UIImageView *imageMaskView;

@property (nonatomic, strong) UIButton *promptButton;

@property (strong, nonatomic) NSOperationQueue *mainQueue;

@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *dataOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *deviceFront;

@property (nonatomic, assign) CGRect previewframe;
@property (nonatomic, assign) BOOL isCameraPermission;
@property (nonatomic, assign) CFAbsoluteTime lastUpdateTime;
@end

@implementation TRUFaceBaseViewController
#if TARGET_IPHONE_SIMULATOR
#else
- (instancetype)init {
    self = [super init];
    if (self) {
        {
            // 资源路径
            _bundlePathStr = [[NSBundle mainBundle] pathForResource:@"st_silent_liveness_resource" ofType:@"bundle"];
            // 获取模型路径
            NSString *modelPathStr =
            [NSString pathWithComponents:@[_bundlePathStr, @"model", @"SenseID_Composite_Silent_Liveness.model"]];
            // 获取授权文件路径
            NSString *financeLicensePathStr =
            [[NSBundle mainBundle] pathForResource:@"SenseID_Liveness_Silent" ofType:@"lic"];
            _detector = [[STSilentLivenessDetector alloc] initWithModelPath:modelPathStr
                                                         financeLicensePath:financeLicensePathStr
                                                                setDelegate:self];
            //设置静默活体检测的超时时间
            [_detector setTimeOutDuration:10.0];
            //设置静默活体通过条件
            [_detector setLivenessPasslimitTime:3 passFrames:4];
            //设置人脸远近判断条件
            [_detector setLivenessFaceTooFar:0.4 tooClose:0.8];
            
            _detector.isBrowOcclusion = NO;
        }
        
        _previousSecondTimestamps = [[NSMutableArray alloc] init];
        
        _previewframe = CGRectMake(0, 0, kSTScreenWidth, kSTScreenHeight);
        
        _mainQueue = [NSOperationQueue mainQueue];
        
        
        
        _isCameraPermission = NO;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(willResignActive)
//                                                     name:UIApplicationWillResignActiveNotification
//                                                   object:nil];
//        [self.navigationBar addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)startDetection {
    if (self.session && [self.session isRunning] && self.detector) {
        [self.detector startDetection];
    }
}


#pragma - mark -
#pragma - mark Life Cycle

- (void)loadView {
    [super loadView];
    [self setupUI];
    
    [self displayViewsIfRunning:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.hidden = NO;
#if !TARGET_IPHONE_SIMULATOR
    
    [self setupCaptureSession];
    
#endif
    TRUBaseNavigationController *nav = self.navigationController;
    nav.backBlock = ^{
        [self onBackButton];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [STStartAndStopIndicatorView sharedIndicatorStopAnimate];
    [self showHudWithText:@""];
    [self hideHudDelay:0.1];
    TRUBaseNavigationController *nav = self.navigationController;
    nav.backBlock = ^{
        [self onBackButton];
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.detector && self.session && self.dataOutput && ![self.session isRunning]) {
        [self.session startRunning];
    }
    [self cameraStart];
}

- (void)dealloc {
#if !TARGET_IPHONE_SIMULATOR
    
    if (_session) {
        [_session beginConfiguration];
        [_session removeOutput:_dataOutput];
        [_session removeInput:_deviceInput];
        [_session commitConfiguration];
        
        if ([_session isRunning]) {
            [_session stopRunning];
        }
        _session = nil; //! OCLINT
    }
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma - mark -
#pragma - mark Private Methods

//- (void)willResignActive {
//
//}

- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    self.imageMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSTScreenWidth, kSTScreenHeight)];
    self.imageMaskView.userInteractionEnabled = YES;
    self.imageMaskView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageMaskView];
//    self.navigationBar.hidden = NO;
    // ------NavBar
//    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//
//    CGFloat navigationBarHeight = 44;
//
//    UIView *navBarView =
//    [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSTScreenWidth, statusBarHeight + navigationBarHeight)];
//    navBarView.backgroundColor = kSTColorWithRGB(0x0A7FFB);
//
//    [self.imageMaskView addSubview:navBarView];
    
    // ------返回按钮
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setFrame:CGRectMake(15, CGRectGetMidY(navBarView.frame), 38, 38)];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
//    [backButton addTarget:self action:@selector(onBackButton) forControlEvents:UIControlEventTouchUpInside];
//    [navBarView addSubview:backButton];
    
    // ------提示文字
    self.promptButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, kSTScreenWidth, 70.0)];
    self.promptButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.promptButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [self.promptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.promptButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self showPromptButtonText:@"请将人脸置于屏幕中央保持不动" imageName:@"notice.png"];
    [self.imageMaskView addSubview:self.promptButton];
    
}

- (void)setupCaptureSession {
    self.session = [[AVCaptureSession alloc] init];
    
    // iPhone 4S, +
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer =
    [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    captureVideoPreviewLayer.frame = self.previewframe;
    
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [self.view.layer addSublayer:captureVideoPreviewLayer];
    [self.view bringSubviewToFront:self.imageMaskView];
    [self.view bringSubviewToFront:self.navigationController.navigationBar];
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            self.deviceFront = device;
        }
    }
    
    int frameRate;
    CMTime frameDuration = kCMTimeInvalid;
    frameRate = 30;
    frameDuration = CMTimeMake(1, frameRate);
    
    NSError *error = nil;
    if ([self.deviceFront lockForConfiguration:&error]) {
        self.deviceFront.activeVideoMaxFrameDuration = frameDuration;
        self.deviceFront.activeVideoMinFrameDuration = frameDuration;
        [self.deviceFront unlockForConfiguration];
    }
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.deviceFront error:&error];
    self.deviceInput = input;
    self.dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    [self.dataOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    [self.dataOutput
     setVideoSettings:@{(id) kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]}];
    
    dispatch_queue_t queueBuffer = dispatch_queue_create("LIVENESS_BUFFER_QUEUE", NULL);
    
    [self.dataOutput setSampleBufferDelegate:self queue:queueBuffer];
    
    [self.session beginConfiguration];
    
    if ([self.session canAddOutput:self.dataOutput]) {
        [self.session addOutput:self.dataOutput];
    }
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    [self.session commitConfiguration];
}

- (UIImage *)imageWithFullFileName:(NSString *)fileName {
    NSString *filePath = [NSString pathWithComponents:@[self.bundlePathStr, @"images", fileName]];
    
    return [UIImage imageWithContentsOfFile:filePath];
}

- (void)displayViewsIfRunning:(BOOL)isRunning {
    self.promptButton.hidden = !isRunning;
}

- (void)cameraStart {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice
             requestAccessForMediaType:AVMediaTypeVideo
             completionHandler:^(BOOL granted) {
                 if (granted) {
                     if (self.session && [self.session isRunning] && self.detector) {
                         [self.detector startDetection];
                     }
                     self.isCameraPermission = YES;
                 } else {
                     
                 }
             }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            if (self.session && [self.session isRunning] && self.detector) {
                [self.detector startDetection];
            }
            self.isCameraPermission = YES;
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted: {
            
            
            break;
        }
    }
}

#pragma - mark -
#pragma - mark Event Response

- (void)onBackButton {
    self.isCameraPermission = NO;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//
//        if ([self.session isRunning]) {
//            [self.session stopRunning];
//        }
//    });
    [self.detector cancelDetection];
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"faceviewBack" object:nil];
}


#pragma - mark -
#pragma - mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    CMTime timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    
    if (self.detector) {
        [self.detector trackAndDetectWithCMSampleBuffer:sampleBuffer
                                         faceOrientaion:STIDSilentLiveness_FACE_LEFT
                                           previewframe:self.previewframe
                                       videoOrientation:connection.videoOrientation
                                        isVideoMirrored:connection.isVideoMirrored];
    }
}

- (int)calculateFramerateAtTimestamp:(CMTime)timestamp {
    [_previousSecondTimestamps addObject:[NSValue valueWithCMTime:timestamp]];
    
    CMTime oneSecond = CMTimeMake(1, 1);
    CMTime oneSecondAgo = CMTimeSubtract(timestamp, oneSecond);
    
    while (CMTIME_COMPARE_INLINE([_previousSecondTimestamps[0] CMTimeValue], <, oneSecondAgo)) {
        [_previousSecondTimestamps removeObjectAtIndex:0];
    }
    
    if ([_previousSecondTimestamps count] > 1) {
        const Float64 duration = CMTimeGetSeconds(CMTimeSubtract([[_previousSecondTimestamps lastObject] CMTimeValue],
                                                                 [_previousSecondTimestamps[0] CMTimeValue]));
        const float newRate = (float) ([_previousSecondTimestamps count] - 1) / duration;
        return (int) roundf(newRate);
    }
    return 0;
}

//#pragma - mark -
//#pragma - mark STSilentLivenessDetectorDelegate

- (void)silentLivenessFaceRect:(CGRect)rect {
//    if (self.detectorDelegate && [self.detectorDelegate respondsToSelector:@selector(silentLivenessFaceRect:)]) {
//        [self.mainQueue addOperationWithBlock:^{
//            [self.detectorDelegate silentLivenessFaceRect:rect];
//        }];
//    }
}


- (void)silentLivenessDidSuccessfulGetProtobufData:(NSData *)protobufData
                                            images:(NSArray *)imageArr
                                         faceRects:(NSArray *)faceRectArr {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [HAMLogOutputWindow printLog:@"人脸检测成功"];
    [self onDetectSuccessWithImages:imageArr];
//    [self onBackButton];
//    NSString *userid = [TRUUserAPI getUser].userId;
//    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
//    NSString *params = [xindunsdk encryptByUkey:userid ctx:nil signdata:nil isDeviceType:NO];
//    NSDictionary *paramsDic = @{@"params" : params};
//    [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/init/getfaceToken"] withParts:paramsDic onResult:^(int errorno, id responseBody) {
//        if (errorno==0 && responseBody!=nil) {
//            NSDictionary *dic = [xindunsdk decodeServerResponse:responseBody];
//            int code = [dic[@"code"] intValue];
//            if (code == 0) {
//                dic = dic[@"resp"];
//                NSString *token = dic[@"token"];
//                NSString *terimal = dic[@"terminalNo"];
//
//                NSString *sedPath = [[NSBundle mainBundle] pathForResource:@"public_demo_key.pem" ofType:nil];
//                int sedRet = -1;
//                sedRet = TC_loadEncryptSeed(sedPath);
//                if (sedRet>=0) {
//                    if (imageArr[0]) {
//                        STSilentLivenessImage *stImage = imageArr[0];
//                        UIImage *imagesrc = stImage.image;
//                        NSData *imgData = UIImageJPEGRepresentation(imagesrc, 1.0f);
//                        NSString *imgB64 = [imgData base64EncodedStringWithOptions:0];
//                        NSData *encData = TC_encryptData(imgB64, terimal, token);
//                        if (encData) {
//                            NSString *iosRet = [encData base64EncodedStringWithOptions:0];
//                            token = @"fafafasfafafasfadfadffa";
//                            NSString *userid = [TRUUserAPI getUser].userId;
//                            NSString *sign = [NSString stringWithFormat:@"%@%@%@",token,@"1",@"2"];
//                            NSArray *ctxx = @[@"token",token,@"confirm",@"1",@"wsType",@"2"];
//                            NSString *para = [xindunsdk requestOrverifyCIMSFaceForUser:userid faceData:encData ctx:ctxx signdata:sign isType:NO];
//                            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:para, @"params", nil];
//                            NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"CIMSURL"];
//                            [TRUhttpManager sendCIMSRequestWithUrl:[baseUrl stringByAppendingString:@"/mapi/01/verify/face"] withParts:dic onResult:^(int errorno1, id responseBody1) {
//                                if (errorno1==0) {
//
//                                }else{
//
//                                }
//                            }];
//
//                        }else
//                        {
//                            NSLog(@"加密失败！");
//                        }
//                    }
//
//                }else
//                {
//                    //Error
//                }
//            }
//
//        }else{
//
//        }
//    }];
    
    
    
    
//    if (self.detectorDelegate &&
//        [self.detectorDelegate
//         respondsToSelector:@selector(silentLivenessDidSuccessfulGetProtobufData:images:faceRects:)]) {
//            [self.mainQueue addOperationWithBlock:^{
//                [self.detectorDelegate silentLivenessDidSuccessfulGetProtobufData:protobufData
//                                                                           images:imageArr
//                                                                        faceRects:faceRectArr];
//            }];
//        }
}

- (void)silentLivenessDidFailWithLivenessResult:(STIDSilentLivenessResult)livenessResult
                                      faceError:(STIDSilentLivenessFaceError)faceError
                                   protobufData:(NSData *)protobufData
                                         images:(NSArray *)imageArr
                                      faceRects:(NSArray *)faceRectArr {
    [self displayViewsIfRunning:NO];
    __weak typeof(self) weakSelf = self;
//    [self showViewsWithliveStatus:liveStatusFaild];
    
    switch (livenessResult) {
        case STIDSilentLiveness_E_LICENSE_INVALID: {
//            self.messageLabel.text = @"未通过授权验证";
            [self showHudWithText:@"未通过授权验证"];
            [self hideHudDelay:2.0f];
            break;
        }
        case STIDSilentLiveness_E_LICENSE_FILE_NOT_FOUND: {
//            self.messageLabel.text = @"授权文件不存在";
            [self showHudWithText:@"授权文件不存在"];
            [self hideHudDelay:2.0f];
            break;
        }
        case STIDSilentLiveness_E_LICENSE_BUNDLE_ID_INVALID: {
//            self.messageLabel.text = @"绑定包名错误";
            [self showHudWithText:@"绑定包名错误"];
            [self hideHudDelay:2.0f];
            break;
        }
        case STIDSilentLiveness_E_LICENSE_EXPIRE: {
//            self.messageLabel.text = @"授权文件过期";
            [self showHudWithText:@"授权文件过期"];
            [self hideHudDelay:2.0f];
            break;
        }
            
        case STIDSilentLiveness_E_LICENSE_VERSION_MISMATCH: {
//            self.messageLabel.text = @"License与SDK版本不匹";
            [self showHudWithText:@"License与SDK版本不匹"];
            [self hideHudDelay:2.0f];
            break;
        }
            
        case STIDSilentLiveness_E_LICENSE_PLATFORM_NOT_SUPPORTED: {
//            self.messageLabel.text = @"License不支持当前平台";
            [self showHudWithText:@"License不支持当前平台"];
            [self hideHudDelay:2.0f];
            break;
        }
            
        case STIDSilentLiveness_E_MODEL_INVALID: {
//            self.messageLabel.text = @"模型文件错误";
            [self showHudWithText:@"模型文件错误"];
            [self hideHudDelay:2.0f];
            break;
        }
        case STIDSilentLiveness_E_MODEL_FILE_NOT_FOUND: {
//            self.messageLabel.text = @"模型文件不存在";
            [self showHudWithText:@"模型文件不存在"];
            [self hideHudDelay:2.0f];
            break;
        }
        case STIDSilentLiveness_E_MODEL_EXPIRE: {
//            self.messageLabel.text = @"模型文件过期";
            [self showHudWithText:@"模型文件过期"];
            [self hideHudDelay:2.0f];
            break;
        }
        case STIDSilentLiveness_E_INVALID_ARGUMENT: {
//            self.messageLabel.text = @"参数设置不合法";
            [self showHudWithText:@"参数设置不合法"];
            [self hideHudDelay:2.0f];
            break;
        }
        case STIDSilentLiveness_E_CALL_API_IN_WRONG_STATE: {
//            self.messageLabel.text = @"错误的方法状态调用";
            [self showHudWithText:@"错误的方法状态调用"];
            [self hideHudDelay:2.0f];
            break;
        }
        case STIDSilentLiveness_E_FAILED: {
            if (faceError == STIDSilentLiveness_E_HACK) {
//                self.messageLabel.text = @"未通过活体检测";
                [self showHudWithText:@"未通过活体检测"];
                [self hideHudDelay:2.0f];
                [self showConfrimCancelDialogViewWithTitle:@"" msg:@"人脸检测失败" confrimTitle:@"重试" cancelTitle:@"取消" confirmRight:YES confrimBolck:^{
                    [self restartDetection];
                } cancelBlock:^{
                    [weakSelf onBackButton];
                }];
            }
            break;
        }
        default:
            break;
    }
//    if (self.detectorDelegate &&
//        [self.detectorDelegate respondsToSelector:@selector
//         (silentLivenessDidFailWithLivenessResult:faceError:protobufData:images:faceRects:)]) {
//            [self.mainQueue addOperationWithBlock:^{
//                [self.detectorDelegate silentLivenessDidFailWithLivenessResult:livenessResult
//                                                                     faceError:faceError
//                                                                  protobufData:protobufData
//                                                                        images:imageArr
//                                                                     faceRects:faceRectArr];
//            }];
//        }
}

- (void)onDetectSuccessWithImages:(NSArray *)images{
    YCLog(@"人脸检测成功");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"faceviewBack" object:nil];
}


- (void)silentLivenessDidCancel {
    [self displayViewsIfRunning:NO];
//    if (self.detectorDelegate && [self.detectorDelegate respondsToSelector:@selector(silentLivenessDidCancel)]) {
//        [self.mainQueue addOperationWithBlock:^{
//            [self.detectorDelegate silentLivenessDidCancel];
//        }];
//    }
}

- (void)silentLivenessDistanceStatus:(STIDSilentLivenessFaceDistanceStatus)distanceStatus
                         boundStatus:(STIDSilentLivenessFaceBoundStatus)boundStatus
                          silentFace:(STSilentLivenessFace *)silentFace {
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent() * 1000;
    
    if ((currentTime - self.lastUpdateTime) > 300) {
        if (silentFace.isFaceOcclusion) {
            [self showPromptButtonText:[self faceOcclusionStringWithFaceModel:silentFace] imageName:@"notice.png"];
        } else if (distanceStatus == STIDSilentLiveness_FACE_TOO_FAR) {
            [self showPromptButtonText:@"请移动手机靠近面部" imageName:@"far away.png"];
        } else if (distanceStatus == STIDSilentLiveness_FACE_TOO_CLOSE) {
            [self showPromptButtonText:@"请移动手机远离面部" imageName:@"close to.png"];
        } else if (distanceStatus == STIDSilentLiveness_DISTANCE_FACE_NORMAL &&
                   boundStatus == STIDSilentLiveness_FACE_IN_BOUNDE) {
            [self showPromptButtonText:@"人脸验证中" imageName:@"detection.png"];
            
        } else {
            [self showPromptButtonText:@"请将人脸置于屏幕中央保持不动" imageName:@"notice.png"];
        }
        
        self.lastUpdateTime = CFAbsoluteTimeGetCurrent() * 1000;
    }
}

- (NSString *)faceOcclusionStringWithFaceModel:(STSilentLivenessFace *)face {
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    
    if (face.browOcclusionStatus == STIDSilentLiveness_OCCLUSION) {
        [tempStr appendFormat:@"眉毛、"];
    }
    if (face.eyeOcclusionStatus == STIDSilentLiveness_OCCLUSION) {
        [tempStr appendFormat:@"眼部、"];
    }
    if (face.noseOcclusionStatus == STIDSilentLiveness_OCCLUSION) {
        [tempStr appendFormat:@"鼻部、"];
    }
    if (face.mouthOcclusionStatus == STIDSilentLiveness_OCCLUSION) {
        [tempStr appendFormat:@"嘴部"];
    }
    NSString *theLast = [tempStr substringFromIndex:[tempStr length] - 1];
    if ([theLast isEqualToString:@"、"]) {
        tempStr = (NSMutableString *) [tempStr substringToIndex:([tempStr length] - 1)];
    }
    return [NSString stringWithFormat:@"请正对手机，去除%@遮挡", tempStr];
}
- (void)showPromptButtonText:(NSString *)text imageName:(NSString *)imageName {
    [self.mainQueue addOperationWithBlock:^{
        [self.promptButton setTitle:text forState:UIControlStateNormal];
        [self.promptButton setImage:[self imageWithFullFileName:imageName] forState:UIControlStateNormal];
    }];
}

- (void)restartDetection{
    
    // 资源路径
    _bundlePathStr = [[NSBundle mainBundle] pathForResource:@"st_silent_liveness_resource" ofType:@"bundle"];
    // 获取模型路径
    NSString *modelPathStr =
    [NSString pathWithComponents:@[_bundlePathStr, @"model", @"SenseID_Composite_Silent_Liveness.model"]];
    // 获取授权文件路径
    NSString *financeLicensePathStr =
    [[NSBundle mainBundle] pathForResource:@"SenseID_Liveness_Silent" ofType:@"lic"];
    _detector = [[STSilentLivenessDetector alloc] initWithModelPath:modelPathStr
                                                 financeLicensePath:financeLicensePathStr
                                                        setDelegate:self];
    //设置静默活体检测的超时时间
    [_detector setTimeOutDuration:10.0];
    //设置静默活体通过条件
    [_detector setLivenessPasslimitTime:3 passFrames:4];
    //设置人脸远近判断条件
    [_detector setLivenessFaceTooFar:0.4 tooClose:0.8];
    
    _previousSecondTimestamps = [[NSMutableArray alloc] init];
    
    _previewframe = CGRectMake(0, 0, kSTScreenWidth, kSTScreenHeight);
    
    _mainQueue = [NSOperationQueue mainQueue];
    
    _isCameraPermission = NO;
    
    [self displayViewsIfRunning:YES];
    
    [STStartAndStopIndicatorView sharedIndicatorStopAnimate];
    
    [self setupCaptureSession];
    
    
    if (self.detector && self.session && self.dataOutput && ![self.session isRunning]) {
        [self.session startRunning];
    }
    [self cameraStart];
//    self.navigationBar.hidden = NO;
    
//    [self hideHudDelay:0.0];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSString *log = [NSString stringWithFormat:@"导航控制器隐藏属性变化了"];
    DDLogError(log);
//    if (self.navigationBar.hidden) {
//        self.navigationBar.hidden = NO;
//    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#endif


@end
