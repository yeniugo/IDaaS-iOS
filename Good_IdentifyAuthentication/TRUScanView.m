//
//  TRUScanView.m
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2016/12/13.
//  Copyright © 2016年 Trusfort. All rights reserved.
//

#import "TRUScanView.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface TRUScanView ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, weak) UIImageView *scanNetImageView;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, weak) AVCaptureMetadataOutput *output;
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *scanLayer;
//@property (nonatomic, assign) BOOL finshSacnQrCode;
@end

@implementation TRUScanView
#pragma mark lazy
- (AVCaptureSession *)session{
    if (!_session) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        [device setFocusMode:AVCaptureFocusModeAutoFocus];

        
        //创建输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if (!input) return nil;
        //创建输出流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        //设置代理 在主线程刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetPhoto];
        [_session addInput:input];
        [_session addOutput:output];
        
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        self.output = output;
        
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//        layer.contentsGravity = @"resizeAspectFill";
        layer.frame = [UIScreen mainScreen].bounds;
//        [layer setSession:_session];
        [self.layer insertSublayer:layer atIndex:0];
        self.scanLayer = layer;
        
    }
    return _session;
}
- (instancetype)initWithScanLine{
    if (self = [super init]) {
        [self setUPScanView];
        [self setUPSmallMaskView];
        [self addNoti];
//        self.finshSacnQrCode = NO;
    }
    return self;
}
- (void)addNoti{
    
//    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
//                                                      object:nil
//                                                       queue:[NSOperationQueue currentQueue]
//                                                  usingBlock: ^(NSNotification *_Nonnull note) {
//                                                      self.output.rectOfInterest = [self.scanLayer metadataOutputRectOfInterestForRect:self.scanView.frame];
//                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue currentQueue]
                                                  usingBlock: ^(NSNotification *_Nonnull note) {
                                                      self.output.rectOfInterest = [self.scanLayer metadataOutputRectOfInterestForRect:self.scanView.frame];
                                                  }];
    
    
}
- (void)setUPScanView{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *scanView = [[UIView alloc] init];
//    scanView.clipsToBounds = YES;
    [self addSubview:self.scanView = scanView];
    CGFloat wh = 258.0 * PointHeightRatio6;
    [scanView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(176.0 * PointHeightRatio6);
        make.width.height.equalTo(@(wh));
//        make.left.equalTo(self).offset(58.5);
//        make.right.equalTo(self).offset(-58.5);
//        make.height.equalTo(scanView.mas_width);
//        make.center.equalTo(self);
//        make.left.top.right.bottom.equalTo(self);
    }];
   
    
    for (int i = 1; i < 5; i ++) {
        NSString *imgName = [NSString stringWithFormat:@"scan_%d", i];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        [scanView addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.height.equalTo(@(19.0));
            if (1 == i) {
                make.left.top.equalTo(scanView);
            }else if (2 == i){
                make.right.top.equalTo(scanView);
            }else if (3 == i){
                make.left.bottom.equalTo(scanView);
            }else if (4 == i){
                make.right.bottom.equalTo(scanView);
            }
        }];
        
        
    }
    
    
    UIImageView *scanNetV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
    [scanView addSubview:self.scanNetImageView = scanNetV];
    [scanNetV mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(scanView);
        make.bottom.equalTo(scanView.mas_top);
        
    }];

    
    
}
- (void)setUPSmallMaskView{
    //maskview 不一定是正方形 所以需要用4个小的遮罩
    UIColor *maskColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    for (int i = 0; i < 4; i ++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = maskColor;
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make){
            if (0 == i) {//上
                make.left.top.right.equalTo(self);
                make.bottom.equalTo(self.scanView.mas_top);
            }else if (1 == i){//右
                make.left.equalTo(self.scanView.mas_right);
                make.right.equalTo(self);
                make.top.bottom.equalTo(self.scanView);
            }else if (2 == i){//下
                make.left.right.bottom.equalTo(self);
                make.top.equalTo(self.scanView.mas_bottom);
            }else if (3 == i){//左
                make.left.equalTo(self);
                make.right.equalTo(self.scanView.mas_left);
                make.top.bottom.equalTo(self.scanView);
            }
        }];
        
    }
}
- (void)beginScanning{
//    
//    if (self.session) {
//        [self.session startRunning];
//    }else{
//        //获取摄像设备
//        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        //创建输入流
//        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//        if (!input) return;
//        //创建输出流
//        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
//        //设置代理 在主线程刷新
//        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//        output.rectOfInterest = [self getScanCrop:self.scanView.frame readerViewBounds:self.maskView.bounds];
//        
//        AVCaptureSession *session = [[AVCaptureSession alloc] init];
//        [session setSessionPreset:AVCaptureSessionPresetHigh];
//        [session addInput:input];
//        [session addOutput:output];
//        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
//        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
//        layer.frame = self.layer.bounds;
//        
//        [self.layer insertSublayer:layer atIndex:0];
//        [session startRunning];
//        
//    }
//    self.finshSacnQrCode = NO;
    [self.session startRunning];
//    [self configvideoZoomFactor:1.f];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (self.finshSacnQrCode) return;
//        
//         [self configvideoZoomFactor:3.f];
//    });

}
//获取扫描区域
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
//    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect)) * 0.5 / CGRectGetHeight(readerViewBounds);
//    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect)) * 0.5 / CGRectGetWidth(readerViewBounds);
    x = rect.origin.y / CGRectGetHeight(readerViewBounds);
    y = rect.origin.x / CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect) / CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect) / CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
//        self.finshSacnQrCode = YES;
        [self.session stopRunning];
        [self stopAnimation];
        
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects lastObject];
        if (self.scanResultBlock) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            self.scanResultBlock(metadataObj.stringValue);
        }
    }
}
#pragma mark 恢复动画
- (void)resumeAnimation
{
    CAAnimation *anim = [self.scanNetImageView.layer animationForKey:@"translationAnimation"];
    if(anim){
        // 1. 将动画的时间偏移量作为暂停时的时间点
        CFTimeInterval pauseTime = _scanNetImageView.layer.timeOffset;
        // 2. 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        
        // 3. 要把偏移时间清零
        [self.scanNetImageView.layer setTimeOffset:0.0];
        // 4. 设置图层的开始动画时间
        [self.scanNetImageView.layer setBeginTime:beginTime];
        
        [self.scanNetImageView.layer setSpeed:1.0];
        
    }else{
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(258);
        scanNetAnimation.duration = 2.0;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [self.scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
    }
    

    
}
- (void)stopAnimation{
    [self.scanNetImageView.layer removeAllAnimations];
}
- (void)layoutSubviews{
    [super layoutSubviews];
//    AVCaptureMetadataOutput *output = self.session.outputs.firstObject;
////    output.rectOfInterest = [self getScanCrop:self.scanView.frame readerViewBounds:self.bounds];
//    output.rectOfInterest = CGRectMake(0.20, 0.23, 0.59, 0.53);
//    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer*)self.layer.sublayers.firstObject;
//    layer.frame = self.bounds;
    self.scanLayer.frame = self.frame;
}
- (void)stopScaning{
    [self.session stopRunning];
    [self stopAnimation];
}
- (void)configvideoZoomFactor:(CGFloat)zoomFactor{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device lockForConfiguration:nil]){
        device.videoZoomFactor = zoomFactor;
        [device unlockForConfiguration];
    }

}

@end
