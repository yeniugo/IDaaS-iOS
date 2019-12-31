//
//  STSilentLivenessDetector.h
//  STSilentLivenessDetector
//
//  Created by sluin on 15/12/4.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "STSilentLivenessDetectorDelegate.h"
#import "STSilentLivenessImage.h"

@interface STSilentLivenessDetector : NSObject

/**
 *  设置活体检测中是否进行眉毛的遮挡检测 , 不设置时默认为NO;
 */
@property (assign, nonatomic) BOOL isBrowOcclusion;

/**
 *  初始化方法
 *
 *  @param modelPathStr          模型资源 M_Finance_Composite_Silent_Liveness.model的路径
 *  @param financeLicensePathStr 授权文件 SenseID_Liveness_Silent.lic的路径.
 *  @param delegate              回调代理
 *  @return 静默活体检测器实例
 */

- (instancetype)initWithModelPath:(NSString *)modelPathStr
               financeLicensePath:(NSString *)financeLicensePathStr
                      setDelegate:(id<STSilentLivenessDetectorDelegate>)delegate;

/**
 *  人脸对准目标框
 *  @param point               人脸对准目标框（圆的）的的中心点的X和Y,默认值  CGPointMake([UIScreen
 * mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0)
 *  @param radius              人脸对准目标框（圆的）的半径，默认值 [UIScreen mainScreen].bounds.size.width/2.5;
 */
- (void)setPrepareCenterPoint:(CGPoint)point prepareRadius:(CGFloat)radius;

/**
 *  设置静默活体检测的超时时间,如果设置的值不合法时报错:STIDSilentLiveness_E_INVALID_ARGUMENT。
 *
 *  @param duration            每个模块允许的最大检测时间,等于0时为不设置超时时间,默认为10s,单位是s
 */

- (void)setTimeOutDuration:(NSTimeInterval)duration;

/**
 *  静默活体通过条件设置，如果设置的值不合法时报错:STIDSilentLiveness_E_INVALID_ARGUMENT。
 *
 *  @param time                 通过静默活体所需的最小时间, [0~dDuration), 默认3s, 建议至少为1ms,0表示无最小时间限制
 *
 *  @param frame                通过静默活体所需的最小帧数, 默认4帧, 0表示无最小帧数限制
 */
- (void)setLivenessPasslimitTime:(NSInteger)time passFrames:(NSInteger)frame;

/**
 设置人脸远近的判断条件，当参数值不在取值范围内或dCloseDistance不为0且dFarDistance大于dCloseDistance时报错:STIDSilentLiveness_E_INVALID_ARGUMENT。

 @param farDistance
 人脸高度/宽度占图像短边的比例，[0.0~1.0]，参数设置越靠近0，代表人脸距离屏幕越远，默认为0.4，如果设置为0，则无过远提示。
 @param closeDistance
 人脸高度/宽度占图像短边的比例，[0.0~1.0]，参数设置越靠近1，代表人脸距离屏幕越近，默认为0.8，如果设置为0，则无过近提示。

 */
- (void)setLivenessFaceTooFar:(CGFloat)farDistance tooClose:(CGFloat)closeDistance;

/**
 对连续输入帧进行人脸跟踪及活体检测

 @param sampleBuffer           每一帧的图像数据
 @param faceOrientation        人脸的朝向
 @param previewframe           视频预览框的frame
 @param videoOrientation       相机的方向
 @param isVideoMirrored        是否镜像
 */
- (void)trackAndDetectWithCMSampleBuffer:(CMSampleBufferRef)sampleBuffer
                          faceOrientaion:(STIDSilentLivenessFaceOrientaion)faceOrientation
                            previewframe:(CGRect)previewframe
                        videoOrientation:(AVCaptureVideoOrientation)videoOrientation
                         isVideoMirrored:(BOOL)isVideoMirrored;

/**
 *  开始检测
 */

- (void)startDetection;

/**
 *  取消检测
 */

- (void)cancelDetection;

/**
 *  获取SDK版本
 *
 *  @return                     SDK版本
 */

+ (NSString *)getVersion;

@end
