//
//  STSilentLivenessDetectorDelegate.h
//
//  Created by sluin on 15/12/4.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STSilentLivenessFaceEnumType.h"
#import "STSilentLivenessEnumTypeHeader.h"
#import "STSilentLivenessImage.h"
#import "STSilentLivenessRect.h"
#import "STSilentLivenessFace.h"

/**
 *  活体检测器代理
 */
@protocol STSilentLivenessDetectorDelegate <NSObject>

@required

/**
 *  活体检测成功回调
 *
 *  @param protobufData         回传加密后的二进制数据
 *  @param imageArr             根据指定输出方案回传 STSilentImage 数组 , STSilentImage属性见 STSilentImage.h
 *  @param faceRectArr          根据指定输出方案回传 STSilentRect 数组 , STSilentRect属性见 STSilentRect.h
 */
- (void)silentLivenessDidSuccessfulGetProtobufData:(NSData *)protobufData
                                            images:(NSArray *)imageArr
                                         faceRects:(NSArray *)faceRectArr;

/**
 *  活体检测失败回调
 *
 *  @param livenessResult      运行结果STIDSilentLivenessResult
 *  @param faceError           活体检测失败类型
 *  @param protobufData        回传加密后的二进制数据
 *  @param imageArr            根据指定输出方案回传 STSilentImage 数组 , STSilentImage属性见 STSilentImage.h
 *  @param faceRectArr         根据指定输出方案回传 STSilentRect 数组 , STSilentRect属性见 STSilentRect.h
 */
- (void)silentLivenessDidFailWithLivenessResult:(STIDSilentLivenessResult)livenessResult
                                      faceError:(STIDSilentLivenessFaceError)faceError
                                   protobufData:(NSData *)protobufData
                                         images:(NSArray *)imageArr
                                      faceRects:(NSArray *)faceRectArr;

/**
 *  活体检测被取消的回调
 */
- (void)silentLivenessDidCancel;

@optional

/**
 *  活体检测过程中
 *  @param distanceStatus       人脸的远近
 *  @param boundStatus          人脸的位置
 *  @param silentFace           人脸属性
 */
- (void)silentLivenessDistanceStatus:(STIDSilentLivenessFaceDistanceStatus)distanceStatus
                         boundStatus:(STIDSilentLivenessFaceBoundStatus)boundStatus
                          silentFace:(STSilentLivenessFace *)silentFace;

/**
 *  每一帧数据回调一次,返回每帧人脸框位置信息.
 *
 *  @param rect                 返回每帧人脸框在屏幕上的位置信息
 */

- (void)silentLivenessFaceRect:(CGRect)rect;

/**
 * 帧率
 */
- (void)silentLivenessVideoFrameRate:(int)rate;

@end
