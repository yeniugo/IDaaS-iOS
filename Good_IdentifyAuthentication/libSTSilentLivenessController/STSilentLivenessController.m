//
//  STSilentLivenessController.m
//  STSilentLivenessController
//
//  Created by huoqiuliang on 16/8/15.
//  Copyright © 2016年 sensetime. All rights reserved.
//

#import "STSilentLivenessController.h"
#import "STSilentLivenessCommon.h"
#import "UIView+STLayout.h"
#import "STStartAndStopIndicatorView.h"

@interface STSilentLivenessController () <STSilentLivenessDetectorDelegate,
                                          AVCaptureVideoDataOutputSampleBufferDelegate> {
    NSMutableArray *_previousSecondTimestamps;
}

@property (nonatomic, strong) NSString *bundlePathStr;

@property (nonatomic, weak) id<STSilentLivenessControllerDelegate> controllerDelegate;

@property (nonatomic, weak) id<STSilentLivenessDetectorDelegate> detectorDelegate;

@property (nonatomic, strong) UIImageView *imageMaskView;

@property (strong, nonatomic) UIImage *imageMask;

@property (nonatomic, strong) UIButton *promptButton;

@property (strong, nonatomic) NSOperationQueue *mainQueue;

@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *dataOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *deviceFront;

@property (nonatomic, assign) CGRect previewframe;
@property (nonatomic, assign) BOOL isCameraPermission;
@property (assign, nonatomic) BOOL is3_5InchScreen;

@property (nonatomic, assign) CFAbsoluteTime lastUpdateTime;

@end

@implementation STSilentLivenessController

- (instancetype)init {
    NSLog(@" ╔—————————————————————— WARNING —————————————————————╗");
    NSLog(@" | [[STLivenessController alloc] init] is not allowed |");
    NSLog(@" |     Please use  \"initWithApiKey\" , thanks !    |");
    NSLog(@" ╚————————————————————————————————————————————————————╝");
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma - mark -
#pragma - mark Public method

- (instancetype)initWithSetDelegate:(id<STSilentLivenessDetectorDelegate, STSilentLivenessControllerDelegate>)delegate {
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
        }
        _mainQueue = [NSOperationQueue mainQueue];
        _previousSecondTimestamps = [[NSMutableArray alloc] init];

        _previewframe = CGRectMake(0, 0, kSTScreenWidth, kSTScreenHeight);

        double prepareCenterX = kSTScreenWidth / 2.0;
        double prepareCenterY = kSTScreenHeight / 2.0;
        double prepareRadius = kSTScreenWidth / 3;
        [_detector setPrepareCenterPoint:CGPointMake(prepareCenterX, prepareCenterY) prepareRadius:prepareRadius];

        if (_detectorDelegate != delegate) {
            _detectorDelegate = delegate;
            _controllerDelegate = delegate;
        }

        _isCameraPermission = NO;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willResignActive)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)startDetection {
    if (self.session && [self.session isRunning] && self.detector) {
        [self.detector startDetection];
    }
}
+ (NSString *)getVersion {
    return [STSilentLivenessDetector getVersion];
}

#pragma - mark -
#pragma - mark Life Cycle

- (void)loadView {
    [super loadView];

    self.is3_5InchScreen = (kSTScreenHeight == 480);

    [self setupUI];

    [self displayViewsIfRunning:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

#if !TARGET_IPHONE_SIMULATOR

    [self setupCaptureSession];
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [STStartAndStopIndicatorView sharedIndicatorStopAnimate];
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

- (void)willResignActive {
    if (self.controllerDelegate &&
        [self.controllerDelegate respondsToSelector:@selector(silentLivenessControllerDeveiceError:)] &&
        _isCameraPermission) {
        [self.mainQueue addOperationWithBlock:^{
            [self.controllerDelegate silentLivenessControllerDeveiceError:STIDSilentLiveness_WILL_RESIGN_ACTIVE];
        }];
    }
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];

    self.imageMask = [self imageWithFullFileName:self.is3_5InchScreen ? @"st_mask_s.png" : @"st_mask_b.png"];

    self.imageMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSTScreenWidth, kSTScreenHeight)];

    self.imageMaskView.image = self.imageMask;

    self.imageMaskView.userInteractionEnabled = YES;
    self.imageMaskView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageMaskView];

    // ------NavBar
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;

    CGFloat navigationBarHeight = 44;

    UIView *navBarView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSTScreenWidth, statusBarHeight + navigationBarHeight)];
    navBarView.backgroundColor = kSTColorWithRGB(0x0A7FFB);

    [self.imageMaskView addSubview:navBarView];

    // ------返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(15, CGRectGetMidY(navBarView.frame), 38, 38)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [backButton addTarget:self action:@selector(onBackButton) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:backButton];

    // ------提示文字
    self.promptButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kSTScreenHeight * 0.8, kSTScreenWidth, 70)];
    self.promptButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.promptButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [self.promptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.promptButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self showPromptButtonText:@"请将人脸移入框内" imageName:@"notice.png"];
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
                                if (self.controllerDelegate &&
                                    [self.controllerDelegate
                                        respondsToSelector:@selector(silentLivenessControllerDeveiceError:)]) {
                                    [self.mainQueue addOperationWithBlock:^{
                                        [self.controllerDelegate
                                            silentLivenessControllerDeveiceError:STIDSilentLiveness_E_CAMERA];
                                    }];
                                }
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
            if (self.controllerDelegate &&
                [self.controllerDelegate respondsToSelector:@selector(silentLivenessControllerDeveiceError:)]) {
                [self.mainQueue addOperationWithBlock:^{
                    [self.controllerDelegate silentLivenessControllerDeveiceError:STIDSilentLiveness_E_CAMERA];
                }];
            }

            break;
        }
    }
}

#pragma - mark -
#pragma - mark Event Response

- (void)onBackButton {
    self.isCameraPermission = NO;
    [self.detector cancelDetection];
}

#pragma - mark -
#pragma - mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
    didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
           fromConnection:(AVCaptureConnection *)connection {
    CMTime timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);

    if (self.detectorDelegate && [self.detectorDelegate respondsToSelector:@selector(silentLivenessVideoFrameRate:)]) {
        [self.detectorDelegate silentLivenessVideoFrameRate:[self calculateFramerateAtTimestamp:timestamp]];
    }
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

#pragma - mark -
#pragma - mark STSilentLivenessDetectorDelegate

- (void)silentLivenessFaceRect:(CGRect)rect {
    if (self.detectorDelegate && [self.detectorDelegate respondsToSelector:@selector(silentLivenessFaceRect:)]) {
        [self.mainQueue addOperationWithBlock:^{
            [self.detectorDelegate silentLivenessFaceRect:rect];
        }];
    }
}


- (void)silentLivenessDidSuccessfulGetProtobufData:(NSData *)protobufData
                                            images:(NSArray *)imageArr
                                         faceRects:(NSArray *)faceRectArr {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.detectorDelegate &&
        [self.detectorDelegate
            respondsToSelector:@selector(silentLivenessDidSuccessfulGetProtobufData:images:faceRects:)]) {
        [self.mainQueue addOperationWithBlock:^{
            [self.detectorDelegate silentLivenessDidSuccessfulGetProtobufData:protobufData
                                                                       images:imageArr
                                                                    faceRects:faceRectArr];
        }];
    }
}

- (void)silentLivenessDidFailWithLivenessResult:(STIDSilentLivenessResult)livenessResult
                                      faceError:(STIDSilentLivenessFaceError)faceError
                                   protobufData:(NSData *)protobufData
                                         images:(NSArray *)imageArr
                                      faceRects:(NSArray *)faceRectArr {
    [self displayViewsIfRunning:NO];

    if (self.detectorDelegate &&
        [self.detectorDelegate respondsToSelector:@selector
                               (silentLivenessDidFailWithLivenessResult:faceError:protobufData:images:faceRects:)]) {
        [self.mainQueue addOperationWithBlock:^{
            [self.detectorDelegate silentLivenessDidFailWithLivenessResult:livenessResult
                                                                 faceError:faceError
                                                              protobufData:protobufData
                                                                    images:imageArr
                                                                 faceRects:faceRectArr];
        }];
    }
}

- (void)silentLivenessDidCancel {
    [self displayViewsIfRunning:NO];
    if (self.detectorDelegate && [self.detectorDelegate respondsToSelector:@selector(silentLivenessDidCancel)]) {
        [self.mainQueue addOperationWithBlock:^{
            [self.detectorDelegate silentLivenessDidCancel];
        }];
    }
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
            [self showPromptButtonText:@"活体检测中" imageName:@"detection.png"];

        } else {
            [self showPromptButtonText:@"请将人脸移入框内" imageName:@"notice.png"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
