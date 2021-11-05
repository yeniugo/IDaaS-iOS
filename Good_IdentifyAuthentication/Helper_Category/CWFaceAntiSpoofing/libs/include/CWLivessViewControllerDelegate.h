//
//  CWLivessViewControllerDelegate.h
//  CloudwalkFaceSDKDemo
//
//  Created by 马辉 on 2021/1/26.
//  Copyright © 2021 DengWuPing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CWNormalMacroDefine.h"


NS_ASSUME_NONNULL_BEGIN


@protocol CWLivessViewControllerDelegate <NSObject>

@optional

/**
 检测动作取消
 */
- (void)onLivenessCancel;

/**
 检测退出页面返回对应的错误code码
 */
- (void)onLivenessCancelWithErrorCode:(NSInteger)code;

/**
 活体检测成功

 @param viewController 活体检测 UI Controller
 @param bestFaceOriginData 最佳人脸原图的数据
 @param backendHackData 用于后端防hack的数据
 @param resultDataDict 其他的数据  ScreenImage:截屏数据  bestFaceCropData：裁剪图   VideoData：录制的视频数据
 */
- (void)viewController:(UIViewController *_Nullable)viewController
    bestFaceOriginData:(NSData *_Nullable)bestFaceOriginData
            resultDataDict:(NSDictionary *)resultDataDict
       backendHackData:(NSString *_Nullable)backendHackData;
/**
 活体检测失败

 @param viewController 活体检测 UI Controller
 @param errCode 错误码
 */
- (void)viewController:(UIViewController *_Nullable)viewController
livenessDetectionFailed:(NSInteger)errCode;

/**
 活体检测代理方法

 @param isAlive 是否是活体
 @param code 返回所有的错误码   0 成功，其他错误码
 @param bestFaceData 获取的最佳人脸图片
 @param jsonStr 后端防hack攻击加密字符串（此字符串已按照接口文档封装好，调用后端防攻击接口时直接post该字符串即可）
 */
-(void)cwIntergrationLivess:(BOOL)isAlive
                  errorCode:(NSInteger)code
              BestFaceImage:(NSData  *_Nullable)bestFaceData
                encryptJson:(NSString * _Nullable)jsonStr CW_FUNCTION_UNAVAILABLE("已过时，请及时使用新接口 - viewController: livenessDetectionSuccess: bestFaceOriginData: bestFaceNextFrameData:");

/**
 活体检测代理方法

 @param isAlive 是否是活体
 @param code 返回所有的错误码   0 成功，其他错误码
 @param bestFaceData 获取的最佳人脸裁剪图片
 @param originalFaceImage 获取的最佳人脸原图片
 @param livessImagArray 活体检测通过时获取的照片
 @param actionArray 活体动作数组
 @param jsonStr 后端防hack攻击加密字符串（此字符串已按照接口文档封装好，调用后端防攻击接口时直接post该字符串即可）
 */
-(void)cwIntergrationLivess:(BOOL)isAlive
                  errorCode:(NSInteger)code
              BestFaceImage:(NSData  * _Nullable)bestFaceData
          originalFaceImage:(NSData  * _Nullable)originalFaceImage
               livessImages:(NSArray *_Nullable)livessImagArray
                actionArray:(NSArray *_Nullable)actionArray
                encryptJson:(NSString * _Nullable)jsonStr  CW_FUNCTION_UNAVAILABLE("已过时，请及时使用新接口 - viewController: livenessDetectionSuccess: bestFaceOriginData: bestFaceNextFrameData:");



//核身通过后的图片数据
- (void)onLivenessSuccess:(NSData*_Nullable)detectedData
          originImageData:(NSData*_Nullable)originImageData  CW_FUNCTION_UNAVAILABLE("已过时，请及时使用新接口 - viewController: livenessDetectionSuccess: bestFaceOriginData: bestFaceNextFrameData:");

//核身失败后的原因，图片数据
- (void)onLivenessFail:(NSString *_Nullable)reason
          detectedData:(NSData *_Nullable)detectedData  CW_FUNCTION_UNAVAILABLE("已过时，请及时使用新接口 - viewController: livenessDetectionFailed: detectedData:");
@end

NS_ASSUME_NONNULL_END
