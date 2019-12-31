//
//  STSilentLivenessController.h
//  STSilentLivenessController
//
//  Created by huoqiuliang on 16/8/15.
//  Copyright © 2016年 sensetime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "STSilentLivenessDetector.h"
#import "STSilentLivenessDetectorDelegate.h"
#import "STSilentLivenessFaceEnumType.h"

@protocol STSilentLivenessControllerDelegate <NSObject>

- (void)silentLivenessControllerDeveiceError:(STIDSilentLivenessDeveiceError)deveiceError;

@end

@interface STSilentLivenessController : UIViewController

@property (strong, nonatomic) STSilentLivenessDetector *detector;


/**
 初始化方法
 @param  delegate 回调代理
 @return 静默活体检测器实例
 */
- (instancetype)initWithSetDelegate:(id<STSilentLivenessDetectorDelegate, STSilentLivenessControllerDelegate>)delegate;

/**
 获取SDK版本

 @return SDK版本
 */
+ (NSString *)getVersion;

@end
