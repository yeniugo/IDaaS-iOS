//
//  TRUFaceBaseViewController.h
//  UniformIdentityAuthentication
//
//  Created by Trusfort on 2017/1/5.
//  Copyright © 2017年 Trusfort. All rights reserved.
//

#import "TRUBaseViewController.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "STSilentLivenessDetector.h"
#import "STSilentLivenessDetectorDelegate.h"
#import "STSilentLivenessFaceEnumType.h"

@interface TRUFaceBaseViewController : TRUBaseViewController
@property (strong, nonatomic) STSilentLivenessDetector *detector;
//@property (assign, nonatomic) int maxDetectionTimes;//最大检测次数
//@property (nonatomic, copy) void (^authFailure)();//检测失败后执行
- (void) onDetectSuccessWithImages:(NSArray *) images;
- (void) onDetectFailWithMessage:(NSString *) message;
- (void) restartDetection;
- (void)onBackButton;
@end
